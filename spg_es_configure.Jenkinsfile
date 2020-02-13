#!groovy

/* The following parameters are required from Jenkins GUI or other upstream jobs
        environment_name
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

def debug_env() {
    sh '''
    #!/usr/env/bin bash
    pwd
    ls -al
    '''
}

pipeline {
    agent { label "jenkins_slave" }

    environment { CI = "true" }

    stages {

        stage('setup') {
            steps {
                dir(project.config) {
                    git url: 'git@github.com:ministryofjustice/' + project.config, branch: params.project_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                dir(project.terraform) {
                    git url: 'git@github.com:ministryofjustice/' + project.terraform, branch: params.project_branch, credentialsId: 'f44bc5f1-30bd-4ab9-ad61-cc32caf1562a'
                }
                prepare_env()
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
    }
}