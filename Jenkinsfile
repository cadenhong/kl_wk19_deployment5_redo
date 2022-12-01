pipeline {
  agent any
  environment {
    DOCKER_CREDS = credentials('docker-creds')
  }
   stages {
    stage ('Build') {
      steps {
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

    stage ('Test') {
      steps {
        sh '''#!/bin/bash
        source test3/bin/activate
        py.test --verbose --junit-xml test-reports/results.xml
        ''' 
      }
      post {
        always {
          junit 'test-reports/results.xml'
        }
      }
    }

    // stage ('Create Container') {
    //   agent { label 'dockerAgent' }
    //   steps {
    //     def urlshortenerImage = docker.build("redo-urlshortener", "url-shortener")
    //     // docker build -t redo-urlshortener url-shortener
    //     urlshortenerImage.push()
    //   }
    // }

    stage ('Push to Dockerhub') {
      agent { label 'dockerAgent' }
      steps {
        withCredentials([usernamePassword(usernameVariable: 'dockerUser', passwordVariable: 'dockerPassword')]) {
          sh '''
          docker login -u ${env.dockerUser} -p ${env.dockerPassword}
          docker build -t redo-urlshortener url-shortener
          '''
        }
        //docker.withRegistry('https://registry.hub.docker.com', 'docker-creds') {
        //  def urlshortenerImage = docker.build("redo-urlshortener", "url-shortener")
        //  urlshortenerImage.push()
        }
      }
    }

    stage ('Deploy to ECS') {
      agent { label 'tfAgent' }
      steps {
        sh '''
          echo "Hi!"
        '''
      }
    }
   }