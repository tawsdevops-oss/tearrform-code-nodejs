pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-2"
        ACCOUNT_ID = "218227655627"
    }
    parameters {
        choice(
            name: 'Choice_ENV',
            choices: ['dev-branch','main','stage'],
            description: 'Deployment Environment Branches'
        )
    }

    stages {

        stage('CleanUP') {
            steps {
                cleanWs()
            }
        }
		
        stage('Git Clone with variables') {
            steps {
                
                   git branch: "${params.Choice_ENV}",
                   credentialsId: 'git-login',
                   url: 'https://github.com/tawsdevops-oss/tearrform-code-nodejs.git'
            }
        }

        stage('Build Docker Job') {
            steps {

                bat """ docker build -t git-code ."""
            }
        }
        stage('AWS ECR Push Job') {
            steps {
              withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-login-cred']]) {  
                  
                bat """ aws ecr get-login-password --region ap-south-2 | docker login --username AWS --password-stdin 218227655627.dkr.ecr.ap-south-2.amazonaws.com"""
                 bat """ docker tag git-code:latest 218227655627.dkr.ecr.ap-south-2.amazonaws.com/git-code:latest """
                 bat """ docker push 218227655627.dkr.ecr.ap-south-2.amazonaws.com/git-code:latest """
                 
              }
            }
        }
        stage('Deploy with Terraform') {
            steps {
                dir('terraform') {
                    bat """
                    terraform init
                    terraform apply -auto-approve -var="image_url=218227655627.dkr.ecr.ap-south-2.amazonaws.com/git-code:latest"
                    """
                }
            }
        }


    }
}