#!/bin/sh
wd=`pwd`

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
    WD=$wd
  else
    WD="$wd/packer"
    val_file="../$pk_tpl"
    var_file=$var_file_base
  fi
  echo   packer validate -var-file=$var_file "$val_file"
  docker exec hw-test bash -c "cd '$WD'; packer validate -var-file=$var_file '$val_file'" || exit 1
done
