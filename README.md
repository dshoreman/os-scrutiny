# Scrutiny Collector plugin for OPNsense

The `os-scrutiny` plugin provides the collector component of Scrutiny along
with a `configd` action to run in Cron, configurable via the OPNsense GUI.

## Plugin Development

Dev/testing is best done on a separate system or test VM, especially if your
FreeBSD version is different from the one supported by opnsense/tools.

### Prerequisites

The [OPNsense tools][1] provide required Make plugins and also pulls in ports.

```sh
pkg install git; git clone https://github.com/opnsense/tools /usr/tools

cd /usr/tools && make update
```

### Building the Plugin

```sh
cd /usr/plugins/devel
git clone https://github.com/dshoreman/os-scrutiny scrutiny

cd /usr/plugins/sysutils/scrutiny
make package
```

#### Installing the Package

Once the package has been built it will be placed in the **work/pkg** dir.

Install with `pkg add work/pkg/os-scrutiny-devel.pkg`.

[1]: https://github.com/opnsense/tools
