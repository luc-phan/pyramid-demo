from urllib.parse import urljoin

from wsgiref.simple_server import make_server
from pyramid.config import Configurator
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound, HTTPBadRequest
from pyramid.response import Response
import requests

from settings import WEB_PORT, API_URL

TODO_API_URL = urljoin(API_URL + "/", "todos")


@view_config(
    route_name='list',
    renderer='templates/list.jinja2'
)
def list_(request):
    response = requests.get(TODO_API_URL, timeout=10)
    return dict(todos=response.json())


@view_config(
    route_name='new',
    request_method='GET',
    renderer='templates/new.jinja2'
)
def new(request):
    return {}


@view_config(
    route_name='create',
    request_method='POST',
)
def create(request):
    title = request.params['title']
    requests.post(TODO_API_URL, json=dict(title=title), timeout=10)
    url = request.route_url('list') 
    return HTTPFound(location=url)


@view_config(
    route_name='details',
    request_method='GET',
    renderer='templates/read.jinja2'
)
def read(request):
    id_ = request.matchdict["id"]
    url = urljoin(TODO_API_URL + "/", id_)
    response = requests.get(url, timeout=10)
    return response.json()


@view_config(
    route_name='update',
    request_method='POST'
)
def update(request):
    id_ = request.matchdict["id"]

    if 'update' in request.params:

        title = request.params['title']
        created_at = request.params['created_at']
        done = request.params.get('done', False)

        url = urljoin(TODO_API_URL + "/", id_)
        response = requests.put(url, json=dict(title=title, created_at=created_at, done=done), timeout=10)

        redirect_url = request.route_url('details', id=id_) 
        return HTTPFound(location=redirect_url)

    elif 'delete' in request.params:

        return Response("delete = Not implemented yet")

    else:

        return HTTPBadRequest("Exepected: update or delete")


if __name__ == '__main__':
    with Configurator() as config:
        config.include('pyramid_jinja2')
        config.add_route('list', '/')
        config.add_route('new', '/new')
        config.add_route('create', '/create')
        config.add_route('details', '/details/{id}', request_method='GET')
        config.add_route('update', '/details/{id}', request_method='POST')
        config.scan()
        app = config.make_wsgi_app()

    print(f"Starting web server at http://localhost:{WEB_PORT}")
    server = make_server('0.0.0.0', WEB_PORT, app)
    server.serve_forever()
