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
    'docker',
    'centos-release-openshift-origin39',
    ]

  package {$dependencies:
    ensure => present,
  }

  service {'NetworkManager':
    ensure  => running,
    enable  => true,
    require => Package['NetworkManager'],
  }

  physical_volume {'/dev/sdb':
    ensure  => present,
    require => Package['docker']
  }
  -> volume_group {'docker':
    ensure           => present,
    physical_volumes => '/dev/sdb',
  }
  -> exec {'lvcreate --wipesignatures y -n thinpool docker -l 90%VG':
    path => '/usr/sbin',
  }
  -> exec {'lvcreate --wipesignatures y -n thinpoolmeta docker -l 5%VG':
    path => '/usr/sbin',
  }
  -> exec {'lvconvert -y --zero n  -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta':
    path => '/usr/sbin'
  }
  -> file {'/etc/lvm/profile/docker-thinpool.profile':
    ensure  => present,
    content => 'activation {\n thin_pool_autoextend_threshold = 75\n thin_pool_autoextend_percent = 25\n}',
    owner   => 0,
    mode    => '0644',
  }
  -> exec {'lvchange --metadataprofile docker-thinpool docker/thinpool':
    path => '/usr/sbin',
  }
  -> file {'/etc/docker/daemon.json':
    ensure => present,
    source => 'puppet:///modules/cloud/daemon.json',
    owner  => 0,
    mode   => '0644',
  }
  -> exec {'rm -rf /etc/sysconfig/docker-storage*':
    path => '/usr/bin',
  }
}
