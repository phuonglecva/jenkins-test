pipeline {
  agent any
  parameters {
    stashedFile 'data/models/model.zip'
  }
  stages {
    stage('BUILD') {
      steps {
        unstash 'data/models/model.zip'
        // sh 'mv ZIPPED_MODEL_FILE $ZIPPED_MODEL_FILE_FILENAME' 
        
      }
    }
  }
}