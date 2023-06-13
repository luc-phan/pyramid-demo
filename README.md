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

TODO
----

- ~~Add `docker-compose.yml`.~~
