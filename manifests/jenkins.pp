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

  file {'/tmp/temporary':
    ensure => directory,
    owner  => 'root',
    mode   => '0644',
  }
}
