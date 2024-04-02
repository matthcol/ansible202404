FROM debian:bookworm
RUN mkdir /var/run/sshd; \
    apt update && apt-get install -y tzdata openssh-server sudo python3 ansible vim sshpass tree; \
    useradd -s /usr/bin/bash -m -G sudo srvadmin; \
    mkdir /home/srvadmin/ansible; \
    chown srvadmin:srvadmin  /home/srvadmin/ansible; \
    mkdir /mnt/artifacts; \
    chown srvadmin:srvadmin  /mnt/artifacts

# entrypoint
RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime'; \
    echo 'echo "root:${ROOT_PASSWORD}" | chpasswd'; \
    echo 'echo "srvadmin:${ADMIN_PASSWORD}" | chpasswd'; \
    echo 'exec "$@"'; \
    } > /usr/local/bin/entry_point.sh; \
    chmod +x /usr/local/bin/entry_point.sh;

ENV TZ Europe/Paris

ENV ROOT_PASSWORD password
ENV ADMIN_PASSWORD password

EXPOSE 22

ENTRYPOINT ["entry_point.sh"]
CMD    ["/usr/sbin/sshd", "-D", "-e"]