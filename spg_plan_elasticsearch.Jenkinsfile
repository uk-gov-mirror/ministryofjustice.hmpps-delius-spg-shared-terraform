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
        docker pull mojdigitalstudio/hmpps-terraform-builder-0-11-14:latest
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
            -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder-0-11-14:latest \
            bash -c "\
                source env_configs/${configMap.env_name}/${configMap.env_name}.properties; \
                cd ${submodule_name}; \
                if [ -d .terraform ]; then rm -rf .terraform; fi; sleep 5; \
                terragrunt init; \
                terragrunt refresh; \
                terragrunt plan -detailed-exitcode -out ${configMap.env_name}.plan > tf.plan.out; \
                exitcode=\\\"\\\$?\\\"; \

                cat tf.plan.out; \
                if [ \\\"\\\$exitcode\\\" == '1' ]; then exit 1; fi; \
                echo \\\"\\\$exitcode\\\" > plan_ret;" \
            || exitcode="\$?"; \
            if [ "\$exitcode" == '1' ]; then exit 1; else exit 0; fi
        set -e
        """
        return readFile("${configMap.terraform}/${submodule_name}/plan_ret").trim()
    }
}



//required for changes in things like common, where no resources have changed but variables may have
def refresh_submodule(configMap, submodule_name) {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
        sh """
        #!/usr/env/bin bash
        echo "Refreshing ${configMap.env_name} | ${submodule_name} - component from git project ${configMap.terraform}"
        set +e
        cp -R -n "${configMap.config}" "${configMap.terraform}/env_configs"
        cd "${configMap.terraform}"
        docker run --rm \
          -v `pwd`:/home/tools/data \
          -v ~/.aws:/home/tools/.aws mojdigitalstudio/hmpps-terraform-builder-0-11-14 \
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



def do_terraform(configMap, component) {
    if (component == "common") {
        refresh_submodule(configMap, component)
    }

    plancode = plan_submodule(configMap, component)

}



def debug_env() {
    sh '''
        #!/usr/env/bin bash
        pwd
        ls -al
    '''
}

pipeline {
    agent { label "spg_builds" }

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

        stage('Delius | SPG | Security Groups And Rules') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'security-groups-and-rules')
                }
            }
        }

        stage('Delius | SPG | ELK Stack') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'elk-service')
                }
            }
        }

        stage('Delius | SPG | ELK Domains') {
            steps {
                script {
                    project.env_name = environment_name
                    do_terraform(project, 'elk-domains')
                }
            }
        }



    }

    post {
        always {
            deleteDir()
        }
        success {
            slackSend(message: "\"Plan\" completed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'good')
        }
        failure {
            slackSend(message: "\"Plan\" failed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'danger')
        }
    }
}
