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
                echo "====++++Testing++++===="
                sh 'printenv'
            }
        }

        stage("Deploy") {
            steps {
                echo "====++++Deploy++++===="
                echo '${env}'
            }
        }
    }

}