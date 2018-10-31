import logging
from flask import Flask


def create_app():
    app = Flask(__name__)

    @app.route("/")
    def hello():
        return "Hello World"

    @app.route("/error")
    def error():
        assert app.debug == False

    return app


if __name__ == "__main__":
    create_app().run(host="0.0.0.0")
