pipeline{
    agent{
        label "node"
    }
    stages{
        stage("Build"){
            steps{
                echo "========Buidding========"
            }
        }

        stage("Test") {
            steps {
                echo "====++++Testing++++===="
            }
        }
        
        stage("Deploy") {
            steps {
                echo "====++++Deploy++++===="
            }
        }
    }

}