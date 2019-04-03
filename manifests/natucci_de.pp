class cloud::natucci_de {
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
    } ->
    file {'/etc/opt/rh/rh-haproxy18/haproxy/haproxy.cfg':
        ensure  => present,
        source  => 'puppet:///modules/cloud/haproxy.cfg',
        owner   => '0',
        mode    => '0644',
    } ->
    file {'/etc/rsyslog.conf':
        ensure  => present,
        source  => 'puppet:///modules/cloud/rsyslog.conf',
        owner   => '0',
        mode    => '0644',
    } ->
    service {'rsyslog':
        ensure => running,
        enable => true,
    } ->
    exec {'systemctl restart rsyslog':
        unless => 'ss -nltp | grep 514'
    } ->
    exec {'systemctl restart rh-haproxy18-haproxy':
        unless => "grep 'backend app' /etc/opt/rh/rh-haproxy18/haproxy/haproxy.cfg"
    }
}