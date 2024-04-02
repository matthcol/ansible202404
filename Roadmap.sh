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
