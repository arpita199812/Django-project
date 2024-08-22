pipeline {
    agent any

    environment {
        withCredentials([
            string(credentialsId: 'AWS-Access-key', variable: 'AWS_ACCESS_KEY'),
            string(credentialsId: 'AWS-Access-key', variable: 'AWS_SECRET_ACCESS_KEY'),
            string(credentialsId: 'docker-hub-id', variable: 'DOCKER_HUB_TOKEN')
        ])
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
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_TOKEN) {
                        docker.build('my-nodejs-app1')
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image('my-nodejs-app1').inside {
                        bat 'npm test'
                    }
                }
            }
        }

        stage('Package Application') {
            steps {
                script {
                    docker.image('my-nodejs-app1').inside {
                        bat 'npm run build'
                    }
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    docker.image('my-nodejs-app1').inside {
                        withAWS(region: 'us-east-1', credentials: 'AWS-ACCESS_KEY', 'AWS_SECRET_ACCESS_KEY) {
                            s3Upload(bucket: 'mynodejs-s3', path: 'build/*')
                        }
                    }
                }
            }
        }

        stage('Deploy to Elastic Beanstalk') {
            steps {
                script {
                    docker.image('my-nodejs-app1').inside {
                        withAWS(region: 'us-east-1', credentials: 'AWS-ACCESS_KEY', 'AWS_SECRET_ACCESS_KEY) ) {
                            bat 'eb deploy'
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
