# Configuration for openshift server.
# https://docs.okd.io/3.11/install/running_install.html#running-the-advanced-installation-rpm

class cloud::openshift {
  file {'/etc/hosts':
    ensure  => file,
    content => template('cloud/etc_hosts.erb'),
    owner   => 0,
    mode    => '0644'
  }

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
    path   => '/usr/sbin:/usr/bin',
    unless => 'lvs | grep -w thinpool',
  }
  -> exec {'lvcreate --wipesignatures y -n thinpoolmeta docker -l 5%VG':
    path   => '/usr/sbin:/usr/bin',
    unless => 'lvs -a | grep -w \'thinpoolmeta\\|thinpool_tmeta\'',
  }
  -> exec {'lvconvert -y --zero n  -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta':
    path   => '/usr/sbin:/usr/bin',
    unless => 'lvs -a | grep -w thinpool_tmeta',
  }
  -> file {'/etc/lvm/profile/docker-thinpool.profile':
    ensure  => present,
    content => "activation {\n thin_pool_autoextend_threshold = 75\n thin_pool_autoextend_percent = 25\n }",
    owner   => 0,
    mode    => '0644',
  }
  -> exec {'lvchange --metadataprofile docker-thinpool docker/thinpool':
    path   => '/usr/sbin:/usr/bin',
    unless => 'ls /root/docker-storage-configured',
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
  -> file {'/root/docker-storage-configured':
    ensure  => present,
    content => '',
    owner   => 0,
    mode    => '0644',
  }


  file {'/etc/ansible/hosts':
    ensure  => file,
    content => template('cloud/hosts.erb'),
    owner   => 0,
    mode    => '0644'
  }
  -> exec {'ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml':
    path   => '/usr/bin',
    unless => 'true',
  }

  exec { 'ssh-keygen -f /root/.ssh/id_rsa -P \'\'':
    path   => '/usr/bin',
    unless => 'ls /root/.ssh/id_rsa',
  }
  -> exec {'echo >> /root/.ssh/authorized_keys && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys':
    path   => '/usr/bin',
    unless => 'grep opneshift.natucci.de /root/.ssh/authorized_keys'
  }
  -> exec {'ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub openshift.natucci.de':
    path   => '/usr/bin',
    unless => 'grep opneshift.natucci.de /root/.ssh/authorized_keys'
  }

  # Persistent NFS storage
  file { '/exports/os-persistent-storage':
    ensure => directory,
    owner  => 'nfsnobody',
    group  => 'nfsnobody',
    mode   => '0777',
  }
  -> exec {'semanage fcontext -a -t public_content_rw_t "/exports/os-persistent-storage(/.*)?"':
    path => '/usr/sbin',
  }
  -> exec {'restorecon -R /exports/os-persistent-storage':
    path => '/usr/sbin',
  }
  -> exec {'echo "/exports/os-persistent-storage openshift.natucci.de(rw,no_root_squash)" >> /etc/exports':
    path   => '/usr/bin',
    unless => 'grep os-persistent-storage /etc/exports',
  }
  -> file { '/exports/mariadb-persistent':
    ensure => directory,
    owner  => 'nfsnobody',
    group  => 'nfsnobody',
    mode   => '0777',
  }
  -> exec {'semanage fcontext -a -t public_content_rw_t "/exports/mariadb-persistent(/.*)?"':
    path => '/usr/sbin',
  }
  -> exec {'restorecon -R /exports/mariadb-persistent':
    path => '/usr/sbin',
  }
  -> exec {'echo "/exports/mariadb-persistent openshift.natucci.de(rw,no_root_squash)" >> /etc/exports':
    path   => '/usr/bin',
    unless => 'grep mariadb-persistent /etc/exports',
  }
  -> file { '/exports/postgres-persistent':
    ensure => directory,
    owner  => 'nfsnobody',
    group  => 'nfsnobody',
    mode   => '0777',
  }
  -> exec {'semanage fcontext -a -t public_content_rw_t "/exports/postgres-persistent(/.*)?"':
    path => '/usr/sbin',
  }
  -> exec {'restorecon -R /exports/postgres-persistent':
    path => '/usr/sbin',
  }
  -> exec {'echo "/exports/postgres-persistent openshift.natucci.de(rw,no_root_squash)" >> /etc/exports':
    path   => '/usr/bin',
    unless => 'grep postgres-persistent /etc/exports',
  }
  -> exec {'exportfs -avr':
    path => '/usr/sbin',
  }
}
