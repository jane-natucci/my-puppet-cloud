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

node 'ipa.natucci.de' {
  class {'cloud::default':}
}

node 'jenkins.natucci.de' {
  class {'cloud::default':} ->
  class {'cloud::jenkins':} ->
  class {'cloud::docker_config':}
}

node 'gitlab.natucci.de' {
  class {'cloud::default':} ->
  class {'cloud::gitlab':} ->
  class {'cloud::docker_config':}
}

node 'natucci.de' {
  class {'cloud::default':} ->
  class {'cloud::docker_config':} ->
  class {'cloud::natucci_de':} ->
}
