# = Class java
#
# Install Java.
#
class java_ng(
  $ensure = undef,
  $flavor = 'headless',
  $prefer_version = false,
  $repo = ['native', 'ppa'],
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
ppa: [',
      join($::java_ng::versions['ppa'], ', '),
      ']')
  }

  notice("Selected repository: ${java_repository}, selected Java ${java_version}")

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
