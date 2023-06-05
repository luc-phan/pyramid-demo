from typing import Union

from sqlalchemy import create_engine
from fastapi import FastAPI
import uvicorn

from settings import DATABASE_URL
from sqlalchemy.orm import sessionmaker
from crud import Crud
from models import Todo
from settings import API_PORT


app = FastAPI()
engine = create_engine(DATABASE_URL)
Session = sessionmaker(bind=engine)

todos = Crud(app, "/todos/", Session, Todo)


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=API_PORT)
