pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS-Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-key')
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-nodejs-app')
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/'
        AWS_REGION = 'us-east-1' // Setting a region for AWS operations
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                deleteDir() // Clean workspace before starting
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/arpita199812/fullstack-bank--Nodejs-project.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    bat 'npm install'
                }
            }
        }

        stage('Run All Tests') {
            steps {
                script {
                    try {
                        bat 'npm run test:integration'
                        bat 'npm run test:e2e'
                        bat 'npm run test'
                    } catch (Exception e) {
                        echo 'Some tests failed!'
                        currentBuild.result = 'FAILURE'
                        error 'Test Failure'
                    }
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

        stage('Start Docker Container') {
            steps {
                script {
                    bat 'docker-compose up -d'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    withAWS(region: AWS_REGION, credentials: 'AWS-Credentials-ID') {
                        s3Upload(bucket: 'mynodejs-s3', path: 'build/*', file: 'build/*')
                    }
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    withAWS(region: AWS_REGION, credentials: 'AWS-Credentials-ID') {
                        bat 'eb deploy my-environment'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Ensure containers are stopped and removed
                bat 'docker-compose down'
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
