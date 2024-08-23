pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS-Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-key')
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-nodejs-app')
        DOCKER_REGISTRY_URL = 'https://hub.docker.com/'
        AWS_REGION = 'us-east-1'
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

        stage('Start Server') {
            steps {
                script {
                    // Start the server using a background process
                    bat 'npm run compose:up'
                    // Wait for a few seconds to ensure the server is up and running
                    sleep(time: 10, unit: 'SECONDS')
                }
            }
        }

        stage('Run E2E Tests') {
            steps {
                script {
                    try {
                        bat 'npm run test:e2e'
                    } catch (Exception e) {
                        echo 'E2E tests failed!'
                        currentBuild.result = 'UNSTABLE'
                    } finally {
                        junit '**/cypress/results/*.xml' // Adjust the path to your Cypress results if needed
                    }
                }
            }
        }

        stage('Run Integration Tests') {
            steps {
                script {
                    try {
                        bat 'npm run test:integration'
                    } catch (Exception e) {
                        echo 'Integration tests failed!'
                        currentBuild.result = 'UNSTABLE'
                    } finally {
                        junit '**/app/backend/test-results.xml' // Adjust the path to your Mocha results if needed
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
                    bat 'npm run compose:up'
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
                bat 'npm run compose:down'
            }
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        unstable {
            echo 'Pipeline is unstable due to test failures.'
        }
    }
}
