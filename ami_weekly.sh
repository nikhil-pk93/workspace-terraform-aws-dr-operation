#!/bin/bash
###################################################################
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io
####################################################################

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

arg1="${1:-}"

#####################################################################
# EC2 Snapshot Copy Script. Copyright (c) 2019 technipun.com
####################################################################



DATE=`date +"%Y-%m-%d"`
name="project_prod_node_${DATE}"
IMAGE_ID=$(aws ec2 create-image \
    --instance-id  i-0c72eb8eda86065f8 \
    --name "${name}" \
    --description "AMI for project DR" \
    --no-reboot \
    --output text)


aws ec2 create-tags \
  --resources "${IMAGE_ID}" --tags Key=Name,Value="${name}"

echo "Latest AMI ID is: '"${IMAGE_ID}"'"


COPY_AMI=$(aws ec2 copy-image \
    --region  me-south-1 \
    --name "project_prod_node_${DATE}"\
    --source-region me-central-1 \
    --source-image-id ${IMAGE_ID} \
    --description "This is my copied AMI." \
    --output text )

echo " The AMI is : '"${COPY_AMI}"'"


echo "Waiting for the AMI to become available..."
while true; do
    isAvailable=$(aws ec2 describe-images --image-ids ${COPY_AMI} --region "me-south-1" --query 'Images[*].State' --output text)
    if [[ "${isAvailable}" == "available" ]]; then
        echo "AMI is available"
        break
    elif [[ "${isAvailable}" == "InvalidAMIID.NotFound" ]]; then
        echo "Error: The AMI ID '${COPY_AMI}' does not exist"
        exit 1
    else
        echo "AMI is not yet available, waiting..."
        sleep 120
    fi
done



echo "Copy process has been started. The AMI is : '"${COPY_AMI}"'

# aws ec2 create-tags \
#    --resources "${COPY_AMI}" --tags Key=Name,Value="${name}"



    

