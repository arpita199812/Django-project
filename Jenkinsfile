pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS-Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-key')
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-nodejs-app')
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/arpita199812/fullstack-bank--Nodejs-project.git'
            }
        }

        stage('Install') {
            steps {
                script {
                    bat 'npm install'
                }
            }
        }

        stage('Run Test') {
            steps {
                script {
                    bat 'npm run test:integration'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    bat 'npm run test:e2e:open'
                }
            }
        }

        stage('E2E Test') {
            steps {
                script {
                    bat 'npm run test:e2e'
                }
            }
        }
        stage('NPM Test') {
            steps {
                script {
                    bat 'npm run test'
                }
            }
        }


        stage('Build Docker Image') {
            steps {
                script { 
                    docker.withRegistry(DOCKER_REGISTRY_URL, 'docker-hub-nodejs-app') {
                        def image = docker.build('arpita199812/your-nodejs-app1:latest', '.')
                        image.push()
                    }
                }
            }
        } 
        stage('Start the Container') {
            steps {
                script {
                    bat 'docker-compose --version'
                    bat 'npm run compose up -d'
                    // It might be better to separate 'compose:down' into a different step if it is meant to stop after some operations
                    // bat 'npm run compose:down'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    withAWS(region: 'us-east-1', credentials: 'AWS-Credentials-ID') {
                        s3Upload(bucket: 'mynodejs-s3', path: 'build/*', file: 'build/*')
                    }
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    withAWS(region: 'us-east-1', credentials: 'AWS-Credentials-ID') {
                        bat 'eb deploy my-environment'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                bat 'npm run compose:down'
            }
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
