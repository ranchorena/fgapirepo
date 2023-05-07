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
        /*stage('login Server 135'){
            steps {
                sshagent(credentials:['SSH_Server_135_geouser']){
                    sh 'ssh -o StrictHostKeyChecking=no geouser@192.168.1.135 uptime "whoami"'
                }
                echo "success login"
            }
        }*/
        stage('Transfer files to remote server') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    //sh 'ssh user@192.168.1.135 mkdir -p /urs/src/app/fibergis_fgapi/fgapi'
                    sh 'scp C:/Code/FiberGIS_FGapi/Dockerfile geouser@192.168.1.135:/usr/src/app/fibergis_fgapi/'
                    sh 'scp C:/Code/FiberGIS_FGapi/requirements.txt geouser@192.168.1.135:/usr/src/app/fibergis_fgapi/'
                    sh 'scp -r C:/Code/FiberGIS_FGapi/fgapi geouser@192.168.1.135:/usr/src/app/fibergis_fgapi/'
                    //bat 'robocopy C:/Code/FiberGIS_FGapi/fgapi geouser@192.168.1.135:/usr/src/app/fibergis_fgapi/fgapi /xf *.* /s'
                    sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_fgapi/fgapi && rm -rf __pycache__ && rm -rf .vscode && rm -rf .git && ls -la"'
                }
            }
        }        
        stage('Build Docker image') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    //sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_fgapi && docker build -t fgapi:qa --no-cache /usr/src/app/fibergis_fgapi"'
                    sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_fgapi && docker build -t fgapi:qa --no-cache /usr/src/app/fibergis_fgapi"'             
                }
            }
        }      

    }   
}
