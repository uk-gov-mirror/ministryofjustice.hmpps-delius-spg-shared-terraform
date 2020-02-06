#!/bin/bash

# Set any ECS agent configuration options
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
echo "ECS_CONTAINER_STOP_TIMEOUT=${esc_container_stop_timeout}" >> /etc/ecs/ecs.config
service docker start
start ecs

# Install awslogs and the jq JSON parser
yum install -y awslogs jq

mkdir -p /var/log/${container_name}

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state

[application_log]
#check for *.log* so that if any logs roll over whilst cloudwatch is offline, they will still be picked up
file = /var/log/${container_name}/*.log*
#servicemix log is/was \nDATE\nMODULE\nOUTPUT so requires 4 lines for fingerprint to determine new content is being written to file
file_fingerprint_lines = 1-4
datetime_format = %Y-%m-%dT%H:%M:%S.%f%z
multi_line_start_pattern = {datetime_format}
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/application

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/dmesg_logs

[/var/log/messages]
file = /var/log/messages
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/messages
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/docker
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/ecsinit_logs
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log*
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/ecsagent_logs
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log*
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/ecsaudit_logs
datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF

# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
region=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

# log into AWS ECR
aws ecr get-login --no-include-email --region $region

#upstart-job
# Grab the cluster and container instance ARN from instance metadata
host_name=$(hostname -s)
container_instance_id=${container_name}
avail_zone=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Replace the cluster name and container instance ID placeholders with the actual values
sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf
sed -i -e "s/{availzone}/$avail_zone/g" /etc/awslogs/awslogs.conf
sed -i -e "s/{hostname}/$host_name/g" /etc/awslogs/awslogs.conf

#service awslogs start
#systemctl for amazon linux
    systemctl start awslogsd
chkconfig awslogs on

# Mount our EBS volume on boot
cp /usr/share/zoneinfo/Europe/London /etc/localtime

mkdir -p ${data_volume_host_path}

pvcreate ${ebs_device}

vgcreate data ${ebs_device}

lvcreate -l100%VG -n ${data_volume_name} data

mkfs.xfs /dev/data/${data_volume_name}

echo "/dev/mapper/data-${data_volume_name} ${data_volume_host_path} xfs defaults 0 0" >> /etc/fstab

mount -a


#ansible and users
sudo -i

yum install -y \
    git \
    wget \
    yum-utils

echo 'preppip' > /tmp/paul.log

easy_install pip

PATH=/usr/local/bin:$PATH


pip install ansible==2.6 virtualenv awscli boto botocore boto3

echo 'downloading users - may need to apply some other settings to ensure users are able to read and write to spg group, ie change config'
/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml
sed -i '/users_deleted:/,$d' ~/users.yml
cat << EOF > ~/requirements.yml
---

- name: users
  src: singleplatform-eng.users
EOF
 cat << EOF > ~/bootstrap-users.yml
---

- hosts: localhost
  vars_files:
   - "{{ playbook_dir }}/users.yml"
  roles:
     - users
EOF
cat << EOF > /etc/sudoers.d/webops
# Members of the webops group may gain root privileges
%webops ALL=(ALL) NOPASSWD:ALL

Defaults  use_pty, log_host, log_year, logfile="/var/log/webops.sudo.log"
EOF
echo 'creating users'
ansible-galaxy install -f -r ~/requirements.yml
ansible-playbook ~/bootstrap-users.yml

cat << 'EOF' >> ~/update_ssh_users_from_github.sh

/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/${bastion_inventory}.yml
ansible-playbook ~/bootstrap-users.yml

EOF




cat << 'EOF' >> ~/.bashrc
alias dcontainergetspgid='SPG_CONTAINER_ID="$(docker container ps | grep spg | egrep -o ^[[:alnum:]]*)"'
alias dcontainerattachtospg='dcontainergetspgid;docker container exec -it $SPG_CONTAINER_ID /bin/bash'
alias dcontainerstopspg='dcontainergetspgid;docker container stop $SPG_CONTAINER_ID'
alias dcontainerps='docker container ps'
alias dcontainerpulllatest='dcontainerpulllatest_function'
alias dcontainernetworkinspect='dcontainergetspgid;docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $SPG_CONTAINER_ID'

function dcontainerpulllatest_function() {
region=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
repo=$(docker images | grep spg | grep latest| egrep -o ^[^[:space:]]*)
eval $(aws ecr get-login --no-include-email --region $region  --registry-ids 895523100917)
docker pull $repo:latest
}

echo 'SPG Container - type dcontainerattachtospg to attach to container as root.'
echo 'once logged on, become spg user by typing "su spg"'
echo 'other aliases'
alias | grep dcont

EOF
