# == Class java_ng::install
#
# Setup repositories and install packages.
#
class java_ng::install {
  include ::stdlib

  $path = '/sbin:/usr/sbin:/bin:/usr/bin'

  case $::java_ng::java_repository {
    'native': {
      $java_packages = $::osfamily ? {
        /Debian/ => ["openjdk-${$::java_ng::java_version}${::java_ng::_flavor}"],
        /RedHat/ => ["java-1.${::java_ng::java_version}.0-openjdk${::java_ng::_flavor}"],
        default  => undef,
      }
    }
    /^ppa:/: {
      include ::apt

      # PPA class only on Ubuntu
      if $::osfamily == 'Debian' and $::operatingsystem == 'Ubuntu' {
        ::apt::ppa { $::java_ng::ppa_name:
          package_manage => true,
          #options => '-y',
          release        => $::lsbdistcodename,
        }

        ::Apt::Ppa[$::java_ng::ppa_name] -> Class['::apt::update']
      } else {
        $ppa_file = "/etc/apt/sources.list.d/${::java_ng::ppa_ident}-ppa-trusty.list"

        ::apt::key { "${::java_ng::ppa_ident}-ppa":
          id => $::java_ng::ppa_key,
        }

        file { $ppa_file:
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => "puppet:///modules/java_ng/ppa-${::java_ng::ppa_ident}.list",
        }

        ::Apt::Key["${::java_ng::ppa_ident}-ppa"] ->
        File[$ppa_file] ~>
        Class['::apt::update']
      }

      case $::java_ng::java_repository {
        'ppa:openjdk': {
          $java_packages = ["openjdk-${::java_ng::java_version}${::java_ng::_flavor}"]

          Class['::apt::update'] ->
          Package[$java_packages]
        }
        'ppa:oracle': {
          exec { 'repo-ppa-accept-license':
            command => "echo oracle-java${::java_ng::java_version}-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections",
            path    => $path,
            unless  => "dpkg -l oracle-java${::java_ng::java_version}-installer | grep '^\\(ii\\|hi\\)'",
          }

          $java_packages = ["oracle-java${::java_ng::java_version}-installer", "oracle-java${::java_ng::java_version}-unlimited-jce-policy"]

          Class['::apt::update'] ->
          Exec['repo-ppa-accept-license'] ->
          Package[$java_packages]
        }
        default: {
          $java_packages = []
        }
      }
    }
  }

  #debug:fail($java_packages)
  if !$::java_ng::ensure {
    ensure_packages($java_packages)
  } else {
    package{$java_packages:
      ensure => $::java_ng::ensure,
    }
  }

}
