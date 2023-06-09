# -*- coding: utf-8 -*-
# vim: ft=yaml
---
tomcat:
  # The Tomcat version can be overridden like so.
  # ver: 9
  security: 'no'
  # The Java home directory can be overridden like so.
  # java_home: '/usr/lib/jvm/default-java'

  # Any parameter you may pass to the java app, you can pass it here,
  # without the preceding dash. The template builds the correct JAVA_OPTS
  # line, adding the dash.
  # Java's parameter don't follow a pattern (that I can see), so I think it's
  # the best way to build the string of opts.
  java_opts:
    - 'Djava.awt.headless=true'
    - 'Xmx128m'
    - 'XX:MaxPermSize=256m'
    # Change paths to correct locations
    - 'Dlog4j.configuration=file:/tmp/log4j.properties'
    - 'Dlogback.configurationFile=/tmp/logback.xml'
  jsp_compiler: javac
  logfile_days: 14
  logfile_compress: 1
  authbind: 'no'
  # expires_when: '2 weeks'
  conf_dir: /etc/tomcat9
  main_config: /etc/sysconfig/tomcat9
  catalina_base: /usr/share/tomcat9
  catalina_home: /usr/share/tomcat9
  catalina_pid: /var/run/tomcat9.pid
  # Used by generic 'tomcat-default-CentOS.template'
  catalina_tmpdir: /var/cache/tomcat9/temp

  # important: false for Travis CI and maybe MacOS
  service_running: false

  limit:
    soft: 64000
    hard: 64000
  connectors:
    example_connector:
      port: 8080
      protocol: 'HTTP/1.1'
      connectionTimeout: 20000
      # URIEncoding: 'UTF-8'
      # redirectPort: 8443
      # maxHttpHeaderSize: 8192
      # maxThreads: 150
      # minSpareThreads: 25
      # enableLookups: 'false'
      # disableUploadTimeout: 'false'
      # acceptCount: 100
      # scheme: https
      # secure: 'false'
      # clientAuth: 'false'
      # sslProtocol: TLS
      # SSLEnabled: 'false'
      # # Change to realpath before setting "SSLEnabled: 'true'"
      # keystoreFile: '/path/to/keystoreFile'
      # keystorePass: 'somerandomtext'
  sites:
    # unique; used as salt ID and in template as `host_name` if
    # `name` is not declared
    # example.com:
    #   # for "Host name=" in server.xml. If not declared ID declaration will be used
    #   name: 'tomcat-server'
    #   appBase: ../webapps/myapp
    #   path: ''
    #   docBase: ../webapps/myapp
    #   alias: www.example.com
    #   host_parameters:
    #     unpackWARs: "true"
    #     autoDeploy: "true"
    #     deployXML: "false"
    #   reloadable: "true"
    #   debug: 0
    # example.net:
    #   appBase: ../webapps/myapp2
    #   path: ''
    #   docBase: ../webapps/myapp2
    #   alias: www.example.net
    #   host_parameters:
    #     unpackWARs: "true"
    #     autoDeploy: "true"
    #   reloadable: "true"
    #   debug: 0
    #   valves:
    #     - className: org.apache.catalina.valves.AccessLogValve
    #       directory: logs
    #       prefix: localhost_access_log.
    #       fileDateFormat: yyyy-MM-dd-HH
    #       suffix: .log
    #       pattern: >-
    #         %h %l %u %t &quot;%m http://%v%U %H&quot; %s %b
    #         &quot;%{Referer}i&quot; &quot;%{User-Agent}i&quot; %D
    #     - className: org.apache.catalina.authenticator.SingleSignOn
  manager:
    # This now supports multiple user acccounts and variable roles.
    roles:
      - manager-gui
      - manager-script
      - manager-jmx
      - manager-status
    users:
      saltuser1:
        passwd: RfgpE2iQwD
        roles: manager-gui,manager-script,manager-jmx,manager-status
      saltuser2:
        passwd: RfgpE2iQwD
        # Alternatively, roles can also be a list
        roles:
          - manager-gui
          - manager-script
          - manager-jmx
          - manager-status
  context:
    # Let's you define multiple elements in the global context.xml file.
    # The state does not try to be clever about the correctness of what you add here,
    # just iterates over the dictionary of <Elements_types> and generates entries
    # in the file. Ie, the lines below will generate:
    #
    # <Environment
    #     name="env.first"
    #     value="first.text"
    #     type="java.lang.String"
    #     override="true"
    # />
    # <Environment
    #     name="env.second"
    #     value="second.value"
    #     type="some.other.type"
    #     override="false"
    # />
    # <Listener
    #     className="org.apache.catalina.security.SecurityListener"
    # />
    # <Listener
    #     className="org.apache.catalina.core.AprLifecycleListener"
    #     SSLEngine="on"
    # />
    # <Resource
    #     name="jdbc/__postgres"
    #     auth="Container"
    #     type="javax.sql.DataSource"
    #     driverClassName="org.postgresql.Driver"
    #     url="jdbc:postgresql://db.server/dbname"
    #     username="dbuser"
    #     password="aycaramba!"
    #     maxActive="20"
    #     maxIdle="10"
    #     maxWait="-1"
    # />
    # <ResourceLink
    #     name="linkToGlobalResource"
    #     global="simpleValue"
    #     type="java.lang.Integer"
    # />

    Environment:
      env.first:
        name: env.first
        value: first.text
        type: java.lang.String
        override: true
      env.second:
        name: env.second
        value: second.value
        type: some.other.type
        override: false
    Listener:
      first:
        className: org.apache.catalina.security.SecurityListener
      second:
        className: org.apache.catalina.core.AprLifecycleListener
        SSLEngine: 'on'
    Resource:
      jdbc:
        name: jdbc/__postgres
        auth: Container
        type: javax.sql.DataSource
        driverClassName: org.postgresql.Driver
        url: jdbc:postgresql://db.server/dbname
        user: dbuser
        password: aycaramba!
        maxActive: 20
        maxIdle: 10
        maxWait: -1
    ResourceLink:
      any_name_here_will_be_ignored:
        name: linkToGlobalResource
        global: simpleValue
        type: java.lang.Integer
  other_contexts:
    # will be available at 'tomcat.conf_dir/Catalina/localhost/context'
    'other-contexts':
      # parameters to the context itself.
      params:
        docBase: /path/to/webapp
        debug: 1
        reloadable: 'true'
        crossContext: 'true'
      # elements take the same form as the default 'context' section above.
      elements:
        Resource:
          jdbc:
            name: jdbc/__postgres
            auth: Container
            type: javax.sql.DataSource
            driverClassName: org.postgresql.Driver
            url: jdbc:postgresql://db.server/dbname
            user: dbuser
            password: aycaramba!
            maxActive: 20
            maxIdle: 10
            maxWait: -1

        Resources:
          PostResources:
            className: org.apache.catalina.webresources.DirResourceSet
            base: "/var/lib/tomcat9/appconfig"
            webAppMount: "/WEB-INF/classes"
