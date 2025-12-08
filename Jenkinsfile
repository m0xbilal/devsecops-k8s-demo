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
        sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.projectName='numeric-application' -Dsonar.host.url=http://3.108.66.195:9000 -Dsonar.token=squ_8b7afd448d51e5347aa197767b16942655fb666d"
    }
 timeout(time: 1, unit: 'HOURS') {
          waitForQualityGate abortPipeline: true
        }
}
}


	 stage('Vulnerability Scan - Docker') {
       steps {
		parallel(
			"Trivy Scan":{
				sh "bash trivy-docker-image-scan.sh"
			},
			"OPA Conftest": {
    sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
} 	
      	)

 			
      }

    }

     stage('Docker Build and Push') {
       steps {
       withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'printenv'
          sh 'sudo docker build -t 0xbilaal/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push 0xbilaal/numeric-app:""$GIT_COMMIT""'
        }
      }
    }


	 stage('Vulnerability Scan - Kubernetes') {
      steps {
        sh '''\
          docker run --rm \
            -v $(pwd):/project \
            openpolicyagent/conftest test \
            --policy opa-k8s-security.rego \
            k8s_deployment_service.yaml
        '''
      }
    }

	   stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'sed -i "s#replace#0xbilaal/numeric-app:${GIT_COMMIT}#g" k8s_deployment_service.yaml'
          sh 'kubectl apply -f k8s_deployment_service.yaml'
        }
      }
    }
    }$GIT_COMMIT
}