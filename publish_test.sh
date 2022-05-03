PROJECT_ID=$1
gcloud config set project $PROJECT_ID
gcloud pubsub topics publish <topic_id> --message="Hello"