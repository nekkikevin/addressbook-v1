pipeline {
    agent any

    tools{
        maven "mymaven"
    }

    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Environment to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'])
    }

    stages {
        stage('Compile') {
            steps {
                script{
                    echo "Compiling the code"
                    echo "Compiling in ${params.Env}"
                    sh "mvn compile"
                }
                
            }
            
        }
        stage('CodeReview') {
            steps {
                script{
                    echo "Code Review Using pmd plugin"
                    sh "mvn pmd:pmd"
                }
                
            }
            
        }
        stage('UnitTest') {
             when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                    echo "UnitTest in junit."
                    sh "mvn test"
                }
                
            }
            
        }
        stage('CodeCoverage') {
            steps {
                script{
                    echo "Code Coverage by jacoco"
                    sh "mvn verify"
                }
                
            }
            
        }
        stage('Package') {
            agent {label 'linux_slave'}
            input{
                message "Select the platform for deployment"
                ok "Platform selected"
                parameters{
                    choice(name:'NEWAPP',choices:['JFROG','EC2'])
                    sh "mvn package"
                }
            }

            steps {
                script{
                    echo "packaging the code"
                    echo "packing the version ${params.APPVERSION}"
                }
                
            }
            
        }
    }
}
