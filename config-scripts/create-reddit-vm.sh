#!/bin/sh

MY_GCP_PROJ=infra-207721
IMAGE_FAMILY=reddit-full


IMAGE=`gcloud compute images list  | grep "\\s\+${MY_GCP_PROJ}\\s\+${IMAGE_FAMILY}" |sed 's#\s.*##'|tail -1`

if [ -z "$IMAGE" ]; then
  cwd=`pwd`
  packer_file_dir=`dirname $0`
  if [ -z "$packer_file_dir" ]; then
    packer_file_dir="../packer"
  else
    packer_file_dir="$packer_file_dir/../packer"
  fi

  echo "packer_file_dir=$packer_file_dir"
  cd $packer_file_dir
  packer build -var-file=variables.json immutable.json
  cd "$cwd"
  IMAGE=`gcloud compute images list  | grep "\\s\+${MY_GCP_PROJ}\\s\+${IMAGE_FAMILY}" |sed 's#\s.*##'|tail -1`
fi

if [ -z "$IMAGE" ]; then
  echo No image was created
  exit 1
fi

gcloud compute instances create reddit-app-$(date +%Y%m%d%H%M%S) --image=$IMAGE --image-project=$MY_GCP_PROJ --machine-type=g1-small --tags puma-server --restart-on-failure
