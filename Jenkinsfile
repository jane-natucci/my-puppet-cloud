pipeline {
    agent any

    stages {
        stage('Lint') {
            steps {
                sh '/usr/local/bin/puppet-lint manifests/ || true'
            }
        }

        stage('Build') {
            steps {
                sh '/opt/puppetlabs/bin/puppet module build .'
            }
        }
        
        stage('Install puppet-cloud.tar.gz') {
            steps {
                sh 'sudo /opt/puppetlabs/bin/puppet module install -f $(ls -t pkg/puppet-cloud-*.tar.gz | head -n 1)'
            }
        }

        stage('Backup site.pp') {    
            when {
                expression { return fileExists('/etc/puppetlabs/code/environments/production/manifests/site.pp') }
            }
            steps {
                sh 'sudo cp /etc/puppetlabs/code/environments/production/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp.old'
            }
        }
        
        stage('Deploy site.pp') {
            steps {
                sh 'sudo cp /etc/puppetlabs/code/environments/production/modules/cloud/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp'
            }
        }

        stage('puppet agent -t') {
            steps {
                sh 'sudo /opt/puppetlabs/bin/puppet agent -t'
            }
        }
    }
}
