pipeline {
  agent any
  parameters {
    base64File 'THEFILE'
  }
  stages {
    stage('Example') {
      steps {
        withFileParameter('THEFILE') {
          sh 'cat $THEFILE'
        }
      }
    }
  }
}
  