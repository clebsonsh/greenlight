#!/bin/bash
set -eu

sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE greenlight TO greenlight"
sudo -i -u postgres psql -c "ALTER DATABASE greenlight OWNER to greenlight"
sudo sh < <(curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh)

ufw allow 8025/tcp
ufw --force enable
