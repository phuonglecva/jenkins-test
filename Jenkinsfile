pipeline {
  agent any
  parameters {
    stashedFile(name: 'model.zip', description: 'model type: model.zip for va-slot-filling-online service, model_latest.tar.xz for asr-websocket-english')
    choice(name: 'env', choices: ['dev', 'prod'])
    choice(name: 'service_name', choices: ['va-slot-filling-online', 'asr-websocket-english'])
  }
  environment {
    eks_namespace = 'vinbase'

    vsfo_model_dir = "data/models"
    vsfo_local_path = "data/models/model.zip"
    vsfo_deployment = "va-slot-filling-online"
    vsfo_bucket_name = "bdi-nlp-models"
    vsfo_bucket_name_prd = "bdi-prd-nlp-models"
    vsfo_s3_model_path = "entity-general/model.zip"
    vsfo_test_config_file = "model/config.yaml"
    vsfo_test_model_dir = "model/vocab"
    
    asr_model_dir = "data/models"
    asr_local_path = "data/models/model_latest.tar.xz"
    asr_deployment = "asr-websocket-english"
    asr_bucket_name = "bdi-dev-speech-models"
    asr_bucket_name_prd = "bdi-prd-speech-models"
    asr_s3_model_path = "data/models/vosk/asr_english/model_latest.tar.xz"
    asr_test_config_file = "model_latest/conf/model.conf"
    asr_test_model_dir = "model_latest/am"

  }
  stages {
    stage('read configuration') {
      steps  {
        script {
          if (params.service_name == 'va-slot-filling-online') {
            env.model_dir =  sh(script:'echo $vsfo_model_dir', returnStdout:true).trim()
            env.local_path =  sh(script:'echo $vsfo_local_path', returnStdout:true).trim()
            env.deployment =  sh(script:'echo $vsfo_deployment', returnStdout:true).trim()
            if (params.env == 'dev') {
              env.bucket_name =  sh(script:'echo $vsfo_bucket_name', returnStdout:true).trim()
            } else  {
              env.bucket_name =  sh(script:'echo $vsfo_bucket_name_prd', returnStdout:true).trim()
            }
            env.s3_model_path =  sh(script:'echo $vsfo_s3_model_path', returnStdout:true).trim()
            env.test_config_file =  sh(script:'echo $vsfo_test_config_file', returnStdout:true).trim()
            env.test_model_dir =  sh(script:'echo $vsfo_test_model_dir', returnStdout:true).trim()
            

          } else if (params.service_name == 'asr-websocket-english') {
            env.model_dir =  sh(script:'echo $asr_model_dir', returnStdout:true).trim()
            env.local_path =  sh(script:'echo $asr_local_path', returnStdout:true).trim()
            env.deployment =  sh(script:'echo $asr_deployment', returnStdout:true).trim()
            if (params.env == 'dev') {
              env.bucket_name =  sh(script:'echo $asr_bucket_name', returnStdout:true).trim()
            } else {
              env.bucket_name =  sh(script:'echo $asr_bucket_name_prd', returnStdout:true).trim()
            }
            env.s3_model_path =  sh(script:'echo $asr_s3_model_path', returnStdout:true).trim()
            env.test_config_file =  sh(script:'echo $asr_test_config_file', returnStdout:true).trim()
            env.test_model_dir =  sh(script:'echo $asr_test_model_dir', returnStdout:true).trim()
          }
        }
      }
    }
    
    stage('Upload (local -> jenkins)') {
      steps {
        // sh 'printenv'
        unstash 'model.zip'
        script {
          env.is_empty_model = sh(script: '''
            if [ -s model.zip ]; then
              echo 'NOT EMPTY'
            else
              echo 'EMPTY'
            fi
          ''', returnStdout:true).trim()

          if (env.is_empty_model == 'EMPTY') {
            currentBuild.result = 'FILE EMPTY'
            error("FILE NOT FOUND OR EMPTY")
          } 
          // sh 'printenv'
        }
        sh '''
          mkdir -p ${model_dir} && \
          mv -f model.zip ${local_path}
        '''
        sh "echo 'copied model to ${local_path}'"
      }
    }
    
    stage('extract and test model structure') {
      steps {
        script {
          env.output_dir = sh(script: 'echo output_dir/${BUILD_NUMBER}', returnStdout: true).trim()

          sh 'mkdir -p ${output_dir}' 
          if (params.service_name == 'va-slot-filling-online') {
            sh 'unzip -x ${local_path} -d ${output_dir} && tree ${output_dir}'
            echo 'unzip successful to ${output_dir}'
          } else  {
            sh 'tar -xvf ${local_path} -C ${output_dir} && tree ${output_dir}'
            echo 'untar successful to ${output_dir}'
          }

          env.is_file_exists = sh(script:"""
            if [ -f '${output_dir}/${test_config_file}' ]; then
              echo 'EXISTS'
            else
              echo 'NOT EXISTS'
            fi
          """, returnStdout: true).trim()
          if (env.is_file_exists == 'NOT EXISTS') {
            currentBuild.result = 'NOT FOUND CONFIG'
            error("NOT FOUND ${test_config_file} IN UPLOADED MODEL.")
          }

          env.is_dir_exists = sh(script:"""
            if [ -d '${output_dir}/${test_model_dir}' ]; then
              echo 'EXISTS'
            else
              echo 'NOT EXISTS'
            fi
          """, returnStdout: true).trim()
          if (env.is_dir_exists == 'NOT EXISTS') {
            currentBuild.result = 'NOT FOUND CONFIG'
            error("NOT FOUND ${test_model_dir} IN UPLOADED MODEL.")
          }
        }
      }
    }
    stage('Upload to s3') {
      steps {
        echo local_path
        echo bucket_name
        echo s3_model_path

        withAWS(region: 'ap-southeast-1', credentials:'aws-test-credentials') {
          script {
            // currentBuild.result = 'ABORT'
            // error("Testing abort")
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
          env.POD_NAME = sh(script: 'kubectl get pods -n ${eks_namespace} --selector=app.kubernetes.io/instance=${deployment} -o custom-columns=":metadata.name" --no-headers', returnStdout: true)
          // sh 'printenv'
          // sh "echo ${POD_NAME}"
          sh 'kubectl delete pod ${POD_NAME} --now --namespace ${eks_namespace}'
        }
      }
    } 
  }
}