/* The following parameters are required from Jenkins GUI or other upstream jobs
        environment_name
        project_branch
        spg_image_version
        confirm (boolean)
*/

def project = [:]
project.config = 'hmpps-env-configs'
project.terraform = 'hmpps-delius-spg-shared-terraform'

def prepare_env() {
    sh '''
        #!/usr/env/bin bash
        docker pull mojdigitalstudio/hmpps-terraform-builder:latest
    '''
}

def plan_submodule(configMap, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF PLAN for ${configMap.env_name} | ${submodule_name} - component from git project ${configMap.terraform}"
        set +e
        cp -R -n "${configMap.config}" "${configMap.terraform}/env_configs"
        cd "${configMap.terraform}"
        docker run --rm \
            -v `pwd`:/home/tools/data \
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
            bash -c "\
                source env_configs/${configMap.env_name}/${configMap.env_name}.properties; \
                export TF_VAR_image_version=${configMap.image_version}; \
                cd ${submodule_name}; \
                if [ -d .terraform ]; then rm -rf .terraform; fi; sleep 5; \
                terragrunt init; \
                terragrunt plan -detailed-exitcode -out ${configMap.env_name}.plan > tf.plan.out; \
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
        return readFile("${configMap.terraform}/${submodule_name}/plan_ret").trim()
    }
}

def apply_submodule(configMap, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF APPLY for ${configMap.env_name} | ${submodule_name} - component from git project ${configMap.terraform}"
        set +e
        cp -R -n "${configMap.config}" "${configMap.terraform}/env_configs"
        cd "${configMap.terraform}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
          bash -c " \
              source env_configs/${configMap.env_name}/${configMap.env_name}.properties; \
              export TF_VAR_image_version=${configMap.image_version}; \
              cd ${submodule_name}; \
              terragrunt apply ${configMap.env_name}.plan; \
              tgexitcode=\\\$?; \
              echo \\\"TG exited with code \\\$tgexitcode\\\"; \
              if [ \\\$tgexitcode -ne 0 ]; then \
                exit  \\\$tgexitcode; \
              else \
                exit 0; \
              fi;"; \
        dockerexitcode=\$?; \
        echo "Docker step exited with code \$dockerexitcode"; \
        if [ \$dockerexitcode -ne 0 ]; then exit \$dockerexitcode; else exit 0; fi;
        set -e
        """
    }
}

//required for changes in things like common, where no resources have changed but variables may have
def refresh_submodule(configMap, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF APPLY for ${configMap.env_name} | ${submodule_name} - component from git project ${configMap.terraform}"
        set +e
        cp -R -n "${configMap.config}" "${configMap.terraform}/env_configs"
        cd "${configMap.terraform}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
          bash -c " \
              source env_configs/${configMap.env_name}/${configMap.env_name}.properties; \
              export TF_VAR_image_version=${configMap.image_version}; \
              cd ${submodule_name}; \
              terragrunt refresh; \
              tgexitcode=\\\$?; \
              echo \\\"TG exited with code \\\$tgexitcode\\\"; \
              if [ \\\$tgexitcode -ne 0 ]; then \
                exit  \\\$tgexitcode; \
              else \
                exit 0; \
              fi;"; \
        dockerexitcode=\$?; \
        echo "Docker step exited with code \$dockerexitcode"; \
        if [ \$dockerexitcode -ne 0 ]; then exit \$dockerexitcode; else exit 0; fi;
        set -e
        """
    }
}

