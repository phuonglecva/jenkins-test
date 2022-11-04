pipeline{
    agent any    
    environment {
        model_path = 'data/models/vosk/latest_model.tar.xz'
    }
    stages{
        stage("Build dockerfile"){
            steps {
                sh """
                echo ${model_path}
                if [! -f /tmp/foo.txt]; then
                    echo 'File not found'
                fi
                """
            }
        }
    }
}