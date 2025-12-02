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
	   stage('Docker Build and Push') {
     steps {
       withDockerRegistry([credentialsId: "dockerhub-config", url: ""]) {
        sh 'printenv'
 	 sh 'sudo docker build -t 0xbilaal/numeric-app:""$GIT_COMMIT"" .'
         sh 'docker push 0xbilaal/numeric-app:""$GIT_COMMIT""'
       }
    }
        }
    }
}