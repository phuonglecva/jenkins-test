pipeline{
    agent any
    environment {
        env1 = 'environment1'
        env2 = 'environment2'
        env3 = 'environment3'
        env4 = 'environment4'
    }
    stages{
        stage("Build"){
            steps{
                echo "========Buidding========"
                echo ${env1}
                echo ${env2}
                echo ${env3}
                echo ${env4}
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