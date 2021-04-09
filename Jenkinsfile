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
                              sh 'sudo bundle update'
                              sh 'sudo gem install chef-utils -v 16.6.14'
                              sh 'sudo gem install kitchen-terraform --version 5.7.2 '
                              sh("gcloud auth activate-service-account --project=searce-academy --key-file=${GC_KEY}")
                              //sh("export GOOGLE_APPLICATION_CREDENTIALS=${GC_KEY}")
                             // sh "kitchen test"
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
            always {
                script {
           //sh 'curl https://api.GitHub.com/repos/ngbit9/mind-test/statuses/$GIT_COMMIT?access_token=${{ secrets.GITHUB_TOKEN }} -H "Content-Type: application/json" -X POST -d "{\"state\": \"failure\",\"context\": \"PR is failed\", \"description\": \"Jenkins\", \"target_url\": \"http://35.225.100.140:8080/job/test1/$BUILD_NUMBER/console\"' 
                   def PULL_REQUEST = env.CHANGE_ID
                    withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB')]) {
                  sh "curl -s -H \"Authorization: token ${GITHUB}\" -X POST -d '{\"body\": \"This is my first test comment from jenkins\"}' \"https://api.github.com/repos/ngbit9/${env.GIT_URL.tokenize("/")[-1].tokenize(".")[0]}/issues/${PULL_REQUEST}/comments\""
                }
             }
            }    
          //  success {
           //     script {
           //sh 'curl -H https://api.GitHub.com/repos/ngbit9/mind-test/statuses/$GIT_COMMIT?access_token=${{ secrets.GITHUB_TOKEN }} -H "Content-Type: application/json" -X POST -d "{\"state\": \"failure\",\"context\": \"PR is succeed\", \"description\": \"Jenkins\", \"target_url\": \"http://35.225.100.140:8080/job/test1/$BUILD_NUMBER/console\"' 
           //     }
            // }            
           }   
         }
