pipeline{
    agent any    
    
    stages{
        stage("Build dockerfile"){
            script {
                sh 'docker build -t jk_fastapi .'
            }
        }
    }
}