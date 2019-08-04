# springboard

clone the repo

```bash
$ git clone git@github.com:lucaswinningham/springboard.git
$ cd springboard
```

## api

install api dependencies

```bash
$ cd api
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

## client

install client dependencies

```bash
$ cd client
$ npm i
```

if problems, try upgrading angular devkit

```
{
  ...,
  "devDependencies": {
    "@angular-devkit/build-angular": "^0.12.4",
    ...
  }
}

```

## mailer

install mailer dependencies

```bash
$ cd mailer
$ bundle
```

create and fill .env

```
$ touch .env
```

Go https://myaccount.google.com/security > Signing in to Google > Select app > Other, Select Device > Other, copy password

###### mailer/.env

```
ENVIRONMENT=developement

AMQP_URL=amqp://localhost:5672

GMAIL_USERNAME=lucas.winningham
GMAIL_PASSWORD=zkulxdcuhwzbpdra

```

## rabbit

if not already installed, install rabiit

```bash
$ brew install rabbitmq
```

###### ~/.bash_profile

```bash
...

export PATH="$PATH:/usr/local/sbin"

```

```bash
$ source ~/.bashrc
# $ brew services start rabbitmq
$ rabbitmq-server
```
