pipeline {
    agent any 
    stages {
        stage('Checkout') {
            steps {
                dir('C:\\Code\\FiberGIS_FGapi\\fgapi') {
                    git branch: 'FiberGisPG_YJ', url: 'https://x-token-auth:ATCTT3xFfGN0Qsafinng50B3bLyfebhVLppcjlJ9CUEd66XoMTEPfFBIuAK_5SIjaqK2tiVA0cuEU8_Yuu0qQjtd89QH7eQ1ECUMhXneNeSq384Ak9AYIpQ1L65_Ivf3gTrdFTJZGNT_URG-biMsZs5ItneRQtLDncjGUGVY_kyDvwt3LkeOJbY=8D7363DF@bitbucket.org/geosystems_ar/fgapi.git'
                    script {
                        def commit_hash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        def commit_message = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                        env.LAST_COMMIT_HASH = commit_hash
                        env.LAST_COMMIT_MESSAGE = commit_message
                    }
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                dir('C:\\Code\\FiberGIS_FGapi\\fgapi') {
                    withSonarQubeEnv('sonarqubeserver') {
                        script {
                            def scannerHome = tool 'sonarscanner'
                            withSonarQubeEnv(credentialsId: 'sonarqube') {
                                bat "${scannerHome}\\bin\\sonar-scanner.bat -Dsonar.projectKey=FiberGIS_FGapi"
                            }
                        }
                    }
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
                    sh 'ssh geouser@192.168.1.135 "cd /usr/src/app/fibergis_fgapi/fgapi && rm -rf __pycache__ && rm -rf .vscode && rm -rf .git && rm -rf .scannerwork && ls -la"'
                }
            }
        }        
        stage('Build Docker image') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    sh '''
                        ssh geouser@192.168.1.135 "
                            cd /usr/src/app/fibergis_fgapi && 
                            if docker ps -a | grep fgapi >/dev/null 2>&1; then docker stop fgapi && 
                            docker rm fgapi; fi &&                            
                            docker image rm -f fgapi:qa || true && 
                            docker build -t fgapi:qa --no-cache /usr/src/app/fibergis_fgapi
                        "
                    '''             
                }
            }
        }      
        stage('Run Docker container') {
            steps {
                sshagent(['SSH_Server_135_geouser']) {
                    sh '''
                        ssh geouser@192.168.1.135 " 
                            docker run -d --restart=always -p 6062:6062 --name fgapi fgapi:qa
                        "
                    '''
                }
            }
        }
    } 
    post {
        success {
            emailext body: "La subida de FiberGIS_FGapi se ha completado con exito.\n\n" +
                           "Ultimo mensaje de commit: ${env.LAST_COMMIT_MESSAGE}\n\n" +
                           "Commit Id: ${env.LAST_COMMIT_HASH}.\n\n" +
                           "API Gestion (fgapi)\n" +
                           "https://web.fibergis.com.ar/dev/FGApi/\n\n" +
                           "Job Name: ${env.JOB_NAME}\n" +
                           "Build: ${env.BUILD_NUMBER}\n" +
                           "Console output: ${env.BUILD_URL}",
                     subject: 'FiberGIS_FGapi - Subida Exitosa',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
        failure {
            emailext body: "La subida de FiberGIS_FGapi ha fallado.\n\n" +
                           "Job Name: ${env.JOB_NAME}\n" +
                           "Build: ${env.BUILD_NUMBER}\n" +
                           "Console output: ${env.BUILD_URL}",             
                     subject: 'FiberGIS_FGapi - La subida ha Fallado - ERROR',
                     to: 'Raul.Anchorena@geosystems.com.ar;Agustin.David@geosystems.com.ar'
        }
    }   
}
