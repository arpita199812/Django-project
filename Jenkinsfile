pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-credentials-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials-id')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'Dev', url: 'https://github.com/arpita199812/fullstack-bank--Nodejs-project.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('my-nodejs-app')
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    docker.image('my-nodejs-app').inside {
                        sh 'npm test'
                    }
                }
            }
        }
        stage('Package Application') {
            steps {
                script {
                    docker.image('my-nodejs-app').inside {
                        sh 'npm run build'
                    }
                }
            }
        }
        stage('Upload to S3') {
            steps {
                script {
                    docker.image('my-nodejs-app').inside {
                        withAWS(region: 'us-east-1', credentials: 'aws-credentials-id') {
                            s3Upload(bucket: 'mynodejs-s3 ', path: 'build/*')
                        }
                    }
                }
            }
        }
        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    docker.image('my-nodejs-app').inside {
                        withAWS(region: 'us-east-1', credentials: 'aws-credentials-id') {
                            sh 'eb deploy'
                        }
                    }
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
