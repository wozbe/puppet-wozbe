class wozbe::php5::php55 (
    $dist_conf = {}
){
    apt::source { 'php55_dotdeb':
        location          => 'http://packages.dotdeb.org',
        release           => 'wheezy-php55',
        repos             => 'all',
        required_packages => 'debian-keyring debian-archive-keyring',
        key               => '89DF5277',
        key_server        => 'keys.gnupg.net',
        include_src       => true,
    }

    package { 'php5':
        ensure  => installed,
        require => Apt::Source['php55_dotdeb'],
    }

    $extensions = ['php5-intl', 'php5-mysql', 'php5-mcrypt', 'php5-curl', 'php5-cli', 'php5-gd', 'php5-xdebug']
    package { $extensions:
        ensure  => installed,
        require => Package['php5']
    }

    file { 'dist-cli.ini':
        path    => '/etc/php5/cli/conf.d/99-dist.ini',
        ensure  => present,
        content => template('wozbe/php5/dist.ini.erb'),
        require => Package['php5'],
    }

    file { 'dist-apache.ini':
        path    => '/etc/php5/apache2/conf.d/99-dist.ini',
        ensure  => present,
        content => template('wozbe/php5/dist.ini.erb'),
        require => Package['php5'],
    }
}
