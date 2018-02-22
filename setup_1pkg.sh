
# -------------------------------------------------------------------------------
# Setup base packages and supervisor
apt-get update \
  && apt-get upgrade -y --no-install-recommends \
  && apt-get install \
    wget curl mc python-setuptools jq ca-certificates unzip xz-utils gawk apt-transport-https git make sudo supervisor \
    -y --no-install-recommends \
  && echo "alias svd=\"supervisorctl -c /etc/supervisor/supervisord.conf\"" >> /root/.bashrc \
