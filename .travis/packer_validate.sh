#!/bin/sh
wd=`pwd`

if [ -f packer/variables.json ]; then
  var_file_base=variables.json
else
  var_file_base=variables.json.example
fi

LIST="echo 'PACKER VALIDATE'"

for pk_tpl in `find ./packer -name \\*.json -and -not -name variables.json`; do
  if grep '"playbook_file": *"ansible/' "$pk_tpl" ; then
    LIST="$LIST && echo $pk_tpl && packer validate -var-file=packer/$var_file_base $pk_tpl"
  else
    LIST="$LIST && echo $pk_tpl && cd packer && packer validate -var-file=$var_file_base ../$pk_tpl && cd .."
  fi
done

docker exec hw-test bash -c "${LIST}"
