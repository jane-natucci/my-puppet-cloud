class cloud::firewall::ipa () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'freeipa':
    ensure  => present,
    service => 'freeipa-ldap',
    require => Service['firewalld'],
  }
}
