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
stage('Build JARR') {
    steps {
        sh 'mvn clean package -DskipTests'
    }
}
		stage('Sonarqube - SAST') {
    steps {
	withSonarQubeEnv('SonarQube'){
        sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName='numeric-application' -Dsonar.host.url=http://3.108.66.195:9000 -Dsonar.token=squ_430c3c52c515e1047556eaf0a80e4e50d6883503"
    }
 timeout(time: 1, unit: 'HOURS') {
          waitForQualityGate abortPipeline: true
        }
}
}


 stage('Vulnerability Scan - Dockerr') {
     steps {
 
        		sh "mvn dependency-check:check"	
      	}
	post{
			always{
				dependencyCheckPublisher pattern: 'target/dependence-check-report.xml'
}
}
     }



	   stage('Kubernetes Deployment - DEVV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'sed -i "s#replace#0xbilaal/numeric-app:50e6f0c54490743a2a1070b8f5822a3e7580dfa8#g" k8s_deployment_service.yaml'
          sh 'kubectl apply -f k8s_deployment_service.yaml'
        }
      }
    }
    }
}