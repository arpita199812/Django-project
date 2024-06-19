pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        S3_BUCKET = 'mynodejs-s3'
        APP_NAME = 'mynodejs'
        EB_ENV = 'Mynodejs-env'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/arpita199812/fullstack-bank--Nodejs-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${APP_NAME}:${BUILD_ID}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image("${APP_NAME}:${BUILD_ID}").inside {
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }

        stage('Package Application') {
            steps {
                script {
                    sh 'zip -r my-node-app.zip .'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    sh """
                    aws s3 cp my-node-app.zip s3://${S3_BUCKET}/my-node-app.zip
                    """
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    sh """
                    eb init -p docker ${APP_NAME} --region us-east-1
                    eb use ${EB_ENV}
                    eb deploy --source s3://${S3_BUCKET}/my-node-app.zip
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
