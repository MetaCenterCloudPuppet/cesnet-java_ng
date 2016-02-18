# = Class java
#
# Install Java.
#
class java_ng(
  $ensure = undef,
  $flavor = 'headless',
  $prefer_version = false,
  $repo = ['native', 'ppa:openjdk', 'ppa:oracle'],
  $version = [8, 7],
) inherits ::java_ng::params {
  include ::stdlib

  $path = '/sbin:/usr/sbin:/bin:/usr/bin'

  $java_selected = java_ng_avail($version, $repo, $prefer_version, $::java_ng::versions)
  $java_version = $java_selected['version']
  $java_repository = $java_selected['repo']

  if !$java_repository {
    fail(
      'No requested Java versions found, available versions:
native: [',
      join($::java_ng::versions['native'], ', '),
      ']
ppa:openjdk: [',
      join($::java_ng::versions['ppa:openjdk'], ', '),
      ']
ppa:oracle: [',
      join($::java_ng::versions['ppa:oracle'], ', '),
      ']')
  }

  notice("Selected repository: ${java_repository}, selected version: ${java_version}")

  case $java_repository {
    'native': {
    }
    'ppa:openjdk': {
      $ppa_ident = 'openjdk-r'
      $ppa_key = 'DA1A4A13543B466853BAF164EB9B1D8886F44E2A'
      $ppa_name = 'ppa:openjdk-r/ppa'
    }
    'ppa:oracle': {
      $ppa_ident = 'webupd8team'
      $ppa_key = '7B2C3B0889BF5709A105D03AC2518248EEA14886'
      $ppa_name = 'ppa:webupd8team/java'
    }
    default: {
      fail('Unknown repository')
    }
  }

  $_flavor = "${::osfamily}-${flavor}" ? {
    /RedHat-headless/ => '-headless',
    /RedHat-jdk/      => '-devel',
    /RedHat-jre/      => '',
    /Debian-headless/ => '-jre-headless',
    /Debian-jdk/      => '-jdk',
    /Debian-jre/      => '-jre',
    default           => '',
  }

  class { '::java_ng::install': } ->
  Class['::java_ng']
}
