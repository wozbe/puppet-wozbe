class wozbe::profile::common {
    include wozbe::git

    # Sudo
    package { 'sudo': }

    ## Allow SSH forwarding through sudo
    file_line { '/etc/sudoers':
        line => 'Defaults    env_keep+=SSH_AUTH_SOCK',
        path => '/etc/sudoers',
        require => Package['sudo'],
    }

    # Timezone reconfiguration
    $timezoneFile = '/usr/share/zoneinfo/Europe/Paris'
    $timezone     = 'Europe/Paris'

    package { 'tzdata':
        ensure => present,
    }

    file { '/etc/localtime':
        require => Package['tzdata'],
        ensure  => link,
        target => $timezoneFile,
    }

    file { '/etc/timezone':
        ensure  => present,
        require => Package['tzdata'],
        content => "$timezone\n",
    }

    exec { 'reconfigure-tzdata':
        command     => '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata',
        subscribe   => [File['/etc/timezone'], File['/etc/timezone']],
        require     => File['/etc/timezone'],
        refreshonly => true,
    }

    # ntp
    class { '::ntp':
        require => Exec['reconfigure-tzdata'],
    }

    # Miscellaneous
    $commonPackages = ['curl', 'htop', 'acl', 'vim-nox', 'fail2ban']

    package { $commonPackages:
        ensure => present,
    }
}
