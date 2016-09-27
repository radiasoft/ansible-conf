#!/bin/bash

set -e -x

if ! $(id -u vagrant > /dev/null 2>&1); then
    groupadd -g 1000 vagrant
    useradd -u 1000 -g vagrant vagrant
fi

tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

dnf install -y nfs-utils htop nmap tmux vim tcpdump nmap iftop docker-engine

echo net.ipv4.ip_forward=1 > /etc/sysctl.d/50-bivio-docker.conf
echo okv14-2-5b.bivio.biz > /etc/hostname
chcon -Rt svirt_sandbox_file_t /home/vagrant
mkdir -p /var/db/sirepo
chown vagrant:vagrant /var/db/sirepo
echo 'nfs-ext.alpha.sirepo.com:/var/db/sirepo /var/db/sirepo nfs nolock' >> /etc/fstab
mount -a
# https://github.com/docker/docker/issues/4213#issuecomment-89316474
# allow docker access of nfs volumes
setsebool -P virt_use_nfs on
#setsebool -P virt_sandbox_use_nfs on
mkdir /var/lib/celery-sirepo
chown vagrant:vagrant /var/lib/celery-sirepo
chcon -Rt svirt_sandbox_file_t /var/lib/celery-sirepo

cat > /etc/systemd/system/celery-sirepo.service <<'EOF'
[Unit]
Description=Celery Sirepo
Requires=docker.service
After=docker.service

[Service]
Restart=on-failure
RestartSec=10
ExecStart=/usr/bin/docker run --rm -v /var/lib/celery-sirepo:/var/lib/celery-sirepo -v /var/db/sirepo:/var/db/sirepo --name %p radiasoft/sirepo:beta bash -c "/radia-run $(id -u vagrant) $(id -g vagrant) /var/lib/celery-sirepo/bivio-service"
ExecStop=-/usr/bin/docker stop -t 2 %p

[Install]
WantedBy=multi-user.target
EOF

cat > /var/lib/celery-sirepo/bivio-service <<'EOF'
#!/bin/bash
. ~/.bashrc
set -e
cd '/var/lib/celery-sirepo'
export 'BIVIO_SERVICE_DIR=/var/lib/celery-sirepo'
export 'BIVIO_SERVICE_CHANNEL=beta'
export 'PYKERN_PKCONFIG_CHANNEL=beta'
export 'SIREPO_CELERY_TASKS_BROKER_URL=amqp://guest@rabbitmq.beta.sirepo.com//'
export 'PYTHONUNBUFFERED=1'
export 'SIREPO_CELERY_TASKS_CELERYD_CONCURRENCY=2'
export 'SIREPO_CELERY_TASKS_CELERYD_TIME_LIMIT=43200'
export 'SIREPO_MPI_CORES=8'
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) celery worker -A sirepo.celery_tasks -l info -f celery.log" > init.log
env >> init.log
'celery' 'worker' '-A' 'sirepo.celery_tasks' '-f' 'celery.log' '-l' 'info' '-Q' 'celery,parallel' >> init.log 2>&1
EOF

chown vagrant:vagrant /var/lib/celery-sirepo/bivio-service
chmod ug+x /var/lib/celery-sirepo/bivio-service


cat > /etc/sysctl.d/40-bivio-shm.conf <<'EOF'
# Controls the maximum size of a message, in bytes
kernel.msgmnb = 65536

# Controls the default maxmimum size of a message queue
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
# 1TB should be enough for any machine we own
kernel.shmmax = 1099511627776

# Controls the maximum number of shared memory segments, in pages
# (4x shmmax / getconf PAGESIZE [4096])
kernel.shmall = 1073741824
EOF

sysctl -p

systemctl enable docker.service
systemctl start docker.service
systemctl enable celery-sirepo.service
systemctl start celery-sirepo.service

