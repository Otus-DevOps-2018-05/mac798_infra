#!/bin/sh
TERRAFORM_ENV="stage prod"

for env in $TERRAFORM_ENV; do
  cd ./terraform/$env
  echo Validating terraform environment $env
  terraform validate || exit 1
  echo Run linter on terraform files in `pwd`
  tflint *.tf || exit 1
  cd "$wd"
done
