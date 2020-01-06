node 'dns.natucci.de' {
  class {'::cloud::dns':} ->
  class {'::cloud::default':} ->
  class {'::cloud::firewall::dns':} ->
  class {'::cloud::natucci_de':}
}

node 'node1.natucci.de' {
  class {'::cloud::default':} ->
  class {'::hdp::default':} ->
  class {'::hdp::agent':} ->
  class {'::cloud::firewall::node1':}
}

node 'node2.natucci.de' {
  class {'::cloud::default':} ->
  class {'::hdp::default':} ->
  class {'::hdp::agent':} ->
  class {'::cloud::firewall::node2':}
}

node 'node3.natucci.de' {
  class {'::cloud::default':} ->
  class {'::hdp::default':} ->
  class {'::hdp::agent':} ->
  class {'::cloud::firewall::node3':}
}

node 'ipa.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::firewall::ipa':}
}

node 'jenkins.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::jenkins':} ->
  class {'::cloud::docker_config':}
}

node 'gitlab.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::gitlab':} ->
  class {'::cloud::docker_config':} ->
  class {'::cloud::firewall::gitlab':}
}

/*
node 'natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker_config':} ->
  class {'::cloud::natucci_de':}
}
*/

node 'workstation.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker_config':} ->
  class {'::cloud::workstation':}
}
