pipeline {
    agent any

    stages {
        stage('Lint') {
            steps {
                echo 'Checking syntax..'

                sh 'puppet-lint manifests/'
            }
        }

        stage('Build') {
            steps {
                echo 'Building..'

                sh '/opt/puppetlabs/bin/puppet module build .'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying..'

                sh 'scp $(ls -t pkg/puppet-cloud-*.tar.gz | head -n 1) root@puppet:/tmp/'

                sh 'ssh root@puppet \'puppet module install -f $(ls -t /tmp/puppet-cloud-*.tar.gz | head -n 1)\''
            }
        }
    }
}