pipeline{
    agent any
    stages{
        stage("A"){
            steps{
                echo "========executing AAAAAA========"
            }
            post{
                always{
                    echo "========alwaysssss========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}