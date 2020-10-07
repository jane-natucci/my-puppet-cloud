## Firewall rules for elasticsearch node.

class cloud::firewall::elasticsearch () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require => Service['firewalld'],
  }

  # kibana for home ip
  firewalld_rich_rule {'Port 5601 for home IP':
    ensure  => present,
    source  => $::cloud::params::ip_home,
    port    => {
      port     => '5601',
      protocol => 'tcp',
    },
    action  => 'accept',
    require => Service['firewalld'],
  }

  # kibana for www
  firewalld_rich_rule {'Port 5601 for www':
    ensure  => present,
    source  => $::cloud::params::ip_www,
    port    => {
      port     => '5601',
      protocol => 'tcp',
    },
    action  => 'accept',
    require => Service['firewalld'],
  }

  # elasticsearch
  firewalld_rich_rule {'Port 9200 for www':
    ensure  => present,
    source  => $::cloud::params::ip_www,
    port    => {
      port     => '9200',
      protocol => 'tcp',
    },
    action  => 'accept',
    require => Service['firewalld'],
  }

  exec {'firewall-cmd --reload':
    path => '/usr/bin',
  }
}
