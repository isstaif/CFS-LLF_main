# /usr/local/bin/start-rd-hashd.sh
#!/bin/bash
source /etc/CFS-LLF_env
cd "$REPO_DIR" || exit 1
exec /usr/local/bin/rd-hashd --args $1