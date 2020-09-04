# Datadog Cluster Agent Bosh Release

This repository is a Bosh package for running the Datadog Cluster Agent on Cloud Foundry.

This package is to be used in conjunction with the [Datadog Agent Bosh Release](https://github.com/datadog/datadog-agent-boshrelease).
It provides a Bosh link (see [spec](jobs/datadog-cluster-agent/spec)) consumed by the Datadog Agent Bosh release in order to Autodiscover and schedule integrations for your apps, as well as improved tagging for application containers and processes discovery.

## Deployment
To deploy the Datadog Cluster Agent and make it discoverable by the Datadog Agent, provide a job like the following in a deploy manifest (refer to the [spec](jobs/datadog-cluster-agent/spec) for available properties):

```yaml
jobs:
- name: datadog-cluster-agent
  release: datadog-cluster-agent
  properties:
    cluster_agent:
      token: <TOKEN>  # 32 or more characters in length 
      bbs_poll_interval: 10
      warmup_duration: 5
      log_level: INFO
      bbs_ca_crt: <CA_CERTIFICATE>
      bbs_client_crt: <CLIENT_CERTIFICATE>
      bbs_client_key: <CLIENT_PRIVATE_KEY>
  provides:
    datadog-cluster-agent:
      aliases:
        - domain: <DNS_NAME (e.g. datadog-cluster-agent)>
```

**Note**: This creates a DNS alias for the Datadog Cluster Agent service, that can be used to address its VM. See [this page](https://bosh.io/docs/dns/#aliases-to-services) for more details on Bosh DNS aliases.

This DNS alias is to be specified in the [job property `cluster_agent.address`](https://bosh.io/jobs/dd-agent?source=github.com/DataDog/datadog-agent-boshrelease&version=4.0.0#p%3dcluster_agent.address) of the Datadog Agent runtime configuration, like so:

```yaml
jobs:
- name: datadog-agent
  release: datadog-agent
  properties: 
    ...
    cluster_agent:
      address: <DNS_NAME>
    ...
```

## Integration configurations discovery
The Datadog Cluster Agent discovers integrations based on an `AD_DATADOGHQ_COM` environment variable set in your applications.
This environment variable is a JSON object containing the Autodiscovery configuration templates for your application. The Datadog Cluster Agent can discover and render two types of configurations:
  1. Configurations for services bound to your application, whether they be user-provided or from a service broker.
  2. Configurations for services running inside your application, a web-server for instance.

The JSON object should be a dictionary associating a service name to its Autodiscovery template:
```
{
    "<SERVICE_NAME>": {
        "check_names": [<LIST_OF_INTEGRATION_NAMES_TO_CONFIGURE>],
        "init_configs": [<LIST_OF_INIT_CONFIGS>],
        "instances": [<LIST_OF_INSTANCES>],
        "variables": [<LIST_OF_VARIABLES_DEFINITIONS>]
    }
}
```

For services bound to the application, the `<SERVICE_NAME>` should be the name of the service as it appears in the `cf services` command output, for services running inside the application, it can be anything.  
The `variables` key is used only for bound services to resolve template variables inside the configuration template. They should contain the JSON path of the value you want in the `VCAP_SERVICES` environment variable that you can inspect with `cf env <APPLICATION_NAME>`.

**Note:** The Datadog Cluster Agent is currently not able to resolve credentials of services using CredHub to store them. Only credentials directly available in the `VCAP_SERVICES` environment variable can be used with Autodiscovery.

### Example

For example, for a Cloud Foundry application running a web server bound to a PostgreSQL service, you could have the following Autodiscovery configuration in the `AD_DATADOGHQ_COM` environment variable:

```
AD_DATADOGHQ_COM: '{
    "web_server": {
        "check_names": ["http_check"],
        "init_configs": [{}],
        "instances": [
            {
                "name": "My Nginx",
                "url": "http://%%host%%:%%port_p8080%%",
                "timeout": 1
            }
        ]
    }
    "postgres-service-name": {
        "check_names": ["postgres"],
        "init_configs": [{}],
        "instances": [
            {
                "host": "%%host%%",
                "port": 5432,
                "username": "%%username%%",
                "dbname": "%%dbname%%",
                "password": "%%password%%"
            }
        ],
        "variables": {
            "host": "$.credentials.host",
            "username": "$.credentials.Username",
            "password": "$.credentials.Password",
            "dbname": "$.credentials.database_name"
        }
    }
}'
```

Given the following `VCAP_SERVICES` environment variable:
```
VCAP_SERVICES: '{
    "my-postgres-service": [
        {
            "credentials": {
                Password: "1234",
                Username: "User1234",
                host: "postgres.example.com",
                database_name: "my_db",
            },
            "name": "postgres-service-name",
        }
    ]
}'
```

In the above example, the first item `web_server` is a configuration for a service running inside the application.
There are no `variables`, and it uses the usual template variables `%%host%%` and `%%port%%` available with regular Autodiscovery.

The second item `postgres-service-name` is a configuration for a service bound to the application.
To resolve the template variables, it uses the `variables` dictionary to define the template variables used in the instance configuration.
This dictionary contains a JSONPath object indicating where to find the actual variable value in the service `postgres-service-name` defined in the `VCAP_SERVICES` environment variable.

## Improved tagging for application containers and processes discovery

The Datadog Cluster Agent automatically provides a tagger used by the Datadog Agent when discovering Cloud Foundry application containers without additional configuration, as soon as the two releases are linked as described in the [Deployment](#Deployment) section.
