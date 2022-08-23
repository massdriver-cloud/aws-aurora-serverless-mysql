




[![Massdriver][logo]][website]

# aws-aurora-serverless-mysql

[![Release][release_shield]][release_url]
[![Contributors][contributors_shield]][contributors_url]
[![Forks][forks_shield]][forks_url]
[![Stargazers][stars_shield]][stars_url]
[![Issues][issues_shield]][issues_url]
[![MIT License][license_shield]][license_url]

<!--
##### STILL NEED TO GET SLACK WORKING ###
[!["Slack Community"](%s)][slack]
-->


Highly Available Serverless MySQL Service At 1/10th The Cost Of Commercial-Grade Databases.


---

## Design

For detailed information, check out our [Operator Guide](operator.mdx) for this bundle.

## Usage

Our bundles aren't intended to be used locally, outside of testing. Instead, our bundles are designed to be configured, connected, deployed and monitored in the [Massdriver][website] platform.

### What are Bundles?

Bundles are the basic building blocks of infrastructure, applications, and architectures in [Massdriver][website]. Read more [here](https://docs.massdriver.cloud/concepts/bundles).

## Bundle

### Params

Form input parameters for configuring a bundle for deployment.

<details>
<summary>View</summary>

<!-- PARAMS:START -->
## Properties

- **`allow_major_version_upgrade`** *(boolean)*: Determines whether major engine upgrades are allowed when changing engine version. Default: `False`.
- **`backup_retention_period`** *(integer)*: How long to keep backups for in days. Minimum: `1`. Maximum: `35`. Default: `1`.
- **`deletion_protection`** *(boolean)*: If the DB instance should have deletion protection enabled. Default: `True`.
- **`enable_http_endpoint`** *(boolean)*: Whether or not to enable the Data API for a serverless Aurora database engine. Default: `False`.
- **`scaling_configuration`** *(object)*: Serverless scaling properties.
  - **`auto_pause`** *(boolean)*: Whether to enable automatic pause. A DB cluster can be paused only when it's idle (it has no connections). Default: `True`.
  - **`max_capacity`** *(number)*: Each capacity unit is equivalent to a specific compute and memory configuration. Based on the maximum capacity unit setting, Aurora Serverless automatically creates scaling rules for thresholds for CPU utilization, connections, and available memory. Aurora Serverless provides more capacity for the DB cluster from warm pool of resources when its workload is above these thresholds. Aurora Serverless can increase capacity to the maximum capacity unit. Must be one of: `[1, 2, 4, 8, 16, 32, 64, 128, 256]`. Default: `4`.
  - **`min_capacity`** *(number)*: Each capacity unit is equivalent to a specific compute and memory configuration. Based on the minimum capacity unit setting, Aurora Serverless automatically creates scaling rules for thresholds for CPU utilization, connections, and available memory. Aurora Serverless reduces the resources for the DB cluster when its workload is below these thresholds. Aurora Serverless can reduce capacity down to the minimum capacity unit. Must be one of: `[1, 2, 4, 8, 16, 32, 64, 128, 256]`. Default: `2`.
  - **`seconds_until_auto_pause`** *(number)*: The time, in seconds, before an Aurora DB cluster in serverless mode is paused. Minimum: `300`. Maximum: `86400`. Default: `300`.
  - **`timeout_action`** *(string)*: The action to take when the timeout is reached. [Learn more](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.how-it-works.html#aurora-serverless.how-it-works.timeout-action). Must be one of: `['ForceApplyCapacityChange', 'RollbackCapacityChange']`. Default: `RollbackCapacityChange`.
- **`skip_final_snapshot`** *(boolean)*: Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. Default: `True`.
- **`subnet_type`** *(string)*: Deploy the database to internal subnets (cannot reach the internet) or private subnets (internet egress traffic allowed). Must be one of: `['internal', 'private']`. Default: `internal`.
- **`username`** *(string)*: Administrative (root) DB username. Default: `root`.
## Examples

  ```json
  {
      "__name": "Development",
      "backup_retention_period": 1,
      "deletion_protection": false,
      "scaling_configuration": {
          "max_capacity": 2,
          "min_capacity": 2,
          "timeout_action": "ForceApplyCapacityChange"
      },
      "skip_final_snapshot": true
  }
  ```

  ```json
  {
      "__name": "Production",
      "backup_retention_period": 30,
      "deletion_protection": true,
      "scaling_configuration": {
          "max_capacity": 32,
          "min_capacity": 2,
          "timeout_action": "RollbackCapacityChange"
      },
      "skip_final_snapshot": false
  }
  ```

<!-- PARAMS:END -->

</details>

### Connections

Connections from other bundles that this bundle depends on.

<details>
<summary>View</summary>

<!-- CONNECTIONS:START -->
## Properties

- **`aws_authentication`** *(object)*: . Cannot contain additional properties.
  - **`data`** *(object)*
    - **`arn`** *(string)*: Amazon Resource Name.

      Examples:
      ```json
      "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
      ```

      ```json
      "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
      ```

    - **`external_id`** *(string)*: An external ID is a piece of data that can be passed to the AssumeRole API of the Security Token Service (STS). You can then use the external ID in the condition element in a role's trust policy, allowing the role to be assumed only when a certain value is present in the external ID.
  - **`specs`** *(object)*
    - **`aws`** *(object)*: .
      - **`region`** *(string)*: AWS Region to provision in.

        Examples:
        ```json
        "us-west-2"
        ```

      - **`resource`** *(string)*
      - **`service`** *(string)*
      - **`zone`** *(string)*: AWS Availability Zone.

        Examples:
- **`vpc`** *(object)*: . Cannot contain additional properties.
  - **`data`** *(object)*
    - **`infrastructure`** *(object)*
      - **`arn`** *(string)*: Amazon Resource Name.

        Examples:
        ```json
        "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
        ```

        ```json
        "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
        ```

      - **`cidr`** *(string)*

        Examples:
        ```json
        "10.100.0.0/16"
        ```

        ```json
        "192.24.12.0/22"
        ```

      - **`internal_subnets`** *(array)*
        - **Items** *(object)*: AWS VCP Subnet.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

          - **`aws_zone`** *(string)*: AWS Availability Zone.

            Examples:
          - **`cidr`** *(string)*

            Examples:
            ```json
            "10.100.0.0/16"
            ```

            ```json
            "192.24.12.0/22"
            ```


          Examples:
      - **`private_subnets`** *(array)*
        - **Items** *(object)*: AWS VCP Subnet.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

          - **`aws_zone`** *(string)*: AWS Availability Zone.

            Examples:
          - **`cidr`** *(string)*

            Examples:
            ```json
            "10.100.0.0/16"
            ```

            ```json
            "192.24.12.0/22"
            ```


          Examples:
      - **`public_subnets`** *(array)*
        - **Items** *(object)*: AWS VCP Subnet.
          - **`arn`** *(string)*: Amazon Resource Name.

            Examples:
            ```json
            "arn:aws:rds::ACCOUNT_NUMBER:db/prod"
            ```

            ```json
            "arn:aws:ec2::ACCOUNT_NUMBER:vpc/vpc-foo"
            ```

          - **`aws_zone`** *(string)*: AWS Availability Zone.

            Examples:
          - **`cidr`** *(string)*

            Examples:
            ```json
            "10.100.0.0/16"
            ```

            ```json
            "192.24.12.0/22"
            ```


          Examples:
  - **`specs`** *(object)*
    - **`aws`** *(object)*: .
      - **`region`** *(string)*: AWS Region to provision in.

        Examples:
        ```json
        "us-west-2"
        ```

      - **`resource`** *(string)*
      - **`service`** *(string)*
      - **`zone`** *(string)*: AWS Availability Zone.

        Examples:
<!-- CONNECTIONS:END -->

</details>

### Artifacts

Resources created by this bundle that can be connected to other bundles.

<details>
<summary>View</summary>

<!-- ARTIFACTS:START -->

**Artifacts coming soon**

<!-- ARTIFACTS:END -->

</details>

## Contributing

<!-- CONTRIBUTING:START -->

### Bug Reports & Feature Requests

Did we miss something? Please [submit an issue](https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/issues) to report any bugs or request additional features.

### Developing

**Note**: Massdriver bundles are intended to be tightly use-case scoped, intention-based, reusable pieces of IaC for use in the [Massdriver][website] platform. For this reason, major feature additions that broaden the scope of an existing bundle are likely to be rejected by the community.

Still want to get involved? First check out our [contribution guidelines](https://docs.massdriver.cloud/bundles/contributing).

### Fix or Fork

If your use-case isn't covered by this bundle, you can still get involved! Massdriver is designed to be an extensible platform. Fork this bundle, or [create your own bundle from scratch](https://docs.massdriver.cloud/bundles/development)!

<!-- CONTRIBUTING:END -->

## Connect

<!-- CONNECT:START -->

Questions? Concerns? Adulations? We'd love to hear from you!

Please connect with us!

[![Email][email_shield]][email_url]
[![GitHub][github_shield]][github_url]
[![LinkedIn][linkedin_shield]][linkedin_url]
[![Twitter][twitter_shield]][twitter_url]
[![YouTube][youtube_shield]][youtube_url]
[![Reddit][reddit_shield]][reddit_url]

<!-- markdownlint-disable -->

[logo]: https://raw.githubusercontent.com/massdriver-cloud/docs/main/static/img/logo-with-logotype-horizontal-400x110.svg
[docs]: https://docs.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=docs
[website]: https://www.massdriver.cloud/?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=website
[github]: https://github.com/massdriver-cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=github
[slack]: https://massdriverworkspace.slack.com/?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=slack
[linkedin]: https://www.linkedin.com/company/massdriver/?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=linkedin



[contributors_shield]: https://img.shields.io/github/contributors/massdriver-cloud/aws-aurora-serverless-mysql.svg?style=for-the-badge
[contributors_url]: https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/graphs/contributors
[forks_shield]: https://img.shields.io/github/forks/massdriver-cloud/aws-aurora-serverless-mysql.svg?style=for-the-badge
[forks_url]: https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/network/members
[stars_shield]: https://img.shields.io/github/stars/massdriver-cloud/aws-aurora-serverless-mysql.svg?style=for-the-badge
[stars_url]: https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/stargazers
[issues_shield]: https://img.shields.io/github/issues/massdriver-cloud/aws-aurora-serverless-mysql.svg?style=for-the-badge
[issues_url]: https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/issues
[release_url]: https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/releases/latest
[release_shield]: https://img.shields.io/github/release/massdriver-cloud/aws-aurora-serverless-mysql.svg?style=for-the-badge
[license_shield]: https://img.shields.io/github/license/massdriver-cloud/aws-aurora-serverless-mysql.svg?style=for-the-badge
[license_url]: https://github.com/massdriver-cloud/aws-aurora-serverless-mysql/blob/main/LICENSE


[email_url]: mailto:support@massdriver.cloud
[email_shield]: https://img.shields.io/badge/email-Massdriver-black.svg?style=for-the-badge&logo=mail.ru&color=000000
[github_url]: mailto:support@massdriver.cloud
[github_shield]: https://img.shields.io/badge/follow-Github-black.svg?style=for-the-badge&logo=github&color=181717
[linkedin_url]: https://linkedin.com/in/massdriver-cloud
[linkedin_shield]: https://img.shields.io/badge/follow-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&color=0A66C2
[twitter_url]: https://twitter.com/massdriver?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=twitter
[twitter_shield]: https://img.shields.io/badge/follow-Twitter-black.svg?style=for-the-badge&logo=twitter&color=1DA1F2
[discourse_url]: https://community.massdriver.cloud?utm_source=github&utm_medium=readme&utm_campaign=aws-aurora-serverless-mysql&utm_content=discourse
[discourse_shield]: https://img.shields.io/badge/join-Discourse-black.svg?style=for-the-badge&logo=discourse&color=000000
[youtube_url]: https://www.youtube.com/channel/UCfj8P7MJcdlem2DJpvymtaQ
[youtube_shield]: https://img.shields.io/badge/subscribe-Youtube-black.svg?style=for-the-badge&logo=youtube&color=FF0000
[reddit_url]: https://www.reddit.com/r/massdriver
[reddit_shield]: https://img.shields.io/badge/subscribe-Reddit-black.svg?style=for-the-badge&logo=reddit&color=FF4500

<!-- markdownlint-restore -->

<!-- CONNECT:END -->
