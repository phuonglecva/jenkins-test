pipeline{
    agent any    
    environment {
        model_path = 'data/models/vosk/latest_model.tar.xz'
    }
    stages{
        stage("Build dockerfile"){
            steps {
                echo $model_path
            }
        }
    }
}