pipeline {
  agent any
  parameters {
    stashedFile 'LARGE'
  }
  environment {
    model_path = "data/models/model.zip"
  }
  stages {
    stage('BUILD') {
      steps {
        unstash 'LARGE'
        sh 'echo ${model_path}'
        sh 'mv LARGE $model_path' 
      }
    }
  }
}