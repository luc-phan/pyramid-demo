from urllib.parse import urljoin

from wsgiref.simple_server import make_server
from pyramid.config import Configurator
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
import requests

from settings import WEB_PORT, API_URL

TODO_API_URL = urljoin(API_URL + "/", "todos")


@view_config(
    route_name='list',
    renderer='templates/list.jinja2'
)
def list_(request):
    response = requests.get(TODO_API_URL)
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
    requests.post(TODO_API_URL, json=dict(title=title))
    url = request.route_url('list') 
    return HTTPFound(location=url)


if __name__ == '__main__':
    with Configurator() as config:
        config.include('pyramid_jinja2')
        config.add_route('list', '/')
        config.add_route('new', '/new')
        config.add_route('create', '/create')
        config.scan()
        app = config.make_wsgi_app()

    print(f"Starting web server at http://localhost:{WEB_PORT}")
    server = make_server('0.0.0.0', WEB_PORT, app)
    server.serve_forever()
