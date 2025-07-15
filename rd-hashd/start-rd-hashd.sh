#!/bin/bash
source /etc/CFS-LLF_env
cd "$REPO_DIR" || exit 1
exec /home/aati2/resctl-demo/target/rd-hashd --args "rd-hashd/args/args-$1.json"
