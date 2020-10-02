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
  }
  
  file {'/elasticsearch':
    ensure => directory,
    owner  => 'elasticsearch',
    mode   => '0755'
  }
  
  file {'/elasticsearch/log':
    ensure => directory,
    owner  => 'elasticsearch',
    mode   => '0755',
    require => File['/elasticsearch'],
  }

  file {'/elasticsearch/data':
    ensure => directory,
    owner  => 'elasticsearch',
    mode   => '0755',
    require => File['/elasticsearch'],
  }

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
    require => File['/elasticsearch/log'],
    require => File['/elasticsearch/data'],
  }

  service {'elasticsearch':
    ensure => running,
    enable => true,
    require => File['/etc/elasticsearch/elasticsearch.yml'],
    require => File['/etc/elasticsearch/jvm.options.d/heapsize.options'],
    require => Package['elasticsearch'],
  }
  
  package {'kibana':
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
    ensure  => present,
  }

  file {'/etc/elasticsearch/kibana.yml':
    ensure  => file,
    content => template('cloud/kibana.yml.erb'),
    owner   => 'kibana',
    mode    => '0660',
    require => Package['kibana'],
  }
  
  service {'kibana':
    ensure => running,
    enable => true,
    require => Package['kibana'],
    require => File['/etc/elasticsearch/kibana.yml'],
  }
}
