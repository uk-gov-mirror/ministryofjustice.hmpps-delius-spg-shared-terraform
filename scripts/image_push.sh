#!/bin/sh
set -e
if [ $# -ne 2 ]; then
	echo "requires 2 arguments 1=CONFIG_BRANCH, 2=ENVIRONMENT_NAME"
	exit 1
fi

CONFIG_BRANCH=$1
ENVIRONMENT_NAME=$2

echo "CONFIG_BRANCH = $CONFIG_BRANCH"

echo 'cloning env configs'
git clone -b ${CONFIG_BRANCH} git@github.com:ministryofjustice/hmpps-env-configs.git $(pwd)/env_configs
ls -laR
CUSTOM_COMMON_PROPERTIES_DIR=$(pwd)/env_configs/common
source $(pwd)/env_configs/${ENVIRONMENT_NAME}/${ENVIRONMENT_NAME}.properties

# Error handler function
exit_on_error() {
  exit_code=$1
  last_command=${@:2}
  if [ $exit_code -ne 0 ]; then
      >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
      exit ${exit_code}
  fi
}

# creds temp file
echo "--> Using creds file ~/.slave_creds_run"
creds_file=~/.slave_creds_run

source_image="hmpps/spg"

source_ecr_repo=$(aws --region eu-west-2 ecr describe-repositories --repository-names ${source_image} | jq .repositories[0].repositoryUri  | sed -e 's/^"//' -e 's/"$//')
exit_on_error $? !!
echo "--> Using repo source ${source_ecr_repo}"


region=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
exit_on_error $? !!

# login
eval $(aws ecr get-login --no-include-email --region ${region})
exit_on_error $? !!

# pull image
echo "-> Pulling image ${source_ecr_repo}"
docker pull "${source_ecr_repo}:latest"
exit_on_error $? !!
echo "--> Image pull success"

# PUSH
dest_ecr_repo_name="${TG_ENVIRONMENT_IDENTIFIER}-gw-ecr-repo"

temp_role=$(aws sts assume-role --role-arn ${TERRAGRUNT_IAM_ROLE} --role-session-name testing --duration-seconds 900)

echo "-> Pushing image ${source_ecr_repo} using role ${TERRAGRUNT_IAM_ROLE}"

echo "export AWS_ACCESS_KEY_ID=$(echo ${temp_role} | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo ${temp_role} | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo ${temp_role} | jq .Credentials.SessionToken | xargs)" > ${creds_file}
exit_on_error $? !!

source ${creds_file}
exit_on_error $? !!

# login
eval $(aws ecr get-login --no-include-email --region ${region})
exit_on_error $? !!

dest_ecr_repo=$(aws --region eu-west-2 ecr describe-repositories --repository-names "${dest_ecr_repo_name}" | jq .repositories[0].repositoryUri  | sed -e 's/^"//' -e 's/"$//')
exit_on_error $? !!

docker tag "${source_ecr_repo}:latest" ${dest_ecr_repo}
exit_on_error $? !!

docker push ${dest_ecr_repo}
exit_on_error $? !!
echo "--> Image push success"

# dont prune til end of jenkins pipeline
#docker system prune -a -f
#exit_on_error $? !!
#echo "-> Image cleanup success"