pipeline{
    agent {
        dockerfile true
    }
    stages{
        stage("Build") {
            steps {
                checkout scm 
            }
            def image = docker.build("jk_fastapi:latest")
            image.inside {
                sh 'curl http://localhost:8000'
            }
        }
    }
}