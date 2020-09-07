class cloud::www {
    Exec {path => '/usr/bin:/usr/sbin'}

    Package {ensure => present}

    package {'centos-release-scl':
        ensure => present,
    } ->
    package {'rh-haproxy18':
        ensure => present,
    } ->
    exec {'/usr/bin/scl enable rh-haproxy18 bash':
        unless => '/usr/bin/scl -l | grep rh-haproxy18',
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
