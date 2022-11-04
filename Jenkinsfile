pipeline{
    agent any    
    environment {
        model_path = 'data/models/vosk/latest_model.tar.xz'
    }
    stages{
        stage("Build dockerfile"){
            steps {
                sh """
                if [ ! -f ${model_path} ]; then
                    echo 'File not found'
                fi
                """
            }
        }
    }
}