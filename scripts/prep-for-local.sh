#!/bin/bash

root_pass="${1:?'Root password required'}"
current_dir=$(pwd)

su - <<EOT
${root_pass}

echo "Altering docker.sock ownership…"
chown 1000:1000 /var/run/docker.sock

cd ${current_dir}
echo "Adding hosts entries…"
scripts/hosts-entries/add.sh host-gateway
EOT
