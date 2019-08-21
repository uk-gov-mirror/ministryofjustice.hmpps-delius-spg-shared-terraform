#!/bin/bash

service docker start

sudo -i

yum install -y java-1.8.0-openjdk-devel

export JAVA_HOME=/usr/lib/jvm/java-1.8.0

yum install -y \
    git \
    wget \
    yum-utils

easy_install pip

PATH=/usr/local/bin:$PATH:$JAVA_HOME/bin

pip install ansible==2.6 virtualenv awscli boto botocore boto3

echo 'downloading users - may need to apply some other settings to ensure users are able to read and write to spg group, ie change config'
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
