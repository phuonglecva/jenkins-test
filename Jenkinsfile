pipeline{
    agent any    
    
    stages{
        stage("Build dockerfile"){
            steps {
                script {
                    sh 'docker build -t jk_fastapi .'
                    sh 'docker run -p 8000:8000 jk_fastapi'
                    sh 'curl http://localhost:8000'
                }
            }
        }
    }
}