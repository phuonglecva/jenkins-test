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
        sh '''
        mkdir -p data/models/ && \
        mv -f large data/models/model.zip
        '''
      }
    }
  }
}