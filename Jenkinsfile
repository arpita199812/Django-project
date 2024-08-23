pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS-Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-key')
        DOCKER_HUB = credentials('docker-hub-nodejs-app')
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
        }

        stage('Start the Container') {
            steps {
                script {
                        bat 'npm run compose:up'
                        bat 'npm run compose:down'
                    }
                }
            }
        }
        stage('Run Test') {
            steps {
                script {
                        bat 'npm run test: integration'
                    }
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
        }
        stage('Build Docker Image') {
            steps {
                script { 
                    withDockerRegistry(credentialsId: 'docker-hub-nodejs-app', toolName: 'Docker', url: 'https://hub.docker.com/') {
                        def image = docker.build('arpita199812/your-nodejs-app1:latest', '.')
                        image.push()
                    }
                }
            }
        }  
        stage('Upload to S3') {
            steps {
                script {
                    docker.image('my-nodejs-app1:latest').inside {
                        withAWS(region: 'us-east-1', credentials: [AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY]) {
                            s3Upload(bucket: 'mynodejs-s3', path: 'build/*', sourceFile: 'build/*')
                        }
                    }
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    docker.image('my-nodejs-app1:latest').inside {
                        withAWS(region: 'us-east-1', credentials: [AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY]) {
                            bat 'eb deploy my-environment'
                        }
                    }
                }
            }
        }
    }
}
