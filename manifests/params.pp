# == Class java_ng::params
#
# Parameters and default values according to platform.
#
class java_ng::params {
  case $::osfamily {
    'Debian': {
      $java_ppa_oracle_versions = [6, 7, 8, 9]

      $java_ppa_openjdk_versions = $::lsbdistcodename ? {
        /squeeze|wheezy/ => [6, 7],
        default => [6, 7, 8],
      }

      $java_native_versions = $::lsbdistcodename ? {
        /squeeze|lucid/ => [6],
        /wheezy|precise|trusty/ => [6, 7],
        /jessie/ => [7],
        /stretch/ => [7, 8],
        /buster|xenial/ => [8, 9],
        default => [],
      }

      if !java_native_versions {
        fail("${::osfamily}/${::operatingsystem} ${::lsbdistcodename} not supported")
      }
    }
    'RedHat': {
      $java_ppa_oracle_versions = []
      $java_ppa_openjdk_versions = []
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
    'native'      => $java_native_versions,
    'ppa:openjdk' => $java_ppa_openjdk_versions,
    'ppa:oracle'  => $java_ppa_oracle_versions,
  }
}
