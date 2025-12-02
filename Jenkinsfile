pipeline {
    agent any

    stages {
        stage('Git versiaaon') {
            steps {
                sh 'git version'
            }
        }
            stage('maven version') {
            steps {
                sh 'mvn -v'
            }
            }
            stage('docker version') {
            steps {
                sh 'docker -v'
            }
            }
            stage('kubernetes versionnn') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']){
                sh 'kubectl version'
            }
            }
}
stage('Build JAR') {
    steps {
        sh 'mvn clean package -DskipTests'
	sh 'archive targer/*.jar'
    }
}
	   stage('Docker Build and Push') {
     steps {
       withDockerRegistry([credentialsId: "dockerhub-config", url: ""]) {
        sh 'printenv'
 	 sh 'sudo docker build --no-cache -t 0xbilaal/numeric-app:""$GIT_COMMIT"" .'
         sh 'docker push 0xbilaal/numeric-app:""$GIT_COMMIT""'
       }
    }
        }
    }
}