from urllib.parse import urljoin

from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from pydantic_sqlalchemy import sqlalchemy_to_pydantic


def update_object(obj, resource):
    for key, value in resource.dict().items():
        setattr(obj, key, value)


class Crud:
    def __init__(self, app, route, Session, model):
        self._app = app
        self._route = route
        self._Session = Session
        self._model = model

        self._pydantic_model = sqlalchemy_to_pydantic(model, exclude="id")
        self._create_backend()
    
    def _create_backend(self):

        @self._app.get(self._route)
        def list():
            with self._Session() as session:
                resources = session.query(self._model).all()
                result = jsonable_encoder(resources)

            return JSONResponse(status_code=200, content=result)

        @self._app.post(self._route)
        def create(resource: self._pydantic_model):
            with self._Session() as session:
                obj = self._model(**resource.dict())
                session.add(obj)
                session.commit()
                session.refresh(obj)
                result = jsonable_encoder(
                    {
                        "message": "Created",
                        "resource": obj
                    }
                )

            return JSONResponse(status_code=201, content=result)

        @self._app.get(urljoin(self._route + "/", "{resource_id}"))
        def read(resource_id: int):
            with self._Session() as session:
                obj = session.query(self._model).get(resource_id)

                if not obj:
                    raise HTTPException(status_code=404, detail="Not found")

                result = jsonable_encoder(obj)

            return JSONResponse(status_code=200, content=result)

        @self._app.put(urljoin(self._route + "/", "{resource_id}"))
        def update(resource_id: int, resource: self._pydantic_model):
            with self._Session() as session:
                obj = session.query(self._model).get(resource_id)

                if not obj:
                    raise HTTPException(status_code=404, detail="Not found")

                update_object(obj, resource)
                session.commit()
                session.refresh(obj)
                result = jsonable_encoder(
                    {
                        "message": "Updated",
                        "resource": obj
                    }
                )

            return JSONResponse(status_code=200, content=result)

        @self._app.delete(urljoin(self._route + "/", "{resource_id}"))
        def delete(resource_id: int):
            with self._Session() as session:
                obj = session.query(self._model).get(resource_id)

                if not obj:
                    raise HTTPException(status_code=404, detail="Not found")

                result = jsonable_encoder(
                    {
                        "message": "Deleted",
                        "resource": obj
                    }
                )
                session.delete(obj)
                session.commit()

            return JSONResponse(status_code=200, content=result)
