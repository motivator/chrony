# chrony
#
# Main class for chrony module, includes all other classes.
#
# @param client_allow [Boolean] Whether to allow clients to connect. Default value: false.
# @param client_sources [Optional Array[String]] The sources (networks or hostnames) from which clients will be allowed to connect. Default value: undef.
# @param config [Stdlib::Absolutepath] The path to the config file. Default value: varies by OS.
# @param config_file_mode [String] The mode to set on the config file. Default value: 0664.
# @param driftfile [Stdlib::Absolutepath] The path to the drift file to use. Default value: /var/lib/chrony/drift.
# @param keyfile [Stdlib::Absolutepath] Path to the keyfile used by chrony. Default value: varies by OS.
# @param package_ensure [String] What state to ensure the package is in. Values: 'present', 'latest', or a specific version. Default value: present.
# @param package_manage [Boolean] Whether or not Puppet should manage the state of the chrony package. Default value: true.
# @param package_name [String] What name to use for the chrony package. Default value: chrony.
# @param pool_use [Boolean] Whether or not to use a pool as the source to synchronize from. Default value: true.
# @param pool_address [String] What address to use for the server pool. Default value: pool.ntp.org.
# @param pool_maxservers [Integer[1]] How many servers to grab from the pool. Default value: 4.
# @param pool_iburst [Boolean] Whether or not to set the iburst option on the pool. Default value: true.
# @param servers [Array[String]] Array of servers to set as sources. Used only if pool_use is false. Default value: empty array.
# @param service_enable [Boolean] Whether or not the service should be set to run on startup. Default value: true.
# @param service_ensure [String] What state to ensure the service is in. Default value: running.
# @param service_manage [Boolean] Whether to manage the chrony service. Default value: true.
# @param service_name [String] The name of chrony's service. Default value: varies by OS.
class chrony (
  $client_allow     = false,
  $client_sources   = [],
  $config           = '/etc/chrony/chrony.conf',
  $config_file_mode = '0664',
  $driftfile        = '/var/lib/chrony/drift',
  $keyfile          = '/etc/chrony/chrony.keys',
  $package_ensure   = 'present',
  $package_manage   = true,
  $package_name     = 'chrony',
  $pool_use         = false,
  $pool_address     = 'pool.ntp.org',
  $pool_maxservers  = 4,
  $pool_iburst      = true,
  $servers          = ['0.debian.pool.ntp.org',
                       '1.debian.pool.ntp.org',
                       '2.debian.pool.ntp.org',
                       '3.debian.pool.ntp.org'],
  $service_enable   = true,
  $service_ensure   = 'running',
  $service_manage   = true,
  $service_name     = '',
) {
  validate_bool($client_allow)
  validate_array($client_sources)
  validate_absolute_path($config)
  validate_absolute_path($driftfile)
  validate_absolute_path($keyfile)
  validate_bool($package_manage)
  validate_bool($pool_use)
  validate_integer($pool_maxservers)
  validate_bool($pool_iburst)
  validate_array($servers)
  validate_bool($service_enable)
  validate_bool($service_manage)

  contain chrony::install
  contain chrony::config
  contain chrony::service

  Class['chrony::install'] -> Class['chrony::config'] ~> Class['chrony::service']
}
