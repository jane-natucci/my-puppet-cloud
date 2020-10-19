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

  service {'docker':
    ensure  => 'running',
    enable  => true,
    require => [
      Package['docker']
    ]
  }
}
