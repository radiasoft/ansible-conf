#!/bin/bash

set -e -x

CHANNEL=$1
WORKER_IP=$2

# For IPv4 only
function extract_ip_pos {
    echo $WORKER_IP | cut -d '.' -f $1
}

WORKER_HOST="okv14-$(extract_ip_pos 3)-$(extract_ip_pos 4)b.bivio.biz"

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
# Setting /etc/hostname, using hostnamectl or $DHCP_HOSTNAME don't work
# hostnamectl set-hostname --static "$WORKER_HOST"
chcon -Rt svirt_sandbox_file_t /home/vagrant
mkdir -p /var/db/sirepo
chown vagrant:vagrant /var/db/sirepo
echo "nfs-ext.${CHANNEL}.sirepo.com:/var/db/sirepo /var/db/sirepo nfs nolock" >> /etc/fstab
mount -a
# https://github.com/docker/docker/issues/4213#issuecomment-89316474
# allow docker access of nfs volumes
setsebool -P virt_use_nfs on
#setsebool -P virt_sandbox_use_nfs on
mkdir /var/lib/celery-sirepo
chown vagrant:vagrant /var/lib/celery-sirepo
chcon -Rt svirt_sandbox_file_t /var/lib/celery-sirepo

cat > /etc/systemd/system/celery-sirepo.service <<EOF
[Unit]
Description=Celery Sirepo
Requires=docker.service
After=docker.service

[Service]
Restart=on-failure
RestartSec=10
ExecStartPre=/usr/bin/docker pull radiasoft/sirepo:${CHANNEL}
ExecStart=/usr/bin/docker run --tty --rm --volume=/var/lib/celery-sirepo:/var/lib/celery-sirepo --volume=/var/db/sirepo:/var/db/sirepo --name %p --hostname c-%H radiasoft/sirepo:${CHANNEL} bash -c "/radia-run \$(id -u vagrant) \$(id -g vagrant) /var/lib/celery-sirepo/bivio-service"
ExecStop=-/usr/bin/docker stop -t 2 %p

[Install]
WantedBy=multi-user.target
EOF

(cat <<EOF1 && cat <<'EOF2') > /var/lib/celery-sirepo/bivio-service
#!/bin/bash
. ~/.bashrc
set -e
export 'BIVIO_SERVICE_CHANNEL=$CHANNEL'
EOF1
cd /var/lib/celery-sirepo
export BIVIO_SERVICE_DIR=/var/lib/celery-sirepo
export PYKERN_PKCONFIG_CHANNEL=$BIVIO_SERVICE_CHANNEL
export PYKERN_PKDEBUG_REDIRECT_LOGGING=1
export PYKERN_PKDEBUG_WANT_PID_TIME=1
export PYTHONUNBUFFERED=1
export SIREPO_CELERY_TASKS_BROKER_URL=amqp://guest@rabbitmq-ext.$BIVIO_SERVICE_CHANNEL.sirepo.com//
export SIREPO_CELERY_TASKS_CELERYD_CONCURRENCY=1
export SIREPO_CELERY_TASKS_CELERYD_TIME_LIMIT=43200
export SIREPO_SIMULATION_DB_NFS_TRIES=10
export SIREPO_SIMULATION_DB_NFS_SLEEP=0.5
case $BIVIO_SERVICE_CHANNEL in
    alpha)
        export SIREPO_MPI_CORES=2
        ;;
    beta)
        export SIREPO_MPI_CORES=8
        ;;
    *)
         echo $"$BIVIO_SERVICE_CHANNEL: unsupported BIVIO_SERVICE_CHANNEL"
         exit 1
         ;;
esac
if [[ -f init.log ]]; then
    mv -f init.log $(date +%Y%m%d%H%M%S)-init.log
fi
cmd=( celery worker -A sirepo.celery_tasks -Ofair -Q parallel )
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${cmd[@]}" > init.log
env >> init.log
"${cmd[@]}" >> init.log 2>&1
EOF2

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

