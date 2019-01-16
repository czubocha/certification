#!/usr/bin/env bash
export account_id=071572870590
export infra_bucket_name=certification-infra-auto
export region=eu-central-1
export mysshkey=certification
aws cloudformation update-stack --stack-name certification-cicd --template-url \
https://s3-$region.amazonaws.com/$infra_bucket_name/master-ecs.yaml --parameters \
ParameterKey=CodeBuildContainerSpringBootDocker,ParameterValue=$account_id.dkr.ecr.$region.amazonaws.com/custombuild:latest \
ParameterKey=InfraAutomationCfnBucket,ParameterValue=$infra_bucket_name \
ParameterKey=KeyPair,ParameterValue=$mysshkey \
--capabilities CAPABILITY_IAM
