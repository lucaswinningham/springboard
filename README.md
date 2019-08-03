# springboard

clone the repo

```bash
$ git clone git@github.com:lucaswinningham/springboard.git
$ cd springboard
```

install api dependencies

```bash
$ cd springboard/api
$ bundle
```

create and fill .env

```
$ touch .env
```

###### api/.env

```
DB_ROLE_NAME=springboardapp

DEVS_DB_NAME=springboarddevsdb
DEVS_DB_PASS=devs

TEST_DB_NAME=springboardtestdb
TEST_DB_PASS=test

PROD_DB_NAME=springboardproddb
PROD_DB_PASS=prod

```

create user role and setup database

```
$ createuser -d springboardapp
$ rails db:create
$ rails db:migrate
```

install client dependencies

```bash
$ cd springboard/client
$ npm i
```

install mailer dependencies

```bash
$ cd springboard/mailer
$ bundle
```
