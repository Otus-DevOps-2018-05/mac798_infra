#!/bin/sh
wd=`pwd`

echo "Checking ansible installation"
ANSIBLE_PLAYBOOK=`which ansible-playbook`
if [ -z "${ANSIBLE_PLAYBOOK}" ]; then
  ANSIBLE_PLAYBOOK=`find / -type f -executable -name ansible-playbook 2>/dev/null|head -1`
fi

if [ -f packer/variables.json ]; then
  var_file_base=variables.json
else
  var_file_base=variables.json.example
fi

for pk_tpl in `find ./packer -name \\*.json -and -not -name variables.json`; do
  echo "Validating $pk_tpl"
  if grep '"playbook_file": *"ansible/' "$pk_tpl" ; then
    if [ -z "${ANSIBLE_PLAYBOOK}" ]; then
      echo "No ansible-playbook executable found, skip validation of $pk_tpl"
      continue
    fi
    val_file="$pk_tpl"
    var_file=packer/$var_file_base
  else
    cd "$wd/packer"
    val_file="../$pk_tpl"
    var_file=$var_file_base
  fi
  echo   packer validate -var-file=$var_file "$val_file"
  packer validate -var-file=$var_file "$val_file" || exit 1
  cd "$wd"
done
