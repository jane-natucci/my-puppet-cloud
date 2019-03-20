class cloud::gitlab {
  Exec {path => '/usr/bin'}

  package {'policycoreutils-python':
    ensure => present,
  }

  package {'postfix':
    ensure => present,
  }

  service {'postfix':
    ensure  => running,
    enable  => true,
    require => Package['postfix'],
  }

  wget::fetch {'download gitlab repo':
    source      => 'https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh',
    destination => '/root/script.rpm.sh',
  } ->
  file {'/root/script.rpm.sh':
    mode => '0744',
  }

  exec {'sh /root/script.rpm.sh':
    require => File['/root/script.rpm.sh'],
    unless  => 'ls /etc/yum.repos.d/gitlab_gitlab-ee.repo'
  } ->
  exec {'yum install -y gitlab-ee':
    environment => 'EXTERNAL_URL="https://gitlab.natucci.de"',
    unless      => 'rpm -qa | grep gitlab-ee',
  }

  service {'firewalld':
    ensure => running,
    enable => true,
  }

  exec {'firewall-cmd --add-service="http"':
    unless  => 'firewall-cmd --query-service="http"',
    require => Service['firewalld'],
  }
}
