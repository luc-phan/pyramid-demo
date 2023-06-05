from wsgiref.simple_server import make_server
from pyramid.config import Configurator
from pyramid.view import view_config
import requests

from settings import WEB_PORT


@view_config(
    route_name='list',
    renderer='templates/list.jinja2'
)
def list_(request):
    return {}


if __name__ == '__main__':
    with Configurator() as config:
        config.include('pyramid_jinja2')
        config.add_route('list', '/')
        config.scan()
        app = config.make_wsgi_app()

    print(f"Starting web server at http://localhost:{WEB_PORT}")
    server = make_server('0.0.0.0', WEB_PORT, app)
    server.serve_forever()
