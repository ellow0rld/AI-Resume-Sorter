pipeline {
    agent any

    environment {
        GEMINI_API_KEY = credentials('GEMINI_API_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ellow0rld/AI-Resume-Sorter.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('terraform') {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform apply -auto-approve
                            terraform show  # Debug output
                        '''
                    }
                }
            }
        }

        stage('Extract EC2 IP') {
            steps {
                script {
                    def ec2_ip = sh(script: "terraform -chdir=terraform output -raw public_ip", returnStdout: true).trim()
                    echo "EC2 IP is: ${ec2_ip}"
                    env.EC2_IP = ec2_ip
                }
            }
        }

        stage('Deploy Flask App') {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH'),
                    string(credentialsId: 'GEMINI_API_KEY', variable: 'GEMINI_API_KEY')
                ]) {
                    sh 'chmod +x deploy.sh'
                    sh "./deploy.sh ${EC2_IP} ${SSH_KEY_PATH} '${GEMINI_API_KEY}'"
                }
            }
        }
}
