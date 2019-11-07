# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Requirement
- ruby version: `>= 2.5.5`
- node version: `>= v8.10.0`
- packages
  - bundler: `'>= 1.17.2', '< 2'`
  - yarn: `'1.16.0'`
- database: `'sqlite3', '~> 3.7.14'`

## Install
```
$ git clone git@github.com:ingage/interview-skill-check.git
$ cd interview-skill-check
$ bundle install --path vendor/bundle
$ yarn install
$ yarn run build:dev
$ bin/rails s 
$ (please check http://localhost:3000/test)
```

## 要求仕様
詳しい要求仕様については [spec.md](spec.md) を参照してください。

## ソースの修正方法
このリポジトリを fork して、forkしたリポジトリのソースを修正してください。  
また、ライブラリなどは自由に追加していただいてOKです。  

質問などがある場合には、 https://github.com/orgs/ingage/teams/interviewee からお願いします。

## 補足
基本的には、`Rails 5.2` + `Webpack` の構成です。  
それ以外は、Database も含めて、特に処理はありません。  
sqlite3 については、Rails が必須だったために入れています。  
