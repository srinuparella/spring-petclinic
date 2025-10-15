pipeline {
    agent { label 'JAVAAPP' }

    triggers { pollSCM('* * * * *') }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/srinuparella/spring-petclinic.git', branch: 'main'
            }
        }

        stage('Java Build and SonarQube Scan') {
            steps {
                withCredentials([string(credentialsId: 'sonar_id', variable: 'SONARTOKEN')]) {
                    withSonarQubeEnv('SONARQUBE') {
                        sh '''
                            mvn clean package sonar:sonar \
                            -Dsonar.organization=srinuparella \
                            -Dsonar.projectName=spring-petclinic \
                            -Dsonar.projectKey=srinuparella_spring-petclinic \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONARTOKEN
                        '''
                    }
                }
            }
        }

        stage('Upload to JFrog') {
            steps {
                rtUpload(
                    serverId: 'JFROG_ARTIFACTORY',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "jfrog_java-libs-release-local/"
                            }
                        ]
                    }'''
                )
                rtPublishBuildInfo(serverId: 'JFROG_ARTIFACTORY')
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo '✅ Pipeline is successful with SonarQube and JFrog integration!'
        }
        failure {
            echo '❌ Pipeline failed during SonarQube or JFrog step!'
        }
    }
}
