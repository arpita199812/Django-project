pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-cli')
        AWS_SECRET_ACCESS_KEY = credentials('aws-cli')
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
                    sh 'zip -r fullstack-bank-Nodejs-project.zip .'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    sh """
                    aws s3 cp fullstack-bank-Nodejs-project.zip s3://${S3_BUCKET}/fullstack-bank-Nodejs-project.zip
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
                    eb deploy --source s3://${S3_BUCKET}/fullstack-bank-Nodejs-project.zip
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
