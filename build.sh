echo $1
echo $2

gcloud builds submit --project $1 --region $2 --config ./app/cloudbuild.yaml