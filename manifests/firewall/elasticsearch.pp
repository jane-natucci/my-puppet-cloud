class cloud::firewall::elasticsearch () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'Port 9200 for home IP':
    ensure   => present,
    source   => "$::cloud::params::home_ip",
    port     => {
      port => '9200',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }

  # kibana
  firewalld_rich_rule {'Port 5601 for home IP':
    ensure   => present,
    source   => "$::cloud::params::home_ip",
    port     => {
      port => '5601',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }
}
