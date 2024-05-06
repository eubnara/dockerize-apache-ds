#!/bin/bash

while true; do
    success=1
    for target in ambari-mysql.example.com:3306 ambari-yum-repo.example.com; do
        curl $target >/dev/null 2>&1
        if [[ "$?" != "0" ]]; then
            success=0
            echo "cannot contact $target sleep and try again"
            break
        fi
    done
    if [[ "$success" == "1" ]]; then
        break
    fi
    sleep 5
done

ansible-playbook /root/ansible/post_ambari_server.yml
ambari-server start
bash -c "trap : TERM INT; sleep infinity & wait"
