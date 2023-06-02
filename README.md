pyramid-demo
============

Description
-----------

This is a demo using:

- Python
- Poetry
- FastAPI
- SQLAlchemy
- Alembic
- Pyramid

Usage
-----

Install dependencies:

```
$ poetry install
```

Activate virtual environment:

```
$ poetry shell
```

Start API server:

```
$ uvicorn api:app --reload
```

Exit virtual environment:

```
$ exit
```

Develop
-------

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
