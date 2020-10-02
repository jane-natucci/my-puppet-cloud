class cloud::elasticsearch {
  file {'/etc/yum.repos.d/elasticsearch.repo':
    ensure  => present,
    source  => 'puppet:///modules/cloud/elasticsearch.repo',
    owner   => 'root',
    mode    => '0644',
  }

  exec {'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch':
    path => '/usr/bin',
  } ->
  package {'elasticsearch':
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
    ensure  => present,
  } ->
  package {'kibana':
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
    ensure  => present,
  } ->
  file {'/elasticsearch':
    ensure => directory,
    owner  => 'elasticsearch',
    mode   => '0755'
  } -> 
  file {'/elasticsearch/log':
    ensure => directory,
    owner  => 'elasticsearch',
    mode   => '0755'
  } ->
  file {'/elasticsearch/data':
    ensure => directory,
    owner  => 'elasticsearch',
    mode   => '0755'
  } ->
  file {'/etc/elasticsearch/jvm.options.d/heapsize.options':
    ensure => file,
    source => 'puppet:///modules/cloud/heapsize.options',
    owner  => 'elasticsearch',
    mode   => '0660'
  }
  file {'/etc/elasticsearch/elasticsearch.yml':
    ensure  => file,
    content => template('cloud/elasticsearch.yml.erb'),
    owner   => 'elasticsearch',
    mode    => '0660',
  } ->
  service {'elasticsearch':
    ensure => running,
    enable => true,
  }
}
