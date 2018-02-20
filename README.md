# tomcat-cli
Tomcat CLI

This is shell script for sending commands to Tomcat manager using URI requests.

# Usage
```bash
Usage: ./tomcat-cli.sh [OPTION]... command [ARG]
Executes command in tomcat instance.

Options:
  --port port       port on which the tomcat manager is running
  --host hostname   hostname of the tomcat instance
  ih --help         Show this help

Commands:
  list        List Currently Deployed Applications
  info        List OS and JVM Properties
  vminfo      VM Info
  resources   List Available Global JNDI Resources
  sessions    Session Statistics. Compulsory argument of webapp path, e.g. /manager
  expire      Expire Sessions. Compulsory argument of webapp path. Optional secondary argument number of minutes to expire sessions that are idle for longer than num minutes
  threaddump  Thread Dump
```

# Examples
## list applications
./tomcat-cli --host localhost --port 8080 list

## expire all sessions for webapp /manager
./tomcat-cli.sh --host hostname --port 8080 expire /manager 0

# Defaults
Script looks in current directory and then in user's home directory for file ```.tomcat-cli``` which can specify the hostname, port, username, password. One can use the template with default values, uncomment and copy into the user home directory.

# Tomcat configuring
In order to support tomcat cli, some configuration is needed in tomcat-users.xml etc.: See https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html

