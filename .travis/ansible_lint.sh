#!/bin/sh

LIST='echo Ansible lint'
for ansible_yml in ansible/playbooks/*.yml ; do
  LIST="${LIST} && echo Run linter for '$ansible_yml' && ansible-lint $ansible_yml"
done

docker exec hw-test bash -c "${LIST}"
