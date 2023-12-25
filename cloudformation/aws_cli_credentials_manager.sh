#!/bin/bash

cat << EOF | grep -v '^#' | awk 'BEGIN { RS = ""; ORS = "\n\n" } { print }' > ~/.aws/credentials
#
# Set AWS credentials here
# https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-files.html#cli-configure-files-format-profile
#
# Example of using general
# [example-dev-tokyo] # Profile (${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME})
# aws_access_key_id = AKIAIOSFODNN7EXAMPLE # Specify AWS Access Key ID
# aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY # Specify AWS Secret Access Key
# region = ap-northeast-1 # Specify the region to be used
#
# Example of using SwitchRole
# [example] # SourceProfile (${SYSTEM_NAME})
# aws_access_key_id = AKIAIOSFODNN7EXAMPLE # Specify AWS Access Key ID
# aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY # Specify AWS Secret Access Key
#
# [example-stg-tokyo] # SwitchRoleProfile (${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME})
# source_profile = example # Specify SourceProfile
# role_arn = arn:aws:iam::${STG_ACCOUNT_ID}:role/${STG_SWITCH_ROLE_NAME} # Specify the ARN of the switch role to be used
# mfa_serial = arn:aws:iam::${SOURCE_ACCOUNT_ID}:mfa/${MFA_NAME} # Specify the ARN of the MFA device to be used
# region = ap-northeast-1 # Specify the region to be used
#


EOF

exit 0
