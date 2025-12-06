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
        sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName='numeric-application' -Dsonar.host.url=http://43.205.114.108:9000 -Dsonar.token=sqp_9ce582e3fb7a462e2d8235a5017831cbea9c54da"
    }
 timeout(time: 1, unit: 'HOURS') {
          waitForQualityGate abortPipeline: true
        }
}
}


 stage('Vulnerability Scan - Docker') {
     steps {
 
        		sh "mvn dependency-check:check"	
      	}
	post{
			always{
				dependencyCheckPublisher pattern: 'target/dependence-check-report.xml'~
}
}
     }
}


	   stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'sed -i "s#replace#0xbilaal/numeric-app:50e6f0c54490743a2a1070b8f5822a3e7580dfa8#g" k8s_deployment_service.yaml'
          sh 'kubectl apply -f k8s_deployment_service.yaml'
        }
      }
    }
    }
}