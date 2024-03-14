pipeline {
    agent any

    environment {
        GIT_SSH_COMMAND = 'ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/id_rsa'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') 
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REGISTRY_URL = '463444363542.dkr.ecr.us-east-1.amazonaws.com/edusync'
        ECR_REPOSITORY_NAME = 'edusync'
        AWS_ACCOUNT_ID = '463444363542'
    }

    stages {
        stage('Checkout') {
            steps {
                sshagent(['c40e74d9-d7ae-443d-aa3d-1eb65b6354ae']) {
                    checkout([$class: 'GitSCM',
                        branches: [[name: 'main']],
                        userRemoteConfigs: [[url: 'git@github.com:Sabyasachi-Seal/EduSync.git']]
                    ])
                }
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    sh """
                    docker build --build-arg ssh_prv_key="\$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="\$(cat ~/.ssh/id_rsa.pub)" -t edusync-image .
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh """
                    
                    export AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY
                    export AWS_DEFAULT_REGION
                    
                    aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

                    docker tag auth-service:latest ${ECR_REGISTRY_URL}/${ECR_REPOSITORY_NAME}:latest
                    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest
                    
                    """
                }
            }
        }
    }
}
