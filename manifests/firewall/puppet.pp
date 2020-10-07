## Firewall rules for puppet server node.

class cloud::firewall::puppet () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'Puppet server for www':
    ensure  => present,
    source  => $::cloud::params::ip_www,
    port    => {
      port     => '8140',
      protocol => 'tcp',
    },
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'Puppet server for elasticsearch':
    ensure  => present,
    source  => $::cloud::params::ip_elasticsearch,
    port    => {
      port     => '8140',
      protocol => 'tcp',
    },
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'Puppet server for openshift':
    ensure  => present,
    source  => $::cloud::params::ip_openshift,
    port    => {
      port     => '8140',
      protocol => 'tcp',
    },
    action  => 'accept',
    require => Service['firewalld'],
  }

  exec {'firewall-cmd --reload':
    path => '/usr/bin',
  }
}
