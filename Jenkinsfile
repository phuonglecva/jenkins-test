pipeline {
  agent any
  parameters {
    stashedFile 'model_latest.tar.xz',
    choice(name: 'env', choices: ['dev', 'prod'], defaultValue:'dev')
  }
  environment {
    model_path = "data/models/vosk"
    deployment_name = 'va-slot-filling-online'
    eks_namespace = 'vinbase'
    bucket_name = 'bdi-dev-kbqa'
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
            bucket:'${bucket_name}', 
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
          def POD_NAME = sh(script: 'kubectl get pods -n ${eks_namespace} --selector=app.kubernetes.io/instance=${deployment_name} -o custom-columns=":metadata.name" --no-headers', returnStdout: true)
          sh "echo ${POD_NAME}"
          sh 'kubectl delete pod ${POD_NAME} --now --namespace ${eks_namespace}'
        }
      }
    }
 
  }
}