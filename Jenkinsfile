pipeline{
    agent any
    stages{
        stage("Build"){
            steps{
                echo "========Buidding========"
            }
        }

        stage("Test") {
            steps {
                sh 'printenv'
            }
        }

        stage("Deploy") {
            steps {
                echo "====++++Deploy++++===="
            }
        }
    }

}