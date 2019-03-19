class cloud::jenkins {
  Exec {path => '/usr/bin'}

  package {'java-1.8.0-openjdk.x86_64':
    ensure  => present,
  }

  wget::fetch { 'download ambari repo':
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
  } ->
  exec {'firewall-cmd --add-rich-rule=\'rule family="ipv4" source address="37.252.248.93" accept\'':
    unless => 'firewall-cmd --query-rich-rule=\'rule family="ipv4" source address="37.252.248.93" accept\''
  }
}
