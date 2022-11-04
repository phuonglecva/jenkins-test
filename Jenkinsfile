pipeline{
    agent any    
    
    stages{
        stage("Build dockerfile"){
            steps {
                script {
                    sh 'docker build -t jk_fastapi .'
                }
            }
        }
    }
}