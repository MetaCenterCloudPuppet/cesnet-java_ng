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
    'ppa': {
      include ::apt

      # PPA class only on Ubuntu
      if $::osfamily == 'Debian' and $::operatingsystem == 'Ubuntu' {
        ::apt::ppa { 'ppa:webupd8team/java':
          package_manage => true,
          #options => '-y',
          release        => 'trusty',
        }

        ::Apt::Ppa['ppa:webupd8team/java'] -> Class['::apt::update']
      } else {
        $ppa_file = '/etc/apt/sources.list.d/webupd8team-ppa-java.list'

        ::apt::key { 'webupd8team':
          id => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
        }

        file { $ppa_file:
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => 'puppet:///modules/java_ng/ppa.list',
        }

        ::Apt::Key['webupd8team'] ->
        File[$ppa_file] ~>
        Class['::apt::update']
      }

      exec { 'repo-ppa-accept-license':
        command => "echo oracle-java${::java_ng::java_version}-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections",
        path    => $path,
        unless  => "dpkg -l oracle-java${::java_ng::java_version}-installer | grep '^\(ii\|hi\)'",
      }

      $java_packages = ["oracle-java${::java_ng::java_version}-installer", "oracle-java${::java_ng::java_version}-unlimited-jce-policy"]

      Class['::apt::update'] ->
      Exec['repo-ppa-accept-license'] ->
      Package[$java_packages]
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
