# jposug-build-tools

jposug のビルドツールの置き換え

## 置き換える理由

現行のビルドツールの依存関係の解決には、

* spec_depend.pl
* spec_depend_spectool.pl

があるが、どちらも使いにくい。

spec_depend.pl は変数やマクロを展開してくれないため、
現在登録されている多くの spec file に対応できない。

spec_depend_spectool.pl は `spectool` を使って
変数やマクロの展開までしてくれるが遅い。

このあたりをなんとかするために書いてみた。

## 使い方

以下のように、ファイルを配置。

```
$ cp -r lib /path/to/jposug_repo
$ cp bin/* /path/to/jposug_repo/bin
$ cp spec/fixtures/specfiles/{GNUmakefile,common.mak} /path/to/jposug_repo/specs
```

あとはこれまで通り、

```
gmake depend && gmake
```

