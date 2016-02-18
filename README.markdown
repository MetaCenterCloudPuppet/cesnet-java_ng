## Java Headless Puppet Module - java\_ng

[![Build Status](https://travis-ci.org/MetaCenterCloudPuppet/cesnet-java_ng.svg?branch=master)](https://travis-ci.org/MetaCenterCloudPuppet/cesnet-java\_ng)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with java\_ng](#setup)
    * [What java\_ng affects](#what-java_ng-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Functions](#functions)
    * [Module Parameters (java\_ng class)](#class-java_ng)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

This puppet module performs more parametrized Java installation. Various options may be specified:

* major version: **7**, **8**
* flavor: **headless**, **jdk**, **jre**
* repositories: **native**, **ppa:openjdk**, **ppa:oracle**

By default the headless flavor is installed, default version depends on the platform (8 or 7), and native repository is preferred.

## Setup

### What java\_ng affects

* Packages: Java (JRE/JDK, JCE policy)
* Files:
 * ppa repository if enabled and needed (Debian, Ubuntu) + apt keys

No changes to the alternatives are done (only a switching in the package triggers).

## Usage

**Example: basic usage**

    include ::java_ng

**Example: specify version and flavor**

    class { '::java_ng':
      flavor  => 'jdk',
      version => 8,
    }

**Example: lock the package version (Debian, Ubuntu)**

    class { '::java_ng':
      ensure  => 'held',
      version => 8,
    }

**Example: Oracle Java (by selecting the PPA repository instead of preferred native OS repository)**

    class { '::java_ng':
      repo    => 'ppa:oracle',
      version => 8,
    }

## Reference

### Classes

* [**`java_ng`**](#class-java_ng): Install Java
* `java_ng::install`: Setup repositories and install packages
* `java_ng::params`: Parameters and default values according to platform

<a name="class-java_ng"></a>
### `java_ng` class

#### Parameters

#####`ensure`

*ensure* parameter for the Java packages. Default: undef.

Set to **held**, if the Java version is held in Debian or Ubuntu.

#####`flavor`

Java flavor. Default: 'headless'.

Values:

* **headless**
* **jdk**
* **jre**

#####`version`

Java major version. Default: [8, 7].

It may be array or single value.

#####`repo`

Repository to use. Default: ['native', 'ppa:openjdk', 'ppa:oracle'].

It may be array or single value.

Values:

* **native**: native OS repository (mostly with OpenJDK Java)
* **ppa:openjdk**: openjdk-r Ubuntu PPA repository (with the OpenJDK Java)
* **ppa:oracle**: webupd8 Ubuntu PPA repository (with the Oracle Java)

#####`prefer_version`

Sets the heuristic to prefer Java version over the repository. Default: false.

It is used only when more Java versions and repositories are specified.

When *true*: the first specified version is used, if available in any repository.

When *false*: the repositories ordering is considered first (by default the native OS is the first).

### Functions

* `java_ng_avail`: Scans available Java versions and return matching version and repository

## Limitations

PPA repository is permitted also on Debian, there is always used the Ubuntu 14/trusty version.

Alternatives are not touched.

## Development

* Repository: [https://github.com/MetaCenterCloudPuppet/cesnet-java\_ng](https://github.com/MetaCenterCloudPuppet/cesnet-java_ng)
* Tests:
 * basic: see *.travis.yml*
* Email: František Dvořák &lt;valtri@civ.zcu.cz&gt;
