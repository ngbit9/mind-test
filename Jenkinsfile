pipeline {
    agent {
        node {
            label 'master'
        }
    }
     stages {
        stage ('Pre Build stage') {
            steps {
                sh 'sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y build-essential'
                sh 'sudo wget https://releases.hashicorp.com/terraform/0.14.9/terraform_0.14.9_linux_amd64.zip'
                sh 'sudo unzip -o terraform_0.14.9_linux_amd64.zip'
                sh 'sudo cp terraform /usr/local/bin'
                sh 'terraform version'
                sh 'sudo apt-get install ruby-full -y'
                sh 'sudo apt install ruby-bundler -y' 
                
            }
        }
        stage ('Build and Execute stage') { 
            steps {
                   script {
                     if (env.branch_name.startsWith('PR')) {
                    git url: 'https://github.com/ngbit9/mind-test.git', branch: 'dev'  
                    dir("${env.WORKSPACE}/kitchen-terraform") {
                          withCredentials([file(credentialsId: 'searce-academy', variable: 'GC_KEY')])
                           {
                              writeFile file: 'test.json', text: readFile(GC_KEY)
                              sh 'sudo bundle update'
                              sh 'sudo gem install chef-utils -v 16.6.14'
                              sh 'sudo gem install kitchen-terraform --version 5.7.2 '
                              sh 'gcloud iam service-accounts disable 427907482591-compute@developer.gserviceaccount.com' 
                              sh("gcloud auth activate-service-account --project=searce-academy --key-file=${GC_KEY}")
                              sh 'export GOOGLE_APPLICATION_CREDENTIALS=test.json' 
                              sh "kitchen test"
                              echo "It is successfully planned,created and destroyed"
                     }
                    }
                  }
                else {
                      echo 'no branch found'
                     }
                   }
                 }
              }
            }
        post {
            success {
                script {
                   def PULL_REQUEST = env.CHANGE_ID
                    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB')]) {
                  sh "curl -s -H \"Authorization: token ${GITHUB}\" -X POST -d '{\"body\": \"Test is successfully completed\"}' \"https://api.github.com/repos/ngbit9/${env.GIT_URL.tokenize("/")[-1].tokenize(".")[0]}/issues/${PULL_REQUEST}/comments\""
                }
             }
            }  
            failure {
                script {
                   def PULL_REQUEST = env.CHANGE_ID
                    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB')]) {
                  sh "curl -s -H \"Authorization: token ${GITHUB}\" -X POST -d '{\"body\": \"Opps! Test Failed\"}' \"https://api.github.com/repos/ngbit9/${env.GIT_URL.tokenize("/")[-1].tokenize(".")[0]}/issues/${PULL_REQUEST}/comments\""
                }
             }
            }             
           }   
         }
