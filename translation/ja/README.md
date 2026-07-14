# rbenvによる、アプリのRuby環境の円滑な管理

rbenvは、Unixライクなシステムにおける、Rubyプログラミング言語のバージョン管理ツールです。
同じマシンで複数のRubyのバージョン間を切り替える上で便利です。
いくつかのプロジェクトで作業しているとき、それぞれで正しいRubyのバージョンで走るようにします。

## 仕組み

インストールしてPATHへrbenvを追加すると、`ruby`や`gem`や`bundler`やその他のRubyに関係する実行プログラムを呼び出したとき、まずrbenvを起動します。
それから、rbenvにより現在のプロジェクトディレクトリが読み取られ、`.ruby-version`という名前のファイルが探されます。
見つかったら、そのファイルをもって、ディレクトリ内で使うRubyのバージョンを決めます。
最後にrbenvにより、`~/.rbenv/versions/`以下からそのRubyのバージョンに見合うプログラムが見つけ出されます。

プロジェクトで使うRubyのバージョンは、例えば以下のように選べます。
```sh
cd myproject
# Rubyのバージョン3.1.2を選択：
rbenv local 3.1.2
```

このようにすると、現在のディレクトリに`.ruby-version`ファイルを作成または更新し、選んだバージョンが含まれます。
他のディレクトリにある別のプロジェクトでは、全く違うバージョンのRubyにできます。
rbenvにより、あるRubyのバージョンから別のバージョンへ、プロジェクトを切り替える際に円滑に移行されるのです。

最後に、rbenvの仕組みのほぼ全ての面を、bashで書かれた[プラグインでカスタマイズできます][plugins]。

rbenvの単純性には利点がありますが、欠点もあります。
詳細と代替案については[バージョン管理の比較][alternatives]をご参照ください。

## インストール

Homebrewパッケージ管理があるシステムでは、「パッケージ管理の使用」にある方法をお勧めします。
その他のシステムでは、「基本的なGitのチェックアウト」が最も簡単な方法でしょう。
常に最新のrbenvのバージョンがインストールされるからです。

### パッケージ管理の使用

