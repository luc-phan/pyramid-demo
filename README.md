pyramid-demo
============

![Screenshot](images/todo-list.png)

Description
-----------

This is a demo using:

- Python
- Poetry
- FastAPI
- SQLAlchemy
- Alembic
- Pyramid
- Docker
- AWS
- Terraform

This is a demo. Do not use in production.

Usage
-----

### Run with docker

Go inside docker directory:

```
$ cd docker
```

Customize host ports:

```
$ cp .env.example .env
$ vim .env
```

Run with docker-compose:

```
$ docker-compose up
```

Open with a web browser:

- http://localhost:8001/docs
- http://localhost:8001/redoc
- http://localhost:6543

Develop
-------

### Setup

Go inside source directory:

```
$ cd src
```

Configure application:

```
$ cp .env.example .env
$ vim .env
```

Install dependencies:

```
$ poetry install
```

Activate virtual environment:

```
$ poetry shell
```

Create database:

```
$ alembic upgrade head
```

Start API server:

```
$ python api.py
```

In another terminal, start web server:

```
$ cd src
$ poetry shell
$ python web.py
```

Open with a web browser:

- http://localhost:8001/docs
- http://localhost:8001/redoc
- http://localhost:6543

Exit virtual environment:

```
$ exit
```

### Inspect database

```
$ sqlite3 todo.db
sqlite> .tables
sqlite> .schema alembic_version 
sqlite> .headers on
sqlite> .mode column
sqlite> select * from todos;
sqlite> .quit
```

### Update database

```
$ vim models.py
$ alembic revision --autogenerate -m "Message"
$ alembic upgrade head
```

Deploy on AWS
-------------

Why are you reading this? It's not production-ready!

### Create a demo user

Create an access key for an admin user **who can manage IAM** (could be dangerous!):

![AWS access key](images/aws-access-key.png)

Authenticate with `aws-cli`:

```
$ aws configure
```

Create demo user:

```
$ cd terraform/create_demo_user
$ terraform apply
```

Get secret key:

```
$ vim terraform.tfstate
```

Authenticate with demo user:

```
$ aws configure --profile demo_user
```

Assume demo role:

```
$ export AWS_ACCOUNT=123456789012  # replace with account id
$ aws --profile demo_user sts assume-role --role-arn arn:aws:iam::$AWS_ACCOUNT:role/demo-role --role-session-name demo-session
```

Authenticate with demo role:

```
$ aws configure --profile demo_role
```

Fill `aws_session_token`:

```
$ vim ~/.aws/credentials
```

Test access to EC2:

```
$ aws --profile demo_role ec2 describe-instances
```

*(to be continued...)*

TODO
----

- ~~Add `docker-compose.yml`.~~
