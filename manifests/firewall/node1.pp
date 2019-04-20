class cloud::firewall::node1 () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'SSH':
    ensure  => present,
    service => 'ssh',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'NodeManager 45454':
    ensure   => present,
    source   => "$::cloud::params::ip_vpn",
    port     => {
      port => '45454',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'NodeManager 8042':
    ensure   => present,
    source   => "$::cloud::params::ip_vpn",
    port     => {
      port => '8042',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'Zeppelin Notebook 9995':
    ensure   => present,
    source   => "$::cloud::params::ip_vpn",
    port     => {
      port => '9995',
      protocol => 'tcp',
    },
    action   => 'accept',
    require  => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from node2':
    ensure  => present,
    source  => "${::cloud::params::ip_node2}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from node3':
    ensure  => present,
    source  => "${::cloud::params::ip_node3}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from dns':
    ensure  => present,
    source  => "${::cloud::params::ip_dns}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from ipa':
    ensure  => present,
    source  => "${::cloud::params::ip_ipa}",
    action  => 'accept',
    require => Service['firewalld'],
  }
}
