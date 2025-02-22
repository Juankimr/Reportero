from src.main import main, ping


def test_dummy():
    assert main() is None


def test_ping():
    assert ping() == "pong"
