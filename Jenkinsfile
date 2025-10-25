pipeline {
    agent {
        label 'JAVAAPP'
    }
    triggers {
        pollSCM ('* * * * *')
    }
    stages {
        stage ('git checkout') {
            steps {
                git url : 'https://github.com/srinuparella/spring-petclinic.git' ,
                branch : 'main'
            }
        }
        stage ('java code build') {
            steps {
              sh 'mvn package'
            }
        }
        stage ('raw code scanning') {
           steps {
             withCredentials([string(credentialsId: 'id_sonar', variable: 'SONAR_TOKEN')]) {
                withSonarQubeEnv('SONARQUBE') {
                    sh '''
                     mvn  sonar:sonar \
                    -Dsonar.organization=srinuparella \
                    -Dsonar.projectName=spring-petclinic \
                    -Dsonar.projectKey=srinuparella_spring-petclinic \
                    -Dsonar.host.url=https://sonarcloud.io \
                    -Dsonar.login=$SONAR_TOKEN                
                                       
                                        '''
                }
             }
           }
        }
         stage ('upload artifactory') {
             steps {
                 rtUpload (
                    serverId:'JFROG_ARTIFACTORY' ,
                    spec: '''{
                        "files" :[
                        {
                            "pattern": "target/*.jar",
                            "target": "jfrog_java-libs-release/"
                        }
                        ]
                 }'''
                 )
                 rtPublishBuildInfo(serverId: 'JFROG_ARTIFACTORY')
             }
         }
        stage ('docker install and image build'){
            steps {
                sh 
                // curl -fsSL https://get.docker.com -o install-docker.sh && \
                // sudo sh install-docker.sh && \
                'docker image build --build-arg user=parella -t java:1.1'
            }
        }
    }   
}
