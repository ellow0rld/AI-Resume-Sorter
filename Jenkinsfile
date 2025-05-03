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
                            terraform show
                        '''
                    }
                }
            }
        }

        stage('Extract EC2 IP') {
            steps {
                script {
                    def ec2_ip = sh(script: "terraform -chdir=terraform output -raw public_ip", returnStdout: true).trim()
                    echo "✅ EC2 IP is: ${ec2_ip}"
                    env.EC2_IP = ec2_ip
                }
            }
        }

        stage('Deploy Flask App') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY_PATH')]) {
                    script {
                        echo "🔑 SSH Key Path: ${SSH_KEY_PATH}"
                        echo "📡 EC2 IP: ${env.EC2_IP}"

                        // Check if SSH key file exists before running anything
                        sh "ls -l ${SSH_KEY_PATH} || echo '❌ SSH key file not found at: ${SSH_KEY_PATH}'"

                        // Run deployment commands
                        sh """
                            echo "📤 Copying app.py to EC2..."
                            scp -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null app.py ec2-user@${env.EC2_IP}:/home/ec2-user/

                            echo "⚙️ Installing dependencies on EC2..."
                            ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null ec2-user@${env.EC2_IP} "sudo yum install -y python3 python3-pip && pip3 install --user -r requirements.txt"

                            echo "🚀 Starting Flask app..."
                            ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null ec2-user@${env.EC2_IP} "nohup python3 app.py > output.log 2>&1 &"
                        """
                    }
                }
            }
        }
    }
}
