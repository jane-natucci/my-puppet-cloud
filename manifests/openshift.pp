# Configuration for openshift server.

class cloud::openshift {
  $dependencies = [
    'NetworkManager',
    'iptables-services',
    'bridge-utils',
    'kexec-tools',
    'sos',
    'psacct',
    'python-ipaddress',
    'centos-release-openshift-origin',
    ]

  package {$dependencies:
    ensure => present,
  }

  service {'NetworkManager':
    ensure  => running,
    enable  => true,
    require => Package['NetworkManager'],
  }
}
