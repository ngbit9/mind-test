pipeline {
    agent {
        node {
            label 'master'
        }
    }
    parameters {
        booleanParam(name: "Enviornment", defaultValue: false)
        choice(name: "DEPLOY_TO", choices: ["","testing", "staging"])
    }
     stages {
        stage ('Pre Build stage') {
            steps {
                sh 'sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y build-essential'
                sh 'sudo wget https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip'
                sh 'sudo unzip terraform_0.14.9_linux_amd64.zip'
                sh 'sudo cp terraform /usr/local/bin'
                sh 'terraform version'
                sh 'sudo apt-get install ruby-full -y'
                sh 'sudo apt install ruby-bundler -y' 
                
            }
        }
        stage ('Build and Execute stage') {
            parallel {
                stage ("testing") {
                    if (env.branch_name.startsWith('PR') {
                 when { expression { params.DEPLOY_TO == "testing" } }
             steps {
                    git url: 'https://github.com/ngbit9/mind-test.git', branch: 'master'  
                    dir("${env.WORKSPACE}/kitchen-terraform") {
                          withCredentials([file(credentialsId: 'searce-academy', variable: 'GC_KEY')])
                           {
                              sh 'sudo bundle update'
                              sh 'sudo gem install chef-utils -v 16.6.14'
                              sh 'sudo gem install kitchen-terraform --version 5.7.2 '
                              sh("gcloud auth activate-service-account --project=searce-academy --key-file=${GC_KEY}")
                              sh("export GOOGLE_APPLICATION_CREDENTIALS=${GC_KEY}")
                              sh "kitchen test"
                              echo "It is successfully planned,created and destroyed"
                       }
                     }
                    }
                  }
                        else {
                           echo "no branch found"
                        }
                }
                stage ("staging") {
                    when { expression { params.DEPLOY_TO == "staging" } }
                    steps {
                    git url: 'https://github.com/ngbit9/mind-test.git', branch: 'dev'
                    dir("${env.WORKSPACE}/kitchen-terraform") {
                          withCredentials([file(credentialsId: 'searce-playground', variable: 'GCP_KEY')])
                           {
                              sh 'sudo bundle update'
                              sh 'sudo gem install chef-utils -v 16.6.14'
                              sh 'sudo gem install kitchen-terraform --version 5.7.2 '
                              sh("gcloud auth activate-service-account --project=searce-playground --key-file=${GCP_KEY}")
                              sh("export GOOGLE_APPLICATION_CREDENTIALS=${GCP_KEY}")
                              //sh("gcloud info")
                              sh "kitchen create"
                              sh "kitchen verify"
                             echo "It is successfully crrated and verified terraform script "
                       }
                      }        
                    }
                 }
               }
            }   
        }
    }
