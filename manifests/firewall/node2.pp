class cloud::firewall::node2 () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'SSH':
    ensure  => present,
    service => 'ssh',
  }

  firewalld_rich_rule {'ResourceManager':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8050',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'ResourceManager Admin':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8141',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'ResourceManager ResourceTracker':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8025',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'ResourceManager Scheduler':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8030',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'ResourceManager WebApp':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8088',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'NodeManager 45454':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '45454',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'NodeManager 8042':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8042',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'Spark HistoryServer':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '18080',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'YARN AppTimelineServer':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8188',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'NameNode UI':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '50070',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'accept everything from node1':
    ensure  => present,
    source  => "${::cloud::params::ip_node1}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from node3':
    ensure  => present,
    source  => "${::cloud::params::ip_node3}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from dns':
    ensure  => present,
    source  => "${::cloud::params::ip_dns}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from ipa':
    ensure  => present,
    source  => "${::cloud::params::ip_ipa}",
    action  => 'accept',
  }
}
