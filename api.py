from typing import Union

from sqlalchemy import create_engine
from fastapi import FastAPI

from settings import DATABASE_URL
from sqlalchemy.orm import sessionmaker
from crud import Crud
from models import Todo

app = FastAPI()
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)

todos = Crud(app, "/todos/", Session, Todo)
