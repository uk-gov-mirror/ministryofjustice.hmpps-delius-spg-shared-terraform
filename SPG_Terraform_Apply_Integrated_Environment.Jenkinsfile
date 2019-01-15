def project = [:]
project.config_branch = 'delius-test__spg'
project.network_branch = 'master'
project.spg_branch = 'feature/issue-6-image-push-not-executable'
project.config    = 'hmpps-env-configs'
project.network   = 'hmpps-delius-network-terraform'
project.dcore     = 'hmpps-delius-core-terraform'
project.alfresco  = 'hmpps-delius-alfresco-shared-terraform'
project.spg       = 'hmpps-delius-spg-shared-terraform'
//project.ndmis     = 'hmpps-ndmis-terraform' //

def environments = [

  '-- choose env--',
  'delius-core-sandpit',
  // 'delius-core-playpit',
  'delius-core-dev',
  'delius-test',
]

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
                terragrunt plan -detailed-exitcode --out ${env_name}.plan" \
            || exitcode="\$?"; \
            echo "\$exitcode" > plan_ret; \
            if [ "\$exitcode" == '1' ]; then exit 1; else exit 0; fi
        set -e
        """
        return readFile("${git_project_dir}/plan_ret").trim()
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
        bash -c "\
            source env_configs/${env_name}/${env_name}.properties; \
            cd ${submodule_name}; \
            terragrunt apply ${env_name}.plan"
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
    } catch(err) { // timeout reached or input false
        def user = err.getCauses()[0].getUser()
        env.Continue = false
        if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
            echo "Timeout"
            error("Build failed because confirmation timed out")
        } else {
            echo "Aborted by: [${user}]"
        }
    }
}

def do_terraform(config_dir, env_name, git_project, component) {
    if (plan_submodule(config_dir, env_name, git_project, component) == "2") {
        confirm()
        if (env.Continue == "true") {
            apply_submodule(config_dir, env_name, git_project, component)
        }
    }
    else {
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

    parameters {
        choice(
          name: 'environment_name',
          choices: environments,
          description: 'Select environment for creation or updating.'
        )
    }

    tools {
            maven 'Maven 3.3.9'
            jdk 'jdk8'
    }

    stages {

        stage('setup') {
            steps {
                slackSend(message: "Build started on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL.replace(':8080','')}|Open>)")

                dir( project.config ) {
                  git url: 'git@github.com:ministryofjustice/' + project.config, branch: project.config_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir( project.network ) {
                  git url: 'git@github.com:ministryofjustice/' + project.network, branch: project.network_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir( project.spg ) {
                  git url: 'git@github.com:ministryofjustice/' + project.spg, branch: project.spg_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }

                prepare_env()
            }
        }

        stage('Delius | SPG | Common') {
          steps {
            script {
              do_terraform(project.config, environment_name, project.spg, 'common')
            }
          }
        }

        stage('Delius | SPG | IAM') {
          steps {
            script {
              do_terraform(project.config, environment_name, project.spg, 'iam')
            }
          }
        }

        stage('Delius | SPG | ECR') {
          steps {
            script {
              do_terraform(project.config, environment_name, project.spg, 'ecr')
            }
          }
        }

        stage('Delius | SPG | Security Groups') {
          steps {
            script {
              do_terraform(project.config, environment_name, project.spg, 'security-groups')
            }
          }
        }

        stage('Delius | SPG | ECS-SPG') {
          steps {
            script {
              do_terraform(project.config, environment_name, project.spg, 'ecs-spg')
            }
          }
        }

        stage('Delius | SPG | push-spg-docker') {
            steps {
                sh "NON_CONTAINER_WORKING_DIR=${project.spg};sh ./${project.spg}/scripts/image_push.sh ${project.config_branch} ${environment_name}"
            }
        }


        stage('Delius | SPG | prune-docker-fs') {
            steps {
                sh "sh ./${project.spg}/scripts/prune_docker_fs.sh"
            }
        }
    }

    post {
        always {
            deleteDir()
        }
        success {
            slackSend(message: "Build completed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'good')
        }
        failure {
            slackSend(message: "Build failed on \"${environment_name}\" - ${env.JOB_NAME} ${env.BUILD_NUMBER} ", color: 'danger')
        }
    }

}
