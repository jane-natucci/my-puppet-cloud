node 'dns.natucci.de' {
  class {'cloud::dns':} ->
  class {'cloud::default':} ->
  class {'hdp::default':} ->
  class {'hdp::server':}
}

node 'node1.natucci.de' {
  class {'cloud::default':} ->
  class {'hdp::default':} ->
  class {'hdp::agent':}
}

node 'node2.natucci.de' {
  class {'cloud::default':} ->
  class {'hdp::default':} ->
  class {'hdp::agent':}
}

node 'node3.natucci.de' {
  class {'cloud::default':} ->
  class {'hdp::default':} ->
  class {'hdp::agent':}
}

node 'master.openshift.natucci.de' {
  class { selinux:
    mode => 'disabled',
    type => 'targeted',
  } ->
  class {'cloud::default':} ->
  class {'openshift::default':} ->
  class {'openshift::master':} ->
}

node 'node1.openshift.natucci.de' {
  class { selinux:
    mode => 'disabled',
    type => 'targeted',
  } ->
  class {'cloud::default':} ->
  class {'openshift::default':}
}

node 'ipa.natucci.de' {
  class {'cloud::default':}
}
