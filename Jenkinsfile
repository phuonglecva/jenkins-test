pipeline {
  agent any
  parameters {
    stashedFile 'large'
  }
  environment {
    model_path = "data/models/model.zip"
  }
  stages {
    stage('Example') {
      steps {
        unstash 'large'
        // sh 'cat large'
        sh 'mkdir -p data/model'
        sh 'mv -f large ${model_path}'
      }
    }
  }
}