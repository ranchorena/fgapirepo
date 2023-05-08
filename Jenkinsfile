pipeline {
    agent any 
    stages {
        stage('Checkout') {
            steps {
                dir('C:\\Code\\FiberGIS_FGapi\\fgapi') {
                    git url: 'https://x-token-auth:ATCTT3xFfGN0Qsafinng50B3bLyfebhVLppcjlJ9CUEd66XoMTEPfFBIuAK_5SIjaqK2tiVA0cuEU8_Yuu0qQjtd89QH7eQ1ECUMhXneNeSq384Ak9AYIpQ1L65_Ivf3gTrdFTJZGNT_URG-biMsZs5ItneRQtLDncjGUGVY_kyDvwt3LkeOJbY=8D7363DF@bitbucket.org/geosystems_ar/fgapi.git', branch: 'FiberGisPG_YJ'
                }
            }
        }
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
                    sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_fgapi && docker build -t fgapi:qa --no-cache /usr/src/app/fibergis_fgapi"'             
                }
            }
        }      
        stage('Run Docker container') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    // sh 'ssh geouser@192.168.1.135 "docker run -p 6062:6062 --name fgapi fgapi:qa"'
                    sh 'ssh geouser@192.168.1.135 "if docker ps -a | grep fgapi >/dev/null 2>&1; then docker stop fgapi && docker rm fgapi; fi && docker run -d -p 6062:6062 --name fgapi fgapi:qa"'
                }
            }
        } 
    } 
    post {
        /*always {
            emailext body: 'El pipeline de FiberGIS se ha completado.', 
                     subject: 'Pipeline completado',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }*/
        success {
            emailext body: 'El pipeline de FiberGIS_FGapi se ha completado con exito.', 
                     subject: 'Pipeline exitoso',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
        failure {
            emailext body: 'El pipeline de FiberGIS_FGapi ha fallado.', 
                     subject: 'Pipeline fallido',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
    }      
}
