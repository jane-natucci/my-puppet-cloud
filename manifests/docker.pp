## Class used to install docker and required dependencies.

class cloud::docker {
  Package {ensure => present}
  Exec {path => '/usr/bin:/usr/sbin'}

  package {'docker':}

  file {'/root/.docker':
    ensure  => directory,
    owner   => 0,
    mode    => '0644',
    require => Package['docker'],
  }

  file {'/root/.docker/config.json':
    ensure  => present,
    source  => 'puppet:///modules/cloud/config.json',
    owner   => 0,
    mode    => '0644',
    require => [
      File['/root/.docker/'],
      Package['docker'],
    ]
  }

  service {'docker':
    ensure  => 'running',
    enable  => true,
    require => [
      File['/root/.docker/config.json'],
      Package['docker']
    ]
  }
}
