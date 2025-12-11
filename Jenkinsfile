@Library('slack') _


pipeline {
    agent any

	environment {
        deploymentName = 'devsecops'
        containerName  = 'devsecops-container'
        serviceName    = 'devsecops-svc'
        imageName      = "0xbilaal/numeric-app:${GIT_COMMIT}"
        applicationURL = 'http://3.108.66.195/'
        applicationURI = '/increment/99'
    }

    stages {

 stage('Slack Test') {
            steps {
                slackSend(channel: '#jenkins', message: 'Jenkins Slack test message 🤖')
            }
        }
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
    sh 'printenv'
} 	
      	)

 			
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

     stage('Vulnerability Scan - Kubernetes') {
       steps {
         parallel(
           "Kubesec Scan": {
             sh "bash kubesec-scan.sh"
           },
         "Trivy Scan": {
	    sh 'ls -la'	
            sh "bash trivy-k8s-scan.sh"
           }
         )
       }
     }

stage('K8S Deployment - DEV') {
    steps {
        parallel(
            Deployment: {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh 'bash k8s-deployment.sh'
                }
            },
            Rollout_Status: {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh 'bash k8s-deployment-rollout-status.sh'
                }
            }
        )
    }
}

	//   stage('Kubernetes Deployment - DEV') {
      // steps {
        // withKubeConfig([credentialsId: 'kubeconfig']) {
          // sh 'sed -i "s#replace#0xbilaal/numeric-app:${GIT_COMMIT}#g" k8s_deployment_service.yaml'
          // sh 'kubectl apply -f k8s_deployment_service.yaml'
        // }
     // }
    // }

    stage('OWASP ZAP - DASTT') {
       steps {
         withKubeConfig([credentialsId: 'kubeconfig']) {
           // sh 'bash zap.sh' 
	    sh 'ls -la'
         }
       }
     }

stage('Reload Library') {
    steps {
        def call(String buildStatus = 'STARTED') {
 buildStatus = buildStatus ?: 'SUCCESS'

 def color

 if (buildStatus == 'SUCCESS') {
  color = '#47ec05'
  emoji = ':ww:'
 } else if (buildStatus == 'UNSTABLE') {
  color = '#d5ee0d'
  emoji = ':deadpool:'
 } else {
  color = '#ec2805'	
  emoji = ':hulk:'
 }

 def msg = "${buildStatus}: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n${env.BUILD_URL}"

slackSend(channel: '#jenkins', color: color, message: msg)
    }
}
}
post {
    always {
        script {
            def buildStatus = currentBuild.currentResult ?: 'SUCCESS'
            def color
            def emoji

            if (buildStatus == 'SUCCESS') {
                color = '#47ec05'
                emoji = ':white_check_mark:'
            } else if (buildStatus == 'UNSTABLE') {
                color = '#d5ee0d'
                emoji = ':warning:'
            } else {
                color = '#ec2805'
                emoji = ':x:'
            }

            def msg = "${emoji} *${buildStatus}*: `${env.JOB_NAME}` #${env.BUILD_NUMBER}\n${env.BUILD_URL}"

            slackSend(
                channel: '#jenkins',
                color: color,
                message: msg
            )
        }
    }
}

}