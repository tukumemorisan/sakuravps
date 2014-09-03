#sakuravps

さくらVPSの初期設定を作成したChefのデータです。  
Windows Cygwin環境で、TUKUMEMO.COMが作成しました。  

##内容

* rootパスワードの変更
* SSH接続の設定変更
* sudoの設定
* 一般ユーザーの追加
* システムのアップデート
* iptablesの設定
* WEBサーバーの設定
* WEBページの設定
* マルチドメインの設定
* PHPの設定
* MySQLの設定
* Postfix/Dovecot/Postfix Adminの設定

http://tukumemo.com/cygwin-chef-sakura1/  
http://tukumemo.com/cygwin-chef-sakura2/  
http://tukumemo.com/cygwin-chef-sakura3/  
http://tukumemo.com/cygwin-chef-sakura4/  
http://tukumemo.com/cygwin-chef-sakura5/  
http://tukumemo.com/cygwin-chef-sakura6/  

##使う場合

ブログを読まなくても構いませんが、最低でも以下のファイルは変更してください。

chef-repo/nodes/sakuravps.json  
chef-repo/site-cookbooks/users/recipes/default.rb  
chef-repo/site-cookbooks/ssh/templates/default/authorized_keys.erb  
chef-repo/data_bags/account/webmaster.json  
chef-repo/data_bags/dbuser/webmaster.json  
chef-repo/data_bags/mail/vuser.json  
chef-repo/data_bags/sites/exmaple.json    

よろしくお願いいたします。
