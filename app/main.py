import base64
import os
import logging
import google.cloud.logging

from flask import Flask, request


app = Flask(__name__)
API_USER = os.environ.get("API_USER")
API_SECRET = os.environ.get("API_SECRET")
client = google.cloud.logging.Client()
client.setup_logging()

@app.route("/", methods=["POST"])
def process():
    logging.info(f"invoking with {API_USER} and {API_SECRET}")
    envelope = request.get_json()
    if not envelope:
        msg = "no Pub/Sub message received"
        logging.error(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    if not isinstance(envelope, dict) or "message" not in envelope:
        msg = "invalid Pub/Sub message format"
        logging.error(f"error: {msg}")
        return f"Bad Request: {msg}", 400

    pubsub_message = envelope["message"]

    if isinstance(pubsub_message, dict) and "data" in pubsub_message:
        data = base64.b64decode(pubsub_message["data"]).decode("utf-8").strip()
        logging.info(f"data: {data}")
        return data, 200
    else:
        logging.error(f"failed to decode message {pubsub_message}")
        return f"failed to decode message {pubsub_message}", 400


if __name__ == "__main__":
    PORT = int(os.getenv("PORT")) if os.getenv("PORT") else 8080
    # This is used when running locally. Gunicorn is used to run the
    # application on Cloud Run. See entrypoint in Dockerfile.
    app.run(host="127.0.0.1", port=PORT, debug=True)