# docker_develop_for_cloudformation
DockerでCloudFormation開発環境を構築する。

<br>

# Requirement
Fedora36ローカル環境で実行確認済。
<br>
VSCodeとVSCode拡張機能をInstallする。
- VS Code
    - Docker
    - Remote Development

<br>

# Installation
git cloneコマンドで本Repositoryを任意のディレクトリ配下にcloneする。

<br>

## 実行ユーザーの設定
`Dockerfile`内のUSER_NAMEにコンテナ起動後の実行ユーザーを設定する。

```Dockerfile
# Execution user name after container startup
ARG USER_NAME=${実行ユーザー名}
```

<br>

`devcontainer.json`内のcontainerUserにコンテナ起動後の実行ユーザーを設定する。
<br>
`devcontainer.json`内のworkspaceFolderにコンテナ起動後の実行ユーザーを設定する。

```json
{
	"name": "CloudFormation 開発環境",
	"dockerComposeFile": [
		"../docker-compose.yml"
	],
	"service": "cloudformation",
	"containerUser": "${実行ユーザー名}",
	"workspaceFolder": "/home/${実行ユーザー名}"
}
```

<br>

ホストマシンのOSがLinux以外の場合は、`docker-compose.yml`内の`Valid only if the host OS is Linux`とコメントされている行をコメントアウトする。

```yml
    volumes:
      - /etc/passwd:/etc/passwd:ro # Valid only if the host OS is Linux
      - /etc/group:/etc/group:ro # Valid only if the host OS is Linux
```

<br>

## コンテナIPアドレスの設定
`.env`内のIPアドレスを任意の値に変更する。(例：127.0.0.2)
<br>
IPアドレスが起動中のコンテナと重複しないように留意する。

```
IP = 127.0.0.1
```

<br>

# Usage
初回起動時
1. VSCodeを起動し、cloneした本Repositoryフォルダを開く。
2. ウィンドウ左下緑色の`"><"`を押下し、`"Reopen in Container"`を押下する。

2回目以降
1. VSCodeを起動し、左メニューから拡張機能`リモートエクスプローラー`を押下する。
2. プルダウンを`Containers`に変更し、コンテナ一覧に表示されている`docker_develop_for_rockylinux-cloudformation-1`にマウスオーバーする。
3. `docker_develop_for_rockylinux-cloudformation-1`右に表示される`フォルダアイコン`を押下する。