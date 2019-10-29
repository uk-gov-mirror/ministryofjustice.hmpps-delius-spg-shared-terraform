/* The following parameters are required from Jenkins GUI or other upstream jobs
        environment_name
        config_branch
        spg_terraform_branch
        jenkins_pipeline_branch
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

def plan_submodule(config_dir, env_name, git_project_dir, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF PLAN for ${env_name} | ${submodule_name} - component from git project ${git_project_dir}"
        set +e
        cp -R -n "${config_dir}" "${git_project_dir}/env_configs"
        cd "${git_project_dir}"
        docker run --rm \
            -v `pwd`:/home/tools/data \
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
            bash -c "\
                source env_configs/${env_name}/${env_name}.properties; \
                cd ${submodule_name}; \
                if [ -d .terraform ]; then rm -rf .terraform; fi; sleep 5; \
                terragrunt init; \
                terragrunt plan -detailed-exitcode -out ${env_name}.plan > tf.plan.out; \
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
        return readFile("${git_project_dir}/${submodule_name}/plan_ret").trim()
    }
}

def apply_submodule(config_dir, env_name, git_project_dir, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF APPLY for ${env_name} | ${submodule_name} - component from git project ${git_project_dir}"
        set +e
        cp -R -n "${config_dir}" "${git_project_dir}/env_configs"
        cd "${git_project_dir}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
          bash -c " \
              source env_configs/${env_name}/${env_name}.properties; \
              cd ${submodule_name}; \
              terragrunt apply ${env_name}.plan; \
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


//required for changes in things like common, where no resources have changed but variables mayhave
def refresh_submodule(config_dir, env_name, git_project_dir, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "TF APPLY for ${env_name} | ${submodule_name} - component from git project ${git_project_dir}"
        set +e
        cp -R -n "${config_dir}" "${git_project_dir}/env_configs"
        cd "${git_project_dir}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder \
          bash -c " \
              source env_configs/${env_name}/${env_name}.properties; \
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
                    id: 'Proceed1', message: 'Apply plan?', parameters: [
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

def do_terraform(config_dir, env_name, git_project, component) {
    if (component == "common") {
        refresh_submodule(config_dir, env_name, git_project, component)
    }

    plancode = plan_submodule(config_dir, env_name, git_project, component)
    if (plancode == "2" ) {
        if ("${confirmation}" == "true") {
            confirm()
        } else {
            env.Continue = true
        }
        if (env.Continue == "true") {
            apply_submodule(config_dir, env_name, git_project, component)
        }
    } else if (plancode == "3") {
        apply_submodule(config_dir, env_name, git_project, component)
        env.Continue = true
    } else {
        env.Continue = true
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
                    git url: 'git@github.com:ministryofjustice/' + project.config, branch: params.config_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir(project.terraform) {
                    git url: 'git@github.com:ministryofjustice/' + project.terraform, branch: params.spg_terraform_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }

                prepare_env()
            }
        }

        stage('Delius | SPG | Common') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'common')
                }
            }
        }


        stage('Delius | SPG | IAM Roles') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'iam')
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
                        do_terraform(project.config, environment_name, project.terraform, 'kms-certificates-spg')
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
                    do_terraform(project.config, environment_name, project.terraform, 'iam-spg-app-policies')
                }
            }
        }

        stage('Delius | SPG | Security Groups - Deprecated') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'security-groups')
                }
            }
        }


        stage('Delius | SPG | Security Groups And Rules') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'security-groups-and-rules')
                }
            }
        }


        stage('Delius | SPG | PSN Proxy Ips - should move to VPC project') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'psn-proxy-route-53')
                }
            }
        }


        stage('Delius | SPG | Amazon MQ') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'amazonmq')
                }
            }
        }

        stage('Delius | SPG | DynamoDB Sequence') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'dynamodb-sequence-generator')
                }
            }
        }

        stage('Delius | SPG | ECS-SPG-CRC') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'ecs-crc')
                }
            }
        }


        stage('Delius | SPG | ECS-SPG-MPX') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'ecs-mpx')
                }
            }
        }


        stage('Delius | SPG | ECS-SPG-ISO') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'ecs-iso')
                }
            }
        }


        stage('Delius | SPG | Monitoring') {
            steps {
                script {
                    do_terraform(project.config, environment_name, project.terraform, 'monitoring')
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
