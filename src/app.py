from flask import Flask, jsonify
import os

def create_app():
    """Flask application factory"""
    app = Flask(__name__)

    # Config
    app.config["APP_NAME"] = os.getenv("APP_NAME", "MyFlaskApp")
    app.config["APP_VERSION"] = os.getenv("APP_VERSION", "0.1.0")

    # Routes
    @app.route("/")
    def index():
        return f"<h1>{app.config['APP_NAME']}</h1><p>Version: {app.config['APP_VERSION']}</p>"

    @app.route("/healthz")
    def healthz():
        return jsonify(status="ok")

    return app


# Run the app only if executed directly
if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=5000)
