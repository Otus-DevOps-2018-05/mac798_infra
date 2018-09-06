#!/bin/sh
TERRAFORM_ENV="stage prod"

for env in $TERRAFORM_ENV; do
  docker exec hw-test bash -c "cd ./terraform/$env && echo terraform validate `pwd` && terraform init && terraform validate && echo Run linter on terraform files in `pwd` && tflint *.tf"
done
