## Configuration of the jenkins node.

class cloud::jenkins {
  Exec {path => '/usr/bin'}
  Package {ensure => present}

  package {'java-1.8.0-openjdk.x86_64':}
  package {'rubygem-puppet-lint':}

  wget::fetch {'download jenkins repo':
    source      => 'https://pkg.jenkins.io/redhat-stable/jenkins.repo',
    destination => '/etc/yum.repos.d/jenkins.repo',
  }
  -> exec {'rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key':
  }
  -> package {'jenkins':
    require => Package['java-1.8.0-openjdk.x86_64']
  }
  -> service {'jenkins':
    ensure => running,
    enable => true,
  }
  -> service {'httpd':
    ensure => running,
    enable => true,
  }

  file {'/var/lib/jenkins':
    ensure => directory,
    owner  => 'jenkins',
    mode   => '0644',
  }

  wget::fetch {'download terraform':
    source      => 'https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip',
    destination => '/root/terraform.zip',
  }
  -> exec {'unzip /root/terraform.zip -d /usr/local/bin/':
    path   => '/usr/bin',
    unless => 'ls /usr/local/bin/terraform'
  }

  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    ipv4acls                   => ['host all blog 0.0.0.0/0 md5'],
  }
}
