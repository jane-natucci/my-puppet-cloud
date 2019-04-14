pipeline {
    agent any

    stages {
        stage('Lint') {
            steps {
                echo 'Checking syntax..'
                echo 'Skipping linting...'
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

                sh 'ssh root@puppet \'cp /etc/puppetlabs/code/environments/production/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp.old\''

                sh 'scp $(ls -t pkg/puppet-cloud-*.tar.gz | head -n 1) root@puppet:/tmp/'

                sh 'ssh root@puppet \'puppet module install -f $(ls -t /tmp/puppet-cloud-*.tar.gz | head -n 1)\''

                sh 'ssh root@puppet \'cp /etc/puppetlabs/code/environments/production/modules/cloud/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp\''
            }
        }
    }
}