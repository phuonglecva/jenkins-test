properties(
    [
        parameters(
            [ file(name: "file1", file: "file1.zip", description: 'Choose path to upload file1.zip from local system.') ]
            )
    ]
)

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