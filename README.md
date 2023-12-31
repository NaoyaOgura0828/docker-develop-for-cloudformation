# docker-develop-for-cloudformation
[Docker](https://www.docker.com/)で[CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/Welcome.html)開発環境を構築する。

<br>

# Requirement
以下のlocalhost環境で動作確認済み<br>
- [Fedora](https://fedoraproject.org/ja/)39
- [Windows](https://www.microsoft.com/ja-jp/windows/)10

<br>

# Installation
git cloneコマンドで本Repositoryを任意のディレクトリ配下にcloneする。

<br>

# Settings
[.env](./.env)を設定することで、任意の設定でContainerを実行する事が可能である。

## 実行ユーザー名の設定
[.env](./.env)内の`USER_NAME`にコンテナ起動後の実行ユーザーを設定する。

```
USER_NAME = ${実行ユーザー名}
```

<br>

## コンテナイメージ名の設定
[.env](./.env)内の`IMAGE_NAME`を任意のコンテナイメージ名に変更する。

```
IMAGE_NAME = ${コンテナイメージ名}
```

<br>

> [!WARNING]
> コンテナイメージは以下の命名規則に従うこと。<br>
> `^[a-z0-9][a-z0-9_.-]{1,}$`

<br>

> [!NOTE]
> [DockerHub](https://hub.docker.com/)へコンテナイメージのPUSHを想定する場合は以下の命名規則に従うこと。
> ```
> IMAGE_NAME = ${DockerHubユーザー名}/${コンテナイメージ名}:${タグ名}
> ```

<br>

## ボリューム名の設定(Optional)
[.env](./.env)内の`VOLUME_NAME`を任意のボリューム名に変更する。
<br>
ボリューム名が起動中のコンテナと重複しないように留意する。

```
VOLUME_NAME = ${ボリューム名}
```

<br>

## ネットワーク名の設定(Optional)
[.env](./.env)内の`NETWORK_NAME`を任意のネットワーク名に変更する。
<br>
ネットワーク名が起動中のコンテナと重複しないように留意する。

```
NETWORK_NAME = ${ネットワーク名}
```

<br>

# Usage

## コンテナ実行
本Repository直下([docker-compose.yml](./docker-compose.yml)が存在するディレクトリ)で以下のコマンドを実行する。

```bash
docker compose up -d --build
```

<br>

## コンテナ環境へのアクセス
1. VSCodeの拡張機能左メニューから拡張機能`リモートエクスプローラー`を押下する。

<img src='images/RemoteDevelopment_RemoteExplorer.png'>

<br>

2. プルダウンを`開発コンテナー`に変更し、コンテナ一覧から本リポジトリ名にマウスオーバーする。

<img src='images/RemoteDevelopment_DevContainer.png'>

<br>

3. 右側に表示される`新しいウィンドウでアタッチする`を押下する。

<img src='images/RemoteDevelopment_AttachNewWindow.png'>

<br>

## [aws_cli_credentials_manager.sh](cloudformation/aws_cli_credentials_manager.sh)
[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)は[--profileオプション](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-files.html#cli-configure-files-using-profiles)を使用しない場合、`[default]`のprofileが使用される。<br>
[NaoyaOgura](https://github.com/NaoyaOgura0828)が開発するCloudFormationのTemplate群は、ShellScript内のAWS CLIコマンド実行によるAWS環境構築を前提としている。<br>
構築先環境の切替をする為、下記の命名規則で各環境毎に個別のprofileを作成する。

```bash
${SYSTEM_NAME}-${ENV_TYPE}-${REGION_NAME}
```

profileは`~/.aws/credentials`へ設定する必要があるが、`~/.aws/credentials`はコメントアウトがサポートされていない。<br>
[aws_cli_credentials_manager.sh](cloudformation/aws_cli_credentials_manager.sh)を使用する事で、profileの管理を簡略化する事が可能である。

> [!NOTE]
> `[default]`のprofileは使用しない。

<br>

### Profile設定 有効化
1. [コンテナ環境へアクセス](#コンテナ環境へのアクセス)し、[~/.aws/aws_cli_credentials_manager.sh](cloudformation/aws_cli_credentials_manager.sh)を開く。

2. [aws_cli_credentials_manager.sh](cloudformation/aws_cli_credentials_manager.sh)内の説明に従い、Profileを設定し、保存する。

```bash
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

[testsystem-dev-tokyo]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region = ap-northeast-1

EOF

exit 0

```

<br>

> [!WARNING]
> `aws_access_key_id`と`aws_secret_access_key`は絶対にGitHub等にPublicで公開しないこと。<br>
> AWSアカウントを不正利用される危険性がある[(参考URL)](https://qiita.com/saitotak/items/813ac6c2057ac64d5fef)

<br>

> [!NOTE]
> [S3バケットの命名規則](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/bucketnamingrules.html)に代表される、一部のAWSサービスでは英大文字の使用が許可されていない。<br>
> [CloudFormation組み込み関数](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html)使用時の不整合を避ける為、`${SYSTEM_NAME}`と`${ENV_TYPE}`は全Systemで小文字を使用することを推奨する。

<br>

3. 下記コマンドを実行する。

```bash
$ cd ~/.aws/
$ ./aws_cli_credentials_manager.sh
```

4. `~/.aws/credentials`が設定されていることを確認する。

```
[testsystem-dev-tokyo]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region = ap-northeast-1
```
<br>

### Profile設定 無効化
1. [コンテナ環境へアクセス](#コンテナ環境へのアクセス)し、[~/.aws/aws_cli_credentials_manager.sh](cloudformation/aws_cli_credentials_manager.sh)を開く。

2. 無効化対象のProfileをコメントアウトし、保存する。

```bash
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

# [testsystem-dev-tokyo]
# aws_access_key_id = AKIAIOSFODNN7EXAMPLE
# aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# region = ap-northeast-1

EOF

exit 0

```

<br>

3. 下記コマンドを実行する。

```bash
$ cd ~/.aws/
$ ./aws_cli_credentials_manager.sh
```

4. `~/.aws/credentials`から無効化対象のProfileが削除されていることを確認する。

<br>
