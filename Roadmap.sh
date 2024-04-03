# day to day commands

# bash on pilot host
docker compose exec -it pilot bash
su - srvadmin
ssh host1
ssh host1.localdomain

# CLI
# pilot: ansible/01-CLI directory
# with user/password: -k
ansible -i hosts -k -m ping all
ansible -i hosts -u srvadmin -k -m ping all
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.ping all

# python interpreter discovery
# https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html
# /etc/ansible/ansible.cfg
sudo mkdir /etc/ansible
sudo vi /etc/ansible/ansible.cfg
# content:
[defaults]
interpreter_python=/usr/bin/python3

# module file
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" all
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory mode=0750" all
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=absent" all
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" servers
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" special

# pattern for target servers
# https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html#intro-patterns
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" "server*"
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" "host*.localdomain"
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" "host*.localdomain"
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" "servers:!host2.localdomain"
ansible -i hosts_python -u srvadmin -k -m ansible.builtin.file -a "path=/tmp/dummy state=directory" 'servers:!host2.localdomain'

# Ansible Project with playbook: 02-deployuser
ansible-playbook -i hosts -u srvadmin -k -K playbook-deployuser.yml  

# check collections already installed:
ansible-galaxy collection list
# install a collection
sudo ansible-galaxy collection install community.general

# generate ssh key
 ssh-keygen
 # file: /home/srvadmin/.ssh/id_rsa_deploy
 # passphrase: <a long passphrase>
 
 # checkup keys:
 ls ~/.ssh

# ansible with deploy user, specifying key and passphrase
ansible -i hosts --private-key ~/.ssh/id_rsa_deploy -u deploy -m ping all 

ssh-agent
# copy-paste output
ssh-add ~/.ssh/id_rsa_deploy
# type ONCE passphrase
# checkup identities managed by agent
ssh-add -L
# connect to remote host without password (key unlocked)
ssh deploy@host1
ansible -i hosts -u deploy -m ping all 
# after deployment: remove unlocked key from agent
ssh-key -D

# 1st day afternoon
# user deploy as a variable
# cleanup playbook(s)
# - remove user from sudoers
# - remove user from target hosts

# https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html

# with variable user_deploy inside playbook or in group_vars/all[.yml]
ansible-playbook -i hosts -u deployer playbook-deployuser.yml 

# group_vars/all[.yml] content
user_deploy: deployer

# alt.
# group_vars/all.json content
{
    "user_deploy": "deploy"
}

ansible-playbook -i hosts -u deploy -e "user_deploy=deploy007" playbook-deployuser.yml 

# Exercise: write a playbook to deactive deployment user sharing the same variable user_deploy
ansible-playbook -i hosts -u deploy -e "user_deploy=deploy007" playbook-deactivateuser.yml
# remove from sudoers user in group_vars/all.yml
ansible-playbook -i hosts -u deploy playbook-deactivateuser.yml
# fix the situation 
ansible-playbook -i hosts -u srvadmin -k -K playbook-deployuser.yml

# verbose mode
ansible-playbook -i hosts -u deploy -v playbook-deployuser.yml 
ansible-playbook -i hosts -u deploy -vv playbook-deployuser.yml 
ansible-playbook -i hosts -u deploy -vvv playbook-deployuser.yml 
# NB: we can see that ansible use a temporary directory on each target which is cleaned after
ssh deploy@host1 "ls -al .ansible/tmp"

# to resolve env variable on controller: ansible.builtin.env lookup
# https://docs.ansible.com/ansible/latest/collections/ansible/builtin/env_lookup.html
deployment_public_key: "{{ lookup('env', 'HOME') }}/.ssh/id_rsa_deploy.pub"
deployment_public_key: "{{ lookup('ansible.builtin.env', 'HOME') }}/.ssh/id_rsa_deploy.pub"

# Variables, magic variables, jinja filters

# Jinja Filters
# https://jinja.palletsprojects.com/en/3.1.x/templates/#builtin-filters

# Day2
# play only a part of a playbook
 ansible-playbook -i hosts --list-tasks playbook-variables.yml
 ansible-playbook -i hosts --list-tags playbook-variables.yml
 ansible-playbook -i hosts --list-hosts playbook-variables.yml
 ansible-playbook -i hosts -u deploy --start-at-task "Debug hostname" playbook-variables.yml
 ansible-playbook -i hosts -u deploy --start-at-task "Debug facts 4" playbook-variables.yml
 # https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html
 ansible-playbook -i hosts -u deploy -t PLAY3 playbook-variables.yml
 ansible-playbook -i hosts -u deploy -t PLAY1,PLAY2 playbook-variables.yml
 ansible-playbook -i hosts -u deploy -t BOOL playbook-variables.yml
 ansible-playbook -i hosts -u deploy -t HOST playbook-variables.yml # missing gathering facts
 ansible-playbook -i hosts -u deploy --skip-tags HOST playbook-variables.yml
 ansible-playbook -i hosts -u deploy -t PLAY3 --skip-tags HOST playbook-variables.yml

 # project 04: API + DB
 # create directories and files
 ansible-galaxy init roles/db
 ansible-galaxy init roles/api
 ansible-galaxy init roles/common

 ansible-playbook -i hosts -u deploy playbook-install.yml
 ansible-playbook -i hosts -u deploy -t API playbook-install.yml
 ansible-playbook -i hosts -u deploy -t DB  playbook-install.yml