1. 以下の方法のうちどれかを使ってrbenvをインストールします。

   #### Homebrew
   
   macOSないしLinuxでは、rbenvを[Homebrew](https://brew.sh)でインストールすることをお勧めします。
   
   ```sh
   brew install rbenv
   ```
   
   #### DebianとUbuntuとその派生
       
   > [!CAUTION]   
   > 公式のDebianとUbuntuのリポジトリでパッケージ化され、保守されているrbenvのバージョンは*最新ではありません*。
   > 最新版をインストールするには、[Gitを使ってrbenvをインストール](#basic-git-checkout)することをお勧めします。
   
   ```sh
   sudo apt install rbenv
   ```
   
   #### Arch Linuxとその派生
   
   Archlinuxには[公式パッケージ](https://archlinux.org/packages/extra/any/rbenv/)があり、そちらからインストールできます。

   ```sh
   sudo pacman -S rbenv
   ```

   #### Fedora

   Fedoraには[公式パッケージ](https://packages.fedoraproject.org/pkgs/rbenv/rbenv/)があり、そちらからインストールできます。

   ```sh
   sudo dnf install rbenv
   ```

2. rbenvを読み込むよう、シェルを設定します。

    ```sh
    rbenv init
    ```

3. 端末の窓を閉じて、新しい窓を開いてください。
   こうすることで、変更が反映されます。

以上です！
これで[Rubyのバージョンをインストール](#installing-ruby-versions)する準備ができました。

### 基本的なGitのチェックアウト

> [!NOTE]
> より自動的にインストールするには、[rbenv-installer](https://github.com/rbenv/rbenv-installer#rbenv-installer)が使えます。
> ウェブURLから実行スクリプトをダウンロードしたくなかったり、単に手作業による方法の方が好みであれば、以下の工程に従ってください。

これにより最新版のrbenvが得られます。
システム全域へのインストールは必要ありません。

1. rbenvを`~/.rbenv`へクローンします。

    ```sh
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    ```

2. rbenvを読み込むよう、シェルを設定します。

    ```sh
    ~/.rbenv/bin/rbenv init
    ```

   ご興味があれば、[`init`がしていることをご確認](#how-rbenv-hooks-into-your-shell)いただけます。

3. シェルを再始動すると、以上の変更の効果が現れます（大抵、新しい端末のタブを開けばよいです）。

#### シェルの補完

rbenvを*手作業で*インストールする場合、様々なシェルでの補完スクリプトの仕組みについて補足しておくと有用かもしれません。
補完スクリプトはrbenvのコマンドの打ち込みを助けるもので、一部が入力されたrbenvのコマンド名やオプションフラグを展開します。
大抵は、対話的なシェルで<kbd>タブ</kbd>を押すことで呼び出されます。

- rbenvの**bash**の補完スクリプトは本プロジェクトに付属しており、[`rbenv
  init`の仕組みにより読み込まれます](#how-rbenv-hooks-into-your-shell)。

- **zsh**の補完スクリプトはプロジェクトに付属しています。
  ただし、zshでFPATHに加える必要があり、そうすることによってシェルから見つかるようになります。
  1つの方法は`~/.zshrc`を編集することでしょう。

  ```sh
  # rbenvが`~/.rbenv`へインストールされたと仮定します
  FPATH=~/.rbenv/completions:"$FPATH"

  autoload -U compinit
  compinit
  ```

- rbenvの**fish**の補完スクリプトはfishシェル自体に付属しており、rbenvプロジェクトでは保守されていません。

### Rubyのバージョンのインストール

`rbenv install`コマンドはrbenvに付属しておらず、そのままのrbenvでは使えません。
[ruby-build][]プラグインで提供されています。

Rubyのインストールを試す前に、**[構築環境](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment)に必要なツールとライブラリがあることをご確認ください**。
それから以下を実施します。

```sh
# 最新安定版を一覧にする
rbenv install -l

# 全てのローカルにあるバージョンを一覧にする
rbenv install -L

# Rubyのバージョンをインストールする
rbenv install 3.1.2
```

`BUILD
FAILED`となった場合に問題を解決するには、[ruby-buildのディスカッションの部門](https://github.com/rbenv/ruby-build/discussions/categories/build-failures)をご確認ください。

> [!NOTE]  
> `rbenv install`コマンドが見つからなかったときは、ruby-buildをプラグインとしてインストールできます。
> ```sh
> git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
> ```

Rubyのバージョンを設定してインストールが完了したら、Rubyを使い始められます。
```sh
rbenv global 3.1.2   # このマシンの既定のRubyのバージョンを設定
# もしくは
rbenv local 3.1.2    # このディレクトリのRubyのバージョンを設定
```

`rbenv
install`コマンドに代えて、`~/.rbenv/versions`の副ディレクトリに手作業でRubyをダウンロードしてコンパイルすることもできます。
このディレクトリの項目も、ファイルシステムにあるインストールされたRubyのバージョンへのシンボリックリンクにできます。

#### Rubyのgemのインストール

`rbenv local 3.1.2`を使い、プロジェクトのRubyのバージョンを選んだとしましょう。
そうしたら、いつもしているようにgemのインストールを進めます。

```sh
gem install bundler
```

> [!NOTE]  
> gemのインストールでは*sudoを使うべきではありません*。
> 普通、Rubyのバージョンはホームディレクトリ以下にインストールされるため、利用者が書き込めます。
> gemをインストールするときに「you don't have write permissions」のエラーが出たら、「システム」のRubyのバージョンが大域的な既定のままと見られます。
> `rbenv global <version>`として変更し、もう一度gemのインストールを試してください。

`gem env`で、インストールされたgemの場所をご確認ください。

```sh
gem env home
# => ~/.rbenv/versions/<version>/lib/ruby/gems/...
```

#### Rubyのバージョンのアンインストール

次第に、インストールしたRubyのバージョンは`~/.rbenv/versions`ディレクトリに積み重なっていきます。

古いRubyのバージョンを削除するには、単に削除したいバージョンのディレクトリを`rm -rf`するだけです。
Rubyのバージョンのディレクトリを見つけるには、`rbenv prefix`コマンドが使えます。
例えば`rbenv prefix 2.7.0`とできます。

[ruby-build][]プラグインは`rbenv uninstall`コマンドを提供しており、この削除の工程が自動化されています。

## コマンドのリファレンス

知っておく必要のある、主要なrbenvのコマンドは次の通りです。

### rbenv versions

rbenvが把握している全てのRubyのバージョンを一覧にします。
また、現在有効なバージョンには隣にアスタリスクが表示されます。

    $ rbenv versions
      1.8.7-p352
      1.9.2-p290
    * 1.9.3-p327 (set by /Users/sam/.rbenv/version)
      jruby-1.7.1
      rbx-1.2.4
      ree-1.8.7-2011.03

### rbenv version

現在活性なRubyのバージョンを表示します。
加えて、どのように設定されたかについての情報もあります。

    $ rbenv version
    1.9.3-p327 (set by /Users/sam/.rbenv/version)

### rbenv local

局所的なアプリケーション固有のRubyのバージョンを設定し、バージョン名を現在のディレクトリの`.ruby-version`ファイルに書き込みます。
このバージョンは大域的なバージョンを上塗りします。
また、環境変数`RBENV_VERSION`を設定したり、`rbenv shell`コマンドでさらに上塗りすることもできます。

    rbenv local 3.1.2

バージョン番号なしで走らせると、`rbenv local`は現在構成されている局所的なバージョンを報告します。
局所的なバージョンの設定を外すこともできます。

    rbenv local --unset

### rbenv global

全てのシェルで使われる、大域的なRubyのバージョンを設定します。
バージョン名は`~/.rbenv/version`ファイルに書き込まれます。
このバージョンはアプリケーション固有の`.ruby-version`ファイルや`RBENV_VERSION`環境変数を設定して上塗りできます。

    rbenv global 3.1.2

特別なバージョン名である`system`を使うと、rbenvにより（`$PATH`の探索で検出された）システムのRubyが使われます。

バージョン名なしで走らせると、`rbenv global`は現在構成されている大域的なバージョンを報告します。

### rbenv shell

シェル固有のRubyのバージョンを設定します。
`RBENV_VERSION`環境変数がシェルに設定されます。
このバージョンはアプリケーション固有のバージョンと大域的なバージョンを上塗りします。

    rbenv shell jruby-1.7.1

バージョン番号なしで走らせると、`rbenv shell`は現在の`RBENV_VERSION`の値を報告します。
シェルのバージョンの設定を外すこともできます。

    rbenv shell --unset

なお、このコマンドを使うためには、（インストール手順の工程3つ目の）rbenvのシェルの統合を有効にする必要があります。
シェルの統合を使わない方向としては、単に`RBENV_VERSION`を設定してもよいでしょう。

    export RBENV_VERSION=jruby-1.7.1

### rbenv rehash

rbenvで把握している全てのRubyの実行プログラム (`~/.rbenv/versions/*/bin/*`)
のシンボリックリンクをインストールします。
普通、このコマンドを走らせる必要はありません。
gemをインストールした後に自動で走るからです。

    rbenv rehash

### rbenv which

実行プログラムの完全なパスを表示します。
与えられたコマンドを走らせるとき、rbenvはこのパスを呼び出します。

    $ rbenv which irb
    /Users/sam/.rbenv/versions/1.9.3-p327/bin/irb

### rbenv whence

特定の実行プログラム名を含むRubyのバージョンを全て表示します。

    $ rbenv whence rackup
    1.9.3-p327
    jruby-1.7.1
    ree-1.8.7-2011.03

## 環境変数

以下の設定で、rbenvによる操作を変えられます。

名前 | 既定 | 説明
-----|---------|------------
`RBENV_VERSION` | | 使用されるRubyのバージョンを指定します。<br>[`rbenv shell`](#rbenv-shell)も参照
`RBENV_ROOT` | `~/.rbenv` | ディレクトリを定義し、その下にRubyのバージョンとシンボリックリンクが置かれます。<br>`rbenv root`も参照
`RBENV_DEBUG` | | デバッグ情報を出力します。<br>`rbenv --debug <subcommand>`ともできます。
`RBENV_HOOK_PATH` | [*ウィキを参照*][hooks] | コロン区切りのパスのリストで、rbenvのフックが探索されます。
`RBENV_DIR` | `$PWD` | `.ruby-version`ファイルの探索を始めるディレクトリです。

### rbenvがシェルにフックする仕組み

`rbenv init`は、rbenvをシェルにフックを掛ける補助コマンドです。
この補助機能は推奨されるインストール手順の一部ですが、省けます。
経験を積めば、以下の作業を手で準備できるからです。
`rbenv init`コマンドでは、操作に2つのモードがあります。

1. `rbenv init`:
   人間のためのもので、このコマンドにより、ディスク上のシェル初期化ファイルが編集されて、シェルの起動にrbenvが追加されます（rbenv
   1.3.0より前では、このモードでは端末に利用者が従う手順が印字されるだけで、何もしませんでした）。

2. `rbenv init -`: 機会のためのもので、このコマンドは利用者のシェルで評価するのに適したシェルスクリプトを出力します。

`rbenv init`がbashシェルで呼び出されると、以下が利用者の`~/.bashrc`ないし`~/.bash_profile`に追加されます。

```sh
# Added by `rbenv init` on <日付>
eval "$(rbenv init - --no-rehash bash)"
```

準備の工程の部分で、`rbenv init`を走らせたくないときは、手作業でシェル初期化ファイルにこの行を加えても構いません。
以下は、評価されたスクリプトがすることです。

0. 必要であれば`rbenv`実行プログラムをPATHに加えます。

1. `~/.rbenv/shims`のディレクトリをPATHに前置します。
   基本的には、これこそがrbenvが適切に機能するための唯一の要件です。

2. rbenvのコマンド用にbashのシェル補完をインストールします。

3. rbenvのシンボリックリンクを再生成します。
   この工程でシェルの起動が低速になるときは、`--no-rehash`フラグ付きで`rbenv init -`を呼び出せます。

4. 「sh」の送出器をインストールします。
   このちょっとした工程も省けますが、rbenvやプラグインが現在のシェルで変数を変えられるようにします。
   また、`rbenv shell`のようなコマンドができるようになります。


### rbenvのアンインストール

rbenvは単純なので、一時的に無効にしたりシステムからアンインストールしたりするのは簡単です。

1. rbenvがRubyのバージョンを管理するのを**無効にする**には、単に`rbenv
   init`の行をシェルの起動の構成でコメントアウトしたり削除したりすればできます。
   こうすると、PATHからシンボリックリンクのディレクトリが除かれ、以降の`ruby`のような呼出しはシステムのRubyのバージョンが実行されます。
   rbenvは完全に迂回されます。

   無効にする一方で、`rbenv`はコマンドラインで利用できます。
   ただし、Rubyのアプリはバージョンの切替えに左右されなくなります。

2. 完全にrbenvを**アンインストール**するには、工程 (1) を実施してrbenvのルートディレクトリを削除します。
   これにより、`` `rbenv root`/versions/ ``以下にインストールされた**全てのRubyのバージョンが削除**されます。

       rm -rf "$(rbenv root)"

   パッケージ管理を使ってrbenvをインストールした場合、最後の工程としてはrbenvのパッケージを削除します
   - Homebrew: `brew uninstall rbenv`
   - DebianとUbuntuとその派生：`sudo apt purge rbenv`
   - Archlinuxとその派生：`sudo pacman -R rbenv`

## 開発

テストは[Bats](https://github.com/bats-core/bats-core)を使って実行されています。

    $ bats test
    $ bats test/<file>.bats

プルリクエストの提出や[イシュートラッカー](https://github.com/rbenv/rbenv/issues)でのバグ報告はご自由にどうぞ。

## 翻訳

このプロジェクトは`README`とmanページの現地化に対応しており、[GNU
gettext](https://www.gnu.org/software/gettext/)と[po4a](https://po4a.org/)を使っています。

### メンテナの作業工程

`README`とmanページの原文が更新されたら、`make`を実行してください。
これにより、対応する`.pot`と`.po`ファイルが更新されます。
`.po`ファイルの未翻訳の部分や古くなったことが示されている部分は、最新のソースの内容を反映しています。
これにより、翻訳者が最新の情報に対して確実に作業できるようになります。

### 翻訳者の作業工程

- `translation/po`ディレクトリ以下の関係する`.po`ファイルを編集してください。
- 翻訳を眺めたり校正したりするには、`make`と実行するだけです。これにより、現地化された`README`とmanページが更新された`.po`ファイルから再生成されます。
- 納得のいくものになったら、更新された`.po`ファイルと現地化されたファイルをプルリクエストでご提出ください。

### 要件

この作業工程はpo4aというツールに依存しています。po4aがインストールされていなければ、翻訳工程は飛ばされ、警告が表示されます。

po4aをインストールするには、お手元の[システムのパッケージマネージャ](https://repology.org/project/po4a/versions)をお使いください。例えば次の通りです。

```sh
# Debian/Ubuntu
sudo apt install po4a

# macOS（Homebrewの場合）
brew install po4a
```

  [ruby-build]: https://github.com/gemmaro/ruby-build/tree/ja/translation/ja#readme
  [hooks]: https://github.com/rbenv/rbenv/wiki/Authoring-plugins#rbenv-hooks
  [alternatives]: https://github.com/rbenv/rbenv/wiki/Comparison-of-version-managers
  [plugins]: https://github.com/rbenv/rbenv/wiki/Plugins

## 日本語訳について

この日本語訳の原文は[こちら](../../README.md)です。
