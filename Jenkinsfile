pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS-Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-key')
        DOCKER_HUB = credentials('docker-hub-nodejs-app')
        DOCKER_REGISTRY_URL = 'https://index.docker.io/v1/'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/arpita199812/fullstack-bank--Nodejs-project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script { 
                    docker.withRegistry(env.DOCKER_REGISTRY_URL, 'docker-hub-credentials-id') {
                        def app = docker.build("your-image-name:${env.BUILD_ID}")
                        app.push()
                    }
                }
            }
        }  

        stage('Run Tests') {
            steps {
                script {
                    docker.image('my-nodejs-app1:latest').inside {
                        bat 'npm test'
                    }
                }
            }
        }

        stage('Package Application') {
            steps {
                script {
                    docker.image('my-nodejs-app1:latest').inside {
                        bat 'npm run build'
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