def confirm() {
    try {
        timeout(time: 15, unit: 'MINUTES') {
            env.Continue = input(
                id: 'Proceed1',
                message: 'Apply plan?',
                parameters: [
                    [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Apply Terraform']
                ]
            )
        }
    } catch (err) { // timeout reached or input false
        def user = err.getCauses()[0].getUser()
        env.Continue = false
        if ('SYSTEM' == user.toString()) { // SYSTEM means timeout.
            echo "Timeout"
            error("Build failed because confirmation timed out")
        } else {
            echo "Aborted by: [${user}]"
        }
    }
}

def do_terraform(configMap, component) {
    if (component == "common") {
        refresh_submodule(configMap, component)
    }

    plancode = plan_submodule(configMap, component)
    if (plancode == "2" ) {
        if ("${confirmation}" == "true") {
            confirm()
        } else {
            env.Continue = true
        }
        if (env.Continue == "true") {
            apply_submodule(configMap, component)
        }
    } else if (plancode == "3") {
        apply_submodule(configMap, component)
        env.Continue = true
    } else {
        env.Continue = true
    }
}

// The terraform state rm command always reports a success if the specified resource is in the correct format - even if it doesn't exist anymore.
// So, issue the terraform state list command on each resource first and capture the output to determine if it exists or not.
def remove_submodule_resources(configMap, submodule_name, resources) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        COUNTER=2
        echo "COUNTER is \\\$COUNTER"
        echo "TF remove resource for ${configMap.env_name} | ${submodule_name} - component from git project ${configMap.terraform}"
        set +e
        cp -R -n "${configMap.config}" "${configMap.terraform}/env_configs"
        cd "${configMap.terraform}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
          bash -c " \
              source env_configs/${configMap.env_name}/${configMap.env_name}.properties; \
              cd ${submodule_name}; \

            resource0=\\\"\\\$(terragrunt state list ${resources[0]})\\\"; \
            if [ -z \\\$resource0 ]; then \
                echo \\\"${resources[0]} does not exist\\\"; \
            else \
                echo \\\"Will remove resource \\\$resource0\\\"; \
                terragrunt state rm ${resources[0]}; \
                tgexitcode0=\\\$?; \
                echo \\\" terragrunt state rm ${resources[0]} returned \\\$tgexitcode0\\\"; \
            fi; \

            resource1=\\\"\\\$(terragrunt state list ${resources[1]})\\\"; \
            if [ -z \\\$resource1 ]; then \
                echo \\\"${resources[1]} does not exist\\\"; \
            else \
                echo \\\"Will remove resource \\\$resource1\\\"; \
                terragrunt state rm ${resources[1]}; \
                tgexitcode1=\\\$?; \
                echo \\\" terragrunt state rm ${resources[1]} returned \\\$tgexitcode1\\\"; \
            fi; \

            if [[ \\\$tgexitcode0 -ne 0 || \\\$tgexitcode1 -ne 0 ]]; then \
                echo \\\"Exiting due to non zero return code\\\"; \
                exit 1; \
            else \
                exit 0; \
            fi;"; \

        dockerexitcode=\$?; \
        echo "Docker step exited with code \$dockerexitcode"; \
        if [ \$dockerexitcode -ne 0 ]; then exit \$dockerexitcode; else exit 0; fi;
        set -e
        """
    }
}


def debug_env() {
    sh '''
        #!/usr/env/bin bash
        pwd
        ls -al
    '''
}

pipeline {
    agent { label "jenkins_slave" }

    stages {
        stage('setup') {
            steps {
                slackSend(message: "\"Apply\" started on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL.replace(':8080', '')}|Open>)")

                dir(project.config) {
                    git url: 'git@github.com:ministryofjustice/' + project.config, branch: params.project_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir(project.terraform) {
                    git url: 'git@github.com:ministryofjustice/' + project.terraform, branch: params.project_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }

                prepare_env()
            }
        }

        stage('Delius | SPG | Common') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'common')
                }
            }
        }

        stage('Delius | SPG | IAM Roles') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'iam')
                }
            }
        }

        /* Temporarily Needs to be disabled for preprod & perf due to some terraform remote state issue complaining about
        An alias with the name arn:aws:kms:eu-west-2:010587221707:alias/tf-del-pre-prod-certificates-spg-message-signing-certificate-kms-key already exists
        see  https://jenkins.engineering-dev.probation.hmpps.dsd.io/job/DAMS/job/Environments/job/delius-pre-prod/job/SPG/job/Deploy_Infrastructure/17/console
        */
        stage('Delius | SPG | KMS') {
            steps {
                script {
                    if ("${environment_name}" != "delius-pre-prod" && "${environment_name}" != "delius-perf" ) {
                        project.env_name = environment_name
                        do_terraform(project, 'kms-certificates-spg')
                    }
                    else
                    {
                        echo "Skipping KMS as workaround for corrupted terraform state in preprod"
                    }

                }
            }
        }

        stage('Delius | SPG | IAM App Policies') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'iam-spg-app-policies')
                }
            }
        }

        stage('Delius | SPG | Security Groups And Rules') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'security-groups-and-rules')
                }
            }
        }

        stage('Delius | SPG | PSN Proxy Ips - should move to VPC project') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'psn-proxy-route-53')
                }
            }
        }

        stage('Delius | SPG | ELK Stack') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'elk-stack')
                }
            }
        }

        stage('Delius | SPG | Amazon MQ') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'amazonmq')
                }
            }
        }

        stage('Delius | SPG | ECS-SPG-CRC') {
            steps {
                script {
                    project.env_name = environment_name
                    project.image_version = spg_image_version
                    do_terraform(project, 'ecs-crc')
                }
            }


        }
            /* temporarily disabled until the new SPG version with application driven table creation is released
            once it is, then the terraform needs to be modified to not include the table creation script
            also need to ensure it is not deleted by terraform, so some kind of terraform like this before the terraform plan is run

            `terraform state rm 'aws_dynamodb_table.sequence_generator_table'`
            */
            stage('Delius | SPG | DynamoDB Sequence') {
                steps {
                    script {
                    project.env_name = environment_name
                    project.image_version = spg_image_version

                    def resources = [
                        "aws_dynamodb_table.sequence_generator_table",
                        "aws_dynamodb_table_item.sequence_value"
                                                            ]
                    remove_submodule_resources(project, 'dynamodb-sequence-generator', resources)

                    do_terraform(project, 'dynamodb-sequence-generator')
                    }
                }
            }


        stage('Delius | SPG | ECS-SPG-MPX') {
            steps {
                script {
                    project.env_name = environment_name
                    project.image_version = spg_image_version
                    do_terraform(project, 'ecs-mpx')
                }
            }
        }

        stage('Delius | SPG | ECS-SPG-ISO') {
            steps {
                script {
                    project.env_name = environment_name
                    project.image_version = spg_image_version
                    do_terraform(project, 'ecs-iso')
                }
            }
        }

        stage('Delius | SPG | Monitoring') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'monitoring')
                }
            }
        }

        stage('Amazon ES Configuration') {
            parallel {
                stage('Configure Index Pattern') {
                    steps {
                        dir(WORKSPACE) {
                            sh '''
                            pwd
                            ls -l
                            echo "Calling configure_amazon_es.sh for environment_name ${environment_name}"
                            cd elk-stack/filebeat
                            ./configure_amazon_es.sh ${environment_name}
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            deleteDir()
        }
        success {
            slackSend(message: "\"Apply\" completed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'good')
        }
        failure {
            slackSend(message: "\"Apply\" failed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'danger')
        }
    }
}
