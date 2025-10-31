from flask import Flask, jsonify
import os

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME")
APP_VERSION = os.getenv("APP_VERSION")

@app.route("/")
def index():
    return f"<h1>{APP_NAME}</h1><p>Version: {APP_VERSION}</p>"

@app.route("/healthz")
def healthz():
    return jsonify(status="ok")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

