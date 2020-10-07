# Configuration for openshift server.

class cloud::openshift {
  package {'NetworkManager':
    ensure => present,
  }

  service {'NetworkManager':
    ensure  => running,
    enable  => true,
    require => Package['NetworkManager'],
  }
}
