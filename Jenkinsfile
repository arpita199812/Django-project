pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY = credentials('AWS-Access-key')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-key')
        DOCKER_HUB = credentials('docker-hub-nodejs-app')
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
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-nodejs-app', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker build -t arpita199812/your-nodejs-app:latest .
                        docker push arpita199812/your-nodejs-app:latest
                        '''
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
