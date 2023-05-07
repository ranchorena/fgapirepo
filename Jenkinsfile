pipeline {
    agent any
    /*environment {
        //IIS_SERVER = '192.168.1.52'
        //IIS_SITE_NAME = 'web.fibergis'
        //IIS_USER = 'gystems\\Jenkins'
        //IIS_PASSWORD = ''
        //GITLAB_API_TOKEN = credentials('Bitbucker_user_pwd')
    }*/    
    stages {
        stage('Checkout') {
            steps {
                dir('C:\\Code\\FiberGIS_FGapi\\fgapi') {
                    git url: 'https://x-token-auth:ATCTT3xFfGN0Qsafinng50B3bLyfebhVLppcjlJ9CUEd66XoMTEPfFBIuAK_5SIjaqK2tiVA0cuEU8_Yuu0qQjtd89QH7eQ1ECUMhXneNeSq384Ak9AYIpQ1L65_Ivf3gTrdFTJZGNT_URG-biMsZs5ItneRQtLDncjGUGVY_kyDvwt3LkeOJbY=8D7363DF@bitbucket.org/geosystems_ar/fgapi.git', branch: 'FiberGisPG_YJ'
                }
            }
        }
        stage('login Server 135'){
            steps {
                sshagent(credentials:['SSH_Server_135']){
                    sh 'ssh -o StrictHostKeyChecking=no jenkins@192.168.1.135 uptime "whoami"'
                }
                echo "success login"
            }
        }          
        /*stage('Build') {
            steps {
                dir('C:\\Code\\FiberGIS_FGapi\\fgapi') {
                    bat 'npm install'
                    bat 'npm run build -- --configuration production'
                }
            }
        } */       

    }   
}
