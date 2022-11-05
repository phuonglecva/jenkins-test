pipeline {
  agent any
  parameters {
    stashedFile 'model_latest.tar.xz'
  }
  environment {
    model_path = "data/models/vosk"
    deployment_name = 'va-slot-filling-online'
    eks_namespace = 'vinbase'
    AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')  
  }

  stages {
    stage('kubectl test') {
      steps  {
        echo 'testing'
        // sh 'kubectl get pods -n ${eks_namespace}'
      }
    }
    stage('Upload (local -> jenkins)') {
      steps {
        sh 'echo $AWS_ACCESS_KEY_ID'
        sh 'echo $AWS_SECRET_ACCESS_KEY'
        unstash 'model_latest.tar.xz'
        // sh 'cat large'
        sh '''
        mkdir -p ${model_path} && \
        mv -f model_latest.tar.xz ${model_path}/model_latest.tar.xz
        '''
      }
    }
    stage('Upload to s3') {
      steps {
        withAWS(region: 'ap-southeast-1', credentials:'aws-test-credentials') {
          // def identity = awsIdentity()
          s3Upload(
            file:'data/models/vosk/model_latest.tar.xz', 
            bucket:'bdi-dev-kbqa', 
            path:'test/models/model_latest.tar.xz'
          )      
        }
      }
    }

    stage('restart pod') {
      steps {
        echo 'restart pod'
        script {
          sh 'export KUBECONFIG=~/.kube/config'
          def env.POD_NAME = sh(script: 'kubectl get pods -n vinbase --selector=app.kubernetes.io/instance=${deployment_name} -o custom-columns=":metadata.name" --no-headers', returnStdout: true)
          sh 'echo ${env.POD_NAME}'
        }
        // sh 'kubectl delete pod ${pod_name} --now --namespace ${eks_namespace}'
      }
    }
 
  }
}