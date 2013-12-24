class wozbe::git {
    package { "git":
        ensure => latest,
        require  => Class["apt::update"],
    }
}
