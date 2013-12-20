class wozbe::profile::symfony2 (
    $dist_conf = {}
){
    class { 'apache':
        mpm_module => 'prefork',
    }

    $apache_mods = ['rewrite',]
    apache::mod { $apache_mods: }

    class {'wozbe::php5::php55': dist_conf => $dist_conf } -> apache::mod { 'php5': }
    ->
    # It looks like the puppetlabs/apache module is not fully compatible
    # with php5.5 on Debian Wheezy, so we have to manually add type for 
    # the PHP handler
    file { 'php5_type':
        content => 'AddType application/x-httpd-php .php',
        path    => '/etc/apache2/mods-enabled/php5.conf',
    }

    apache::vhost { 'project.dev':
        default_vhost => true,
        docroot       => '/vagrant/web',
        directories   => [
            {
                path           => '/vagrant/web',
                allow_override => ['All'],
                options        => ['-Indexes'],
            }
        ],
        ip_based   => true,
        add_listen => true,
        port       => 80,
    }

    apache::namevirtualhost { '*:80': }
}
