pipeline {
  agent any
  parameters {
    stashedFile 'model_file'
  }
  environment {
    model_path = "data/models/model.zip"
  }
  stages {
    stage('BUILD') {
      steps {
        unstash 'model_file'
        sh 'mv model_file $model_path' 
      }
    }
  }
}