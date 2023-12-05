set -e

apt update
apt-get install -y python3 python3-pip curl

curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron

rm -rf /var/lib/apt/lists/*

pip3 install awscli