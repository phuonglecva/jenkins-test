pipeline {
  agent any
  parameters {
    stashedFile 'large'
  }
  environment {
    model_path = "model.zip"
    AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')  
  }

  stages {
    stage('Upload (local -> jenkins)') {
      steps {
        sh 'echo $AWS_ACCESS_KEY_ID'
        sh 'echo $AWS_SECRET_ACCESS_KEY'
        // unstash 'large'
        // // sh 'cat large'
        // sh '''
        // mkdir -p data/models/ && \
        // mv -f large data/models/model.zip
        // '''
      }
    }
    stage('Upload to s3') {
      steps {
        withAWS(region='ap-southeast-1', credentials='aws-test-credentials') {
          def identity = awsIdentity()
          s3Upload(
            file:'data/models/model.zip', 
            bucket:'bdi-dev-kbqa', 
            path:'test/models/model.zip'
          )      
        }
      }
    }
 
  }
}