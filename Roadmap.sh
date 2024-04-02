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

