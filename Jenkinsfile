pipeline {
  agent any
  parameters {
    stashedFile 'large'
  }
  environment {
    model_path = "model.zip"
  }
  stages {
    stage('Example') {
      steps {
        unstash 'large'
        // sh 'cat large'
        sh 'mv -f large ${model_path}'
      }
    }
  }
}