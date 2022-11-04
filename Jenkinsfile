pipeline {
  agent any
  parameters {
    stashedFile 'large'
  }
  stages {
    stage('Example') {
      steps {
        unstash 'large'
        sh 'cat large'
      }
    }
  }
}