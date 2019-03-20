class cloud::jenkins {
  Exec {path => '/usr/bin'}

  package {'java-1.8.0-openjdk.x86_64':
    ensure => present,
  }

  wget::fetch {'download jenkins repo':
    source      => 'https://pkg.jenkins.io/redhat-stable/jenkins.repo',
    destination => '/etc/yum.repos.d/jenkins.repo',
  } ->
  exec {'rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key':
  } ->
  package {'jenkins':
    ensure => present,
  } ->
  service {'jenkins':
    ensure => running,
    enable => true,
  }

  service {'firewalld':
    ensure => running,
    enable => true
  }

  exec {'firewall-cmd --add-rich-rule=\'rule family="ipv4" source address="37.252.248.93" accept\'':
    unless => 'firewall-cmd --query-rich-rule=\'rule family="ipv4" source address="37.252.248.93" accept\'',
    require => Service['firewalld'],
  }

  exec {'firewall-cmd --add-rich-rule=\'rule family="ipv4" source address="116.203.70.215" accept\'':
    unless => 'firewall-cmd --query-rich-rule=\'rule family="ipv4" source address="116.203.70.215" accept\'',
    require => Service['firewalld'],
  }

  file {'/var/lib/jenkins/.docker':
    ensure  => directory,
    owner   => 'jenkins',
    mode    => '0644',
  }

  file {'/var/lib/jenkins/.docker/config.json':
    ensure  => present,
    source  => 'puppet:///modules/cloud/config.json',
    owner   => 'jenkins',
    mode    => '0644',
    require => [
      File['/var/lib/jenkins/.docker/'],
    ]
  }

  package {'rubygem-puppet-lint':}
}
