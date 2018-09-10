#!/bin/sh
TERRAFORM_ENV="stage prod"

for env in $TERRAFORM_ENV; do
  docker exec hw-test bash -c "cd ./terraform/$env && echo terraform validate `pwd` && mv backend.tf backend.tf~ && cp terraform.tfvars.example terraform.tfvars && terraform init && terraform validate && echo Run linter on terraform files in `pwd` && tflint *.tf backend.tf~" || exit 1
done
