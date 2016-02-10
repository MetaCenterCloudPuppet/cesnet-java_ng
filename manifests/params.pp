# == Class java_ng::params
#
# Parameters and default values according to platform.
#
class java_ng::params {
  case $::osfamily {
    'Debian': {
      $java_ppa_versions = [6, 7, 8, 9]
      case $::lsbdistcodename {
        'squeeze', 'lucid': {
          $java_native_versions = [6]
        }
        'wheezy', 'precise', 'trusty': {
          $java_native_versions = [6, 7]
        }
        'jessie': {
          $java_native_versions = [7]
        }
        'stretch': {
          $java_native_versions = [7, 8]
        }
        default: {
          fail("${::osfamily}/${::operatingsystem} ${::lsbdistcodename} not supported")
        }
      }
    }
    'RedHat': {
      $java_ppa_versions = []
      case $::operatingsystem {
        'Fedora': {
          $java_native_versions = [8]
        }
        default: {
          $java_native_versions = [6, 7, 8]
        }
      }
    }
    default: {
      fail("${::osfamily}/${::operatingsystem} not supported")
    }
  }

  $versions = {
    'native'   => $java_native_versions,
    'ppa'      => $java_ppa_versions,
  }
}
