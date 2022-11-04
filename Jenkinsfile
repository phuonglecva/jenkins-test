pipeline {
  agent any
  parameters {
    base64File 'small'
    stashedFile 'large'
  }
  stages {
    stage('Example') {
      steps {
        withFileParameter('small') {
          sh 'cat $small'
        }
        unstash 'large'
        sh 'cat large'
      }
    }
  }
}