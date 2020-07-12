# git-bare-remote

gitはSSHがあれば相互にデータをやりとりできます。このシェルスクリプトは initとclone、リポジトリ一覧を表示するツールです。リポジトリを置くパスを決めておけば、毎回探す必要がありません。ここでは主に、Synology NASにGitリポジトリを設置する例を書きます。

# 必要要件

## クライアント

* ssh clinet
* bash

## リモート(一般的なLinuxサーバ)

* ssh server(公開鍵認証設定済)
* git
* perl

## リモート(Synology NAS)

* Git Server
* Perl
* ssh(後述)

# クライアントツールの設定

git-bare-remote.sh の以下の部分をエディタで編集してください。

	# リモートホスト、ユーザ名を指定する場合は user@host
	REMOTE_HOST=user@diskstation
	
	# リモートのパス
	# Diskstationの場合は/var/services/homes/[ユーザ名]/ がホームフォルダとなる
	REMOTE_PATH=/var/services/homes/username/git-repos

# 利用方法

コマンド一覧の表示

	./git-bare-remote.sh

リポジトリ一覧を表示します

	./git-bare-remote.sh list

git initを実行します。リポジトリ名にはスラッシュ(/)がつかえ、その場合は階層が掘られます

	./git-bare-remote.sh init リポジトリ名


git cloneを実行します。ローカルにcloneします

	./git-bare-remote.sh clone リポジトリ名

# Synology NASの設定

## sshdの有効化と公開鍵の有効化

1. コントロールパネル→端末とSNMP→SSHサービスを有効化する→適用
2. コントロールパネル→ユーザ→ユーザホームサービスを有効にする
3. ssh [ユーザ名]@[ホスト名] で管理者ユーザでログインします
4. sudo vim /etc/ssh/sshd_config
5. PubkeyAuthentication yes を追加
6. AuthorizedKeysFile .ssh/authorized_keys を追加
7. vim を終了して、以下のコマンドでsshdを再起動

コマンド

	$ synoservicectl --reload sshd

8. キーの追加

コマンド

	$ cd /var/services/homes/[ユーザ名]
	$ chmod 755 .
	$ mkdir .ssh
	$ chmod 700 .ssh
	$ vim .ssh/authorized_keys
	$ chmod 644 .ssh/authorized_keys
	公開鍵をペースト

これで公開鍵認証の設定完了です。ホームフォルダのパーミッションを755にする必要があります。

