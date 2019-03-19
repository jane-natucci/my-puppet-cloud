class cloud::jenkins {
  package {'java-1.8.0-openjdk.x86_64':
    ensure  => present,
  }

  wget::fetch { 'download ambari repo':
    source      => 'https://pkg.jenkins.io/redhat-stable/jenkins.repo',
    destination => '/etc/yum.repos.d/jenkins.repo',
  } ->
  exec {'rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key':
    path => '/usr/bin',
  } ->
  package {'jenkins':
    ensure => present,
  } ->
  service {'jenkins':
    ensure => running,
    enable => true,
  }
}
