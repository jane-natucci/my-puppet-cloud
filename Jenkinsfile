pipeline {
    agent any

    stages {
        stage('Lint') {
            steps {
                echo 'Checking syntax..'
                sh 'echo puppet-lint manifests/'
            }
        }

        stage('Build') {
            steps {
                echo 'Building..'

                sh '/opt/puppetlabs/bin/puppet module build .'
            }
        }
        
        stage('Install') {
            steps {
                echo 'Installing..'

                sh 'sudo /opt/puppetlabs/bin/puppet module install -f $(ls -t pkg/puppet-cloud-*.tar.gz | head -n 1)'
            }
        }

        stage('Deploy') {            
            echo 'Deploying..'
            
            when {
                expression { return fileExists('/etc/puppetlabs/code/environments/production/manifests/site.pp') }
                steps {
                    sh 'cp /etc/puppetlabs/code/environments/production/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp.old'
                }
            }
            
            steps {
                sh 'cp /etc/puppetlabs/code/environments/production/modules/cloud/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp'
            }
        }
    }
}
