# Puppet module for OpenJDK 9, 10, 11 installation
[![Build Status](https://travis-ci.org/Adaptavist/puppet-adopt_openjdk.svg?branch=master)](https://travis-ci.org/Adaptavist/puppet-adopt_openjdk)

* Allows installation of multiple versions of OpenJDK 
* Can specify default Java version (defaults to the first version installed)

# Examples

```
class { 'adopt_openjdk':
  versions => [9, 11]
}

class { 'adopt_openjdk':
  versions    => [10, 11, 9],
  default_ver => 10
}
```
