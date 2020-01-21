/* The following parameters are required from Jenkins GUI or other upstream jobs
        environment_name
        config_branch
        spg_image_version
        spg_terraform_branch
        jenkins_pipeline_branch
        confirm (boolean)
*/

def project = [:]
project.config = 'hmpps-env-configs'
project.terraform = 'hmpps-delius-spg-shared-terraform'
project.env_name = "${environment_name}"
project.image_version = "${spg_image_version}"

def prepare_env() {
    sh '''
    #!/usr/env/bin bash
    docker pull mojdigitalstudio/hmpps-terraform-builder:latest
    '''
}

def plan_submodule(submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF PLAN for ${project.env_name} | ${submodule_name} - component from git project ${project.terraform}"
        set +e
        cp -R -n "${project.config}" "${project.terraform}/env_configs"
        cd "${project.terraform}"
        docker run --rm \
            -v `pwd`:/home/tools/data \
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
            bash -c "\
                source env_configs/${project.env_name}/${project.env_name}.properties; \
                export TF_VAR_image_version=${project.image_version}; \
                cd ${submodule_name}; \
                if [ -d .terraform ]; then rm -rf .terraform; fi; sleep 5; \
                terragrunt init; \
                terragrunt plan -detailed-exitcode --out ${project.env_name}.plan > tf.plan.out; \
                exitcode=\\\"\\\$?\\\"; \
                cat tf.plan.out; \
                if [ \\\"\\\$exitcode\\\" == '1' ]; then exit 1; fi; \
                if [ \\\"\\\$exitcode\\\" == '2' ]; then \
                    parse-terraform-plan -i tf.plan.out | jq '.changedResources[] | (.action != \\\"update\\\") or (.changedAttributes | to_entries | map(.key != \\\"tags.source-hash\\\") | reduce .[] as \\\$item (false; . or \\\$item))' | jq -e -s 'reduce .[] as \\\$item (false; . or \\\$item) == false'; \
                    if [ \\\"\\\$?\\\" == '1' ]; then exitcode=2 ; else exitcode=3; fi; \
                fi; \
                echo \\\"\\\$exitcode\\\" > plan_ret;" \
            || exitcode="\$?"; \
            if [ "\$exitcode" == '1' ]; then exit 1; else exit 0; fi
        set -e
        """
        return readFile("${project.terraform}/${submodule_name}/plan_ret").trim()
    }
}

pipeline {

    agent { label "jenkins_slave" }

    stages {

        stage('setup') {
            steps {
                dir(project.config) {
                    git url: 'git@github.com:ministryofjustice/' + project.config, branch: params.config_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir(project.terraform) {
                    git url: 'git@github.com:ministryofjustice/' + project.terraform, branch: params.spg_terraform_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }

                prepare_env()
            }
        }

        stage('SPG Terraform') {
            parallel {
                stage('Plan SPG common') {
                    steps { script { plan_submodule('common') } }
                }
                stage('Plan SPG iam roles and services policies') {
                    steps { script { plan_submodule('iam') } }
                }
                stage('Plan SPG KMS Keys for Identity Certificates') {
                    steps { script { plan_submodule('kms-certificates-spg') } }
                }
                stage('Plan SPG iam polices for app roles') {
                    steps { script { plan_submodule('iam-spg-app-policies') } }
                }

                stage('Plan SPG security-groups-and-rules') {
                    steps {
                        script {
                            plan_submodule('security-groups-and-rules')
                        }
                    }
                }

                stage('Plan SPG amazonmq') {
                    steps { script { plan_submodule('amazonmq') } }
                }
                stage('Plan SPG ecs-crc') {
                    steps { script { plan_submodule('ecs-crc') } }
                }
                stage('Plan SPG ecs-mpx') {
                    steps { script { plan_submodule('ecs-mpx') } }
                }
                stage('Plan SPG ecs-iso') {
                    steps { script { plan_submodule('ecs-iso') } }
                }
            }
        }
    }

    post {
        always {
            deleteDir()
        }
    }
}
