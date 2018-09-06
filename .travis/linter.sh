#!/bin/#!/bin/sh
wd=`pwd`

echo "Checking ansible installation"
which ansible-playbook || pip install ansible || exit 1

if [ -f packer/variables.json ]; then
  var_file_base=variables.json
else
  var_file_base=variables.json.example
fi

for pk_tpl in `find ./packer -name \\*.json -and -not -name variables.json`; do
  echo "Validating $pk_tpl"
  if grep '"playbook_file": *"ansible/' "$pk_tpl" ; then
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

TERRAFORM_ENV="stage prod"

for env in $TERRAFORM_ENV; do
  cd ./terraform/$env
  echo Validating terraform environment $env
  terraform validate || exit 1
  echo Run linter on terraform files in `pwd`
  tflint *.tf || exit 1
  cd "$wd"
done

for ansible_yml in ansible/playbooks/*.yml ; do
  echo Run linter for $ansible_yml
  ansible-lint $ansible_yml || exit 1
done
