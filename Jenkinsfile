pipeline {
  agent any
  parameters {
    stashedFile 'model_latest.tar.xz'
    choice(name: 'env', choices: ['dev', 'prod'])
    choice(name: 'service_name', choices: ['va-slot-filling-online', 'asr-websocket-english'])
  }
  environment {
    model_path = "data/models/vosk"
    local_path = "data/models/vosk/model_latest.tar.xz"
    deployment_name = 'va-slot-filling-online'
    eks_namespace = 'vinbase'
    bucket_name = 'bdi-dev-kbqa'
    s3_model_path = 'test/models/model_latest.tar.xz' 
  }
  stages {
    stage('kubectl test') {
      steps  {
        script {
          if (params.service_name == 'va-slot-filling-online') {
            echo 'hello from va'
            def config = readYaml(file:"deploy/config.yaml")
            def bucket_name = config['va-slot-filling-models']['bucket_name'] 
            echo bucket_name
          } else {
            echo 'hello fallback'
            def config = readYaml(file:"deploy/config.yaml")
            def bucket_name = config['asr-websocket-english']['bucket_name'] 
            echo bucket_name
          }
        }
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
        sh 'echo ${local_path}'
        sh 'echo ${bucket_name}'
        sh 'echo ${s3_model_path}'

        withAWS(region: 'ap-southeast-1', credentials:'aws-test-credentials') {
          // def identity = awsIdentity()
          script {
            s3Upload(
              file:env.local_path, 
              bucket:env.bucket_name, 
              path:env.s3_model_path
            )
          }
        }
      }
    }

    stage('restart pod') {
      steps {
        echo 'restart pod'
        script {
          sh 'export KUBECONFIG=~/.kube/config'
          env.POD_NAME = sh(script: 'kubectl get pods -n ${eks_namespace} --selector=app.kubernetes.io/instance=${deployment_name} -o custom-columns=":metadata.name" --no-headers', returnStdout: true)
          sh 'printenv'
          // sh "echo ${POD_NAME}"
          sh 'kubectl delete pod ${POD_NAME} --now --namespace ${eks_namespace}'
        }
      }
    } 
  }
}