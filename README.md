vagrant
===============

# janusのvagrantファイルリポジトリ

## ローカル環境の作り方

### Windows

* virtualBoxインストール

https://www.virtualbox.org/

これを書いた時は5.1.8

* vagrantインストール

https://www.vagrantup.com/downloads.html

これをk書いた時は1.8.7

* vagrantのプラグインをインストール

> vagrant plugin install vagrant-berkshelf

> vagrant plugin install vagrant-omnibus

* creator_uidを変更

> .vagrant/machines/default/virtualbox/creator_uid

を開いて内容0にする

* vagrant up

> vagrant up
