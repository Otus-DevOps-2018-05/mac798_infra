#!/bin/sh
ANSIBLE_LINT=`which ansible-lint`
if [ -z "${ANSIBLE_LINT}" ]; then
  ANSIBLE_LINT=`find / -type f -executable -name ansible-lint 2>/dev/null|head -1`
  test -z "${ANSIBLE_LINT}" || exit 1
fi
echo Ansible lint
for ansible_yml in ansible/playbooks/*.yml ; do
  echo Run linter for $ansible_yml
  ansible-lint $ansible_yml || exit 1
done
