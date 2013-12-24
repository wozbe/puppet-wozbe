class wozbe::git {
    package { "git":
        ensure => latest,
        require  => Exec['apt-get update'],
    }
}
