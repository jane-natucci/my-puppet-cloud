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
    environment => 'EXTERNAL_URL=https://gitlab.natucci.de',
    unless      => 'rpm -qa | grep gitlab-ee',
  }

  service {'firewalld':
    ensure => running,
    enable => true,
  }

  exec {'firewall-cmd --add-rich-rule="rule family=ipv4 source address=37.252.248.93 service name=http accept"':
    unless => 'firewall-cmd --query-rich-rule="rule family=ipv4 source address=37.252.248.93 service name=http accept"',
    require => Service['firewalld'],
  }

  exec {'firewall-cmd --add-rich-rule="rule family=ipv4 source address=37.252.248.93 service name=https accept"':
    unless => 'firewall-cmd --query-rich-rule="rule family=ipv4 source address=37.252.248.93 service name=https accept"',
    require => Service['firewalld'],
  }
}
