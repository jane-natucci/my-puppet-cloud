# Configuration for openshift server.
# https://docs.okd.io/3.11/install/running_install.html#running-the-advanced-installation-rpm

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
    'centos-release-openshift-origin311',
    'openshift-ansible',
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
    path   => '/usr/sbin',
    unless => 'lvs /dev/docker/thinpool',
  }
  -> exec {'lvcreate --wipesignatures y -n thinpoolmeta docker -l 5%VG':
    path   => '/usr/sbin',
    unless => 'lvs /dev/docker/thinpool',
  }
  -> exec {'lvconvert -y --zero n  -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta':
    path   => '/usr/sbin',
    unless => 'lvs /dev/docker/thinpool',
  }
  -> file {'/etc/lvm/profile/docker-thinpool.profile':
    ensure  => present,
    content => "activation {\n thin_pool_autoextend_threshold = 75\n thin_pool_autoextend_percent = 25\n }",
    owner   => 0,
    mode    => '0644',
  }
  -> exec {'lvchange --metadataprofile docker-thinpool docker/thinpool':
    path   => '/usr/sbin',
    unless => 'lvs /dev/docker/thinpool',
  }
  -> file {'/etc/docker/daemon.json':
    ensure => present,
    source => 'puppet:///modules/cloud/daemon.json',
    owner  => 0,
    mode   => '0644',
  }
  -> file {'/etc/sysconfig/docker-storage-setup':
    ensure  => present,
    content => '',
    owner   => 0,
    mode    => '0644',
  }
  -> file {'/etc/sysconfig/docker-storage':
    ensure  => present,
    content => '',
    owner   => 0,
    mode    => '0644',
  }

  file {'/etc/ansible/hosts':
    ensure => file,
    source => 'puppet:///modules/cloud/hosts',
    owner  => 0,
    mode   => '0644'
  }

  exec {'ssh-copy-id -i /root/.ssh/id_rsa.pub openshift.natucci.de':
    path   => '/usr/bin',
    unless => 'grep opneshift.natucci.de /root/.ssh/authorized_keys'
  }
}
