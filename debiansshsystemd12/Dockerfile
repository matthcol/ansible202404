FROM debian:bookworm

ENV container docker
ENV DEBIAN_FRONTEND noninteractive

# SYSTEMD
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv

# SSH
RUN mkdir /var/run/sshd; \
    apt update && apt-get install -y tzdata openssh-server sudo python3; \
    apt-get clean

# USER ADMIN
RUN  useradd -s /usr/bin/bash -m -G sudo srvadmin

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

VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 22

ENTRYPOINT ["entry_point.sh"]
CMD ["/lib/systemd/systemd"]