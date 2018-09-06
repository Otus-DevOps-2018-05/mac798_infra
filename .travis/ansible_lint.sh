#!/bin/sh
ANSIBLE_LINT=`which ansible-lint`
if [ "${ANSIBLE_LINT}" = "" ]; then
  ANSIBLE_LINT=`find / -type f -executable -name ansible-lint 2>/dev/null|head -1`
  [ "${ANSIBLE_LINT}" = "" ] && exit 1
fi
echo Ansible lint "(${ANSIBLE_LINT})"
for ansible_yml in ansible/playbooks/*.yml ; do
  echo Run linter for $ansible_yml
  ${ANSIBLE_LINT} $ansible_yml || exit 1
done
