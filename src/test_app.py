from flask import url_for


def test_hello(client):
    res = client.get(url_for("hello"))
    assert res.status_code == 200
