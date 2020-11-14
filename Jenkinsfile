pipeline {
    agent any

    stages {
        stage('Lint.') {
            steps {
                sh '/usr/local/bin/puppet-lint --no-autoloader_layout-check manifests/'
            }
        }

        stage('Build.') {
            steps {
                sh '/opt/puppetlabs/bin/puppet module build .'
            }
        }
        
        stage('Install puppet-cloud.tar.gz.') {
            steps {
                sh 'sudo /opt/puppetlabs/bin/puppet module install -f $(ls -t pkg/puppet-cloud-*.tar.gz | head -n 1)'
            }
        }

        stage('Backup site.pp.') {    
            when {
                expression { return fileExists('/etc/puppetlabs/code/environments/production/manifests/site.pp') }
            }
            steps {
                sh 'sudo cp /etc/puppetlabs/code/environments/production/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp.old'
            }
        }
        
        stage('Deploy site.pp.') {
            steps {
                sh 'sudo cp /etc/puppetlabs/code/environments/production/modules/cloud/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp'
            }
        }

        stage('Run puppet.') {
            parallel  {
                stage('Run puppet on jenkins.natucci.de.') {
                    agent any

                    steps {
                        // jenkins is on the same server as puppet
                        sh '''
                        sudo /opt/puppetlabs/bin/puppet agent -t || if [ $? -eq 2 ]; then echo puppet agent -t executed successfully and some resources were updated; else exit $?; fi
                        '''
                    }
                }

                stage('Run puppet on openshift.natucci.de.') {
                    agent any

                    steps {
                        withCredentials([sshUserPrivateKey(credentialsId: "ssh-key-for-accessing-nodes", keyFileVariable: 'SSH_KEY_PATH')]) {
                            sh '''
                            ssh -i $SSH_KEY_PATH -o StrictHostKeyChecking=no root@openshift.natucci.de '/opt/puppetlabs/bin/puppet agent -t || if [ $? -eq 2 ]; then echo puppet agent -t executed successfully and some resources were updated; else exit $?; fi'
                            '''
                        }
                    }
                }
            }
        }
    }
}
