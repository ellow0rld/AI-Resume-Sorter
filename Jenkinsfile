pipeline {
    agent any
    environment {
        PORT = '5000'
        APP_DIR = '/var/lib/jenkins/resume-sorter'
        GEMINI_API_KEY = credentials('GEMINI_API_KEY') // Store this in Jenkins Credentials
    }
    stages {
        stage('Deploy Flask App') {
            steps {
                sh '''
                    fuser -k ${PORT}/tcp || true

                    if [ -d "$APP_DIR" ]; then
                        cd $APP_DIR
                        git pull
                    else
                        git clone https://github.com/ellow0rld/AI-Resume-Sorter.git $APP_DIR
                        cd $APP_DIR
                    fi

                    python3 -m venv venv
                    source venv/bin/activate

                    pip install -r requirements.txt

                    export FLASK_APP=app.py
                    export FLASK_ENV=production
                    export GEMINI_API_KEY=${GEMINI_API_KEY}

                    nohup flask run --host=0.0.0.0 --port=$PORT &
                '''
            }
        }
    }
}
