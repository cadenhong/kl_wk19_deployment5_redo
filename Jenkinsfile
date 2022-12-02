pipeline {
  agent any
  environment {
    DOCKER_CREDS = credentials('docker-creds')
  }
   stages {
    stage ('Build') {
      steps {
        dir('url-shortener') {
          sh '''#!/bin/bash
          python3 -m venv test3
          source test3/bin/activate
          pip install pip --upgrade
          pip install -r requirements.txt
          export FLASK_APP=application
          flask run &
          '''
        }
     }
    }

    stage ('Test') {
      steps {
        dir('url-shortener') {
          sh '''#!/bin/bash
          source test3/bin/activate
          py.test --verbose --junit-xml test-reports/results.xml
          ''' 
        }
      }
      // post {
      //   always {
      //     junit '/var/lib/jenkins/workspace/dep5-redo_second/url-shortener/test-reports/results.xml'
      //   }
      // }
    }

    stage ('Create Container') {
      agent { label 'dockerAgent' }
      steps {
        sh '''
        docker build -t redo-urlshortener:${BUILD_NUMBER} url-shortener
        '''
      }
    }

    stage ('Push to Dockerhub') {
      agent { label 'dockerAgent' }
      steps {
          sh '''
          docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW
          docker tag redo-urlshortener:${BUILD_NUMBER} ch316/redo-urlshortener:${BUILD_NUMBER}
          docker push ch316/redo-urlshortener:${BUILD_NUMBER}
          docker images
          '''
        }
        }
      
    

    stage ('Deploy to ECS') {
      agent { label 'tfAgent' }
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                         string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                          dir('terraform-ecs') {
                            sh ''' #!/bin/bash
                            terraform init
                            terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"
                            terraform apply plan.tfplan
                            sleep 300
                            terraform destroy --auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"
                            '''
                          }
                        }
        }
      }
  }
}