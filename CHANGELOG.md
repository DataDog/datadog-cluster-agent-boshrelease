# Changelog

## 2.13.0 / 2025-10-14

* [Added] Bump Datadog Cluster Agent to version 7.70.2. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7702--6702).
* [Changed] Update the cloudfoundry-bbs listener name for Cluster Agent 7.70. See [#73](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/73).

## 2.12.0 / 2025-04-22

* [Added] Bump Datadog Cluster Agent to version 7.64.2. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG-DCA.rst#7642).
* [Fixed] Fix clusterchecks dispatching in the Cluster Agent. See [#69](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/69).

## 2.11.0 / 2024-12-11

* [Added] Bump Datadog Cluster Agent to version 7.59.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG-DCA.rst#7591).

## 2.10.0 / 2024-10-21

* [Added] Bump Datadog Cluster Agent to version 7.57.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7570).

## 2.9.0 / 2024-05-29

* [Added] Bump Datadog Cluster Agent to version 7.53.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7530--6530).

## 2.8.0 / 2024-01-30

* [Added] Bump Datadog Cluster Agent to version 7.50.3. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7503--6503).

## 2.7.1 / 2023-11-14

Fix the embedded Datadog Cluster Agent version to 7.48.0.

## 2.7.0 / 2023-11-13

* [Added] Bump Datadog Cluster Agent to version 7.48.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7480--6480).

## 2.6.0 / 2023-07-13

* [Added] Bump Datadog Cluster Agent to version 7.46.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7460--6460).
_Contains a fix for a file descriptor leak. See https://github.com/DataDog/datadog-agent/pull/16922._
* [Changed] Make `api_key` property optional. See [#52](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/52).

## 2.5.1 / 2023-01-13

* Fix the embedded Datadog Cluster Agent version to 7.41.1.

## 2.5.0 / 2023-01-06

* [Added] Bump Datadog Cluster Agent to version to 7.41.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7411--6411).

## 2.4.0 / 2022-11-14

* [Added] Bump Datadog Cluster Agent to version 7.40.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7401--6401).
* [Added] Add `api_key` property to support the flare command. See [#45](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/45).
* [Added] Add `refresh_on_cache_miss`, `sidecars_tags`, and `isolation_segments_tags` properties. See [#44](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/44).

## 2.3.0 / 2022-08-03

* [Added] Bump Datadog Cluster Agent to version 7.37.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7371--6371).

## 2.2.1 / 2022-07-11

* [Added] Add option to enable advanced tagging. See [#39](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/39).

## 2.2.0 / 2022-06-09

* [Added] Bump Datadog Cluster Agent to version 7.36.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7361--6361).

## 2.1.1 / 2022-04-25

* [Added] Add option to serve nozzle data to reduce the load on the CAPI. See [#34](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/34).

## 2.1.0 / 2022-04-13

* [Added] Bump Datadog Cluster Agent to version 7.35.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7351--6351).

## 2.0.0 / 2022-02-07

* [Added] Bump Datadog Cluster Agent to version 7.33.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7330--6330).

## 1.9.3 / 2021-12-22

* [Added] Bump Datadog Cluster Agent to version 7.32.4. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7324--6324).

## 1.9.2 / 2021-12-20

* [Added] Bump Datadog Cluster Agent to version 7.32.3. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7323--6323).

## 1.9.1 / 2021-12-13

* [Added] Bump Datadog Cluster Agent to version 7.32.2. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7322--6322).

## 1.9.0 / 2021-11-24

* [Added] Bump Datadog Cluster Agent to version 7.32.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7321--6321).

## 1.8.0 / 2021-09-20

* [Added] Bump Datadog Cluster Agent to version 7.31.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7310--6310).

## 1.7.0 / 2021-08-16

* [Added] Add option to force use of TLS 1.2. See [#22](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/22).
* [Added] Add configuration option for CC API list app endpoint batch size. See [#21](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/21).
* [Added] Add property to specify ulimit for number of open file descriptors. See [#20](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/20).
* [Added] Bump Datadog Cluster Agent to version 7.30.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7300--6300).

## 1.6.0 / 2021-04-20

* [Added] Add option to poll Cloud Foundry API for more advanced container tagging. See [#18](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/18).
* [Added] Add option to send application environment variables as custom container tags. See [#16](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/16).

## 1.5.0 / 2021-01-21

* [Added] Bump Datadog Cluster Agent to version 7.25.0.

## 1.4.0 / 2020-12-14

* [Added] Bump Datadog Cluster Agent to version 7.24.0.

## 1.3.0 / 2020-10-13

* [Added] Bump Datadog Cluster Agent to version 7.23.0. It adds space and org names and IDs as tags to autodiscovered checks and containers.

## 1.2.0 / 2020-08-31

* [Added] Bump Datadog Cluster Agent to version 7.22.0.

## 1.1.0 / 2020-07-24

* [Added] Add ability to configure the Cloud Foundry API check as a cluster check. See [#8](https://github.com/DataDog/datadog-cluster-agent-boshrelease/pull/8).
* [Added] Bump Datadog Cluster Agent to version 7.21.1.

## 1.0.0 / 2020-06-12

* [Added] Initial release of the Datadog Cluster Agent Bosh Release, containing version 7.20.1 of the Datadog Cluster Agent for Cloud Foundry
