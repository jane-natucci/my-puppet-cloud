class cloud::jenkins {
    Exec {path => '/usr/bin'}

    Package {ensure => present}

    package {'centos-release-scl':
        ensure => present,
    } ->
    package {'rh-haproxy18':
        ensure => present,
    } ->
    exec {'scl enable rh-haproxy18 bash':
    } ->
    service {'rh-haproxy18-haproxy':
        ensure => running,
        enable => true,
    }

    file {'/etc/opt/rh/rh-haproxy18/haproxy/haproxy.cfg':
        ensure  => present,
        source  => 'puppet:///modules/cloud/haproxy.cfg',
        owner   => '0',
        mode    => '0644',
  }
}