node 'www.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker_config':} ->
  class {'::cloud::natucci_de':}
}

/*

node 'dns.natucci.de' {
  class {'::cloud::dns':} ->
  class {'::cloud::default':} ->
  class {'::cloud::firewall::dns':} ->
  class {'::cloud::natucci_de':} ->
  class {'::cloud::jenkins':} ->
  class {'::cloud::docker_config':}
}

node 'jenkins.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::jenkins':} ->
  class {'::cloud::docker_config':}
}

*/
