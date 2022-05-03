# EventArc PoC

This code is not ment to be used in a production environment!

## Provision infrastructure

Replace <project_id> placeholder by your project id in create_state_bucket.sh
```
./create_state_bucket.sh <project_id>
terraform init
terraform plan
terraform apply -auto-approve
```

## Test

Replace <topic_id> placeholder by your topic_id
```
/publish_test.sh scc-test-proxy <project_id>
```