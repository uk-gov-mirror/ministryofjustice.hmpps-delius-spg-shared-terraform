#!/bin/bash

# Set any ECS agent configuration options
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
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
file = /var/log/${container_name}/*.log
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
file = /var/log/ecs/ecs-agent.log
log_group_name = ${log_group_name}
log_stream_name = {hostname}/{container_instance_id}/ecsagent_logs
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log
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

service awslogs start
chkconfig awslogs on

# Mount our EBS volume on boot
cp /usr/share/zoneinfo/Europe/London /etc/localtime

mkdir -p ${keys_dir}

pvcreate ${ebs_device}

vgcreate data ${ebs_device}

lvcreate -l100%VG -n keys data

mkfs.xfs /dev/data/keys

echo "/dev/mapper/data-keys ${keys_dir} xfs defaults 0 0" >> /etc/fstab

mount -a


#ansible and users
sudo yum install -y \
    git \
    wget \
    yum-utils

sudo easy_install pip

PATH=/usr/local/bin:$PATH


sudo pip install ansible==2.6 virtualenv awscli boto botocore boto3

echo 'downloading users'
/usr/bin/curl -o ~/users.yml https://raw.githubusercontent.com/ministryofjustice/hmpps-delius-ansible/master/group_vars/dev.yml
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