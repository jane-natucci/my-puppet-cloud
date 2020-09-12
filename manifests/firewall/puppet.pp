class cloud::firewall::puppet () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'Puppet server for www':
    ensure   => present,
    source   => "$::cloud::params::ip_www",
    port     => {
      port => '8140',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'Puppet server for elastic':
    ensure   => present,
    source   => "$::cloud::params::ip_elastic",
    port     => {
      port => '8140',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }
}
