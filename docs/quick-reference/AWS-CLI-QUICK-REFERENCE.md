# AWS CLI Quick Reference

Common AWS CLI commands for S3, Lambda, RDS, CloudWatch, EC2, and more.

## Setup

### AWS Credentials

**Using .env (local development):**
```bash
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_REGION=us-east-1
```

Add to `.env.example`:
```env
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
AWS_PROFILE=your_profile_name
```

**Using IAM (from EC2):**
EC2 instances automatically use IAM role credentials. No .env needed.

**Using profiles (if you have multiple accounts):**
```bash
export AWS_PROFILE=profile-name
# or use --profile flag on each command
```

### Verify credentials are working

```bash
aws sts get-caller-identity
# Shows your account ID, user/role ARN
```

---

## S3

### List buckets

```bash
aws s3 ls
```

### List contents of a bucket

```bash
aws s3 ls s3://bucket-name/
aws s3 ls s3://bucket-name/path/to/folder/
```

### Upload a file

```bash
aws s3 cp local-file.txt s3://bucket-name/
aws s3 cp local-file.txt s3://bucket-name/path/to/file.txt
```

### Download a file

```bash
aws s3 cp s3://bucket-name/file.txt ./local-file.txt
```

### Sync a directory (upload multiple files)

```bash
aws s3 sync ./local-directory s3://bucket-name/remote-path/
# Only uploads changed files
```

### Delete a file

```bash
aws s3 rm s3://bucket-name/file.txt
```

### Delete a folder (recursive)

```bash
aws s3 rm s3://bucket-name/path/ --recursive
```

---

## Lambda

### List functions

```bash
aws lambda list-functions
aws lambda list-functions --query 'Functions[].FunctionName' --output text
# Just function names
```

### Invoke a function

```bash
aws lambda invoke --function-name my-function response.json
# response.json contains the output

# With payload (JSON)
aws lambda invoke \
  --function-name my-function \
  --payload '{"key": "value"}' \
  response.json
```

### View function details

```bash
aws lambda get-function --function-name my-function
```

### Update function code

```bash
aws lambda update-function-code \
  --function-name my-function \
  --s3-bucket my-bucket \
  --s3-key path/to/function.zip
```

---

## RDS

### List databases

```bash
aws rds describe-db-instances
aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier' --output text
# Just instance names
```

### Get database details

```bash
aws rds describe-db-instances --db-instance-identifier my-database
```

### Create a snapshot

```bash
aws rds create-db-snapshot \
  --db-instance-identifier my-database \
  --db-snapshot-identifier my-database-backup-2025-01-XX
```

### List snapshots

```bash
aws rds describe-db-snapshots --query 'DBSnapshots[].[DBSnapshotIdentifier,SnapshotCreateTime]'
```

### Start/Stop database instance

```bash
aws rds start-db-instance --db-instance-identifier my-database
aws rds stop-db-instance --db-instance-identifier my-database
```

---

## CloudWatch Logs

### List log groups

```bash
aws logs describe-log-groups
aws logs describe-log-groups --query 'logGroups[].logGroupName' --output text
```

### List log streams in a group

```bash
aws logs describe-log-streams --log-group-name /aws/lambda/my-function
```

### Get recent logs

```bash
aws logs tail /aws/lambda/my-function --follow
# Shows logs in real-time (Ctrl+C to exit)

aws logs tail /aws/lambda/my-function --since 1h
# Last hour of logs
```

### Tail with grep (filter)

```bash
aws logs tail /aws/lambda/my-function --follow | grep "ERROR"
```

---

## EC2

### List instances

```bash
aws ec2 describe-instances
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key==`Name`].Value|[0]]' --output table
# Shows ID, state, name
```

### Start an instance

```bash
aws ec2 start-instances --instance-ids i-1234567890abcdef0
```

### Stop an instance

```bash
aws ec2 stop-instances --instance-ids i-1234567890abcdef0
# Stops but doesn't terminate (can restart)
```

### Terminate an instance

```bash
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
# Permanently deletes (use with care)
```

### Get instance status

```bash
aws ec2 describe-instance-status --instance-ids i-1234567890abcdef0
```

---

## API Gateway

### List APIs

```bash
aws apigateway get-rest-apis
aws apigateway get-rest-apis --query 'items[].name' --output text
```

### Get API details

```bash
aws apigateway get-rest-api --rest-api-id api-id
```

---

## EventBridge

### List rules

```bash
aws events list-rules
aws events list-rules --query 'Rules[].Name' --output text
```

### Enable/Disable a rule

```bash
aws events enable-rule --name my-rule
aws events disable-rule --name my-rule
```

### List targets for a rule

```bash
aws events list-targets-by-rule --rule my-rule
```

---

## IAM

### List users

```bash
aws iam list-users
aws iam list-users --query 'Users[].UserName' --output text
```

### List roles

```bash
aws iam list-roles
aws iam list-roles --query 'Roles[].RoleName' --output text
```

### Get current user/role

```bash
aws sts get-caller-identity
```

### List policies attached to a user

```bash
aws iam list-attached-user-policies --user-name username
```

---

## Useful Flags & Patterns

### Output formats

```bash
--output text           # Plain text (good for piping)
--output json           # JSON (default, most data)
--output table          # Pretty table format
--query 'field'         # Extract specific data (JMESPath)
```

### Examples with query

```bash
# Just function names
aws lambda list-functions --query 'Functions[].FunctionName' --output text

# Just S3 bucket names
aws s3api list-buckets --query 'Buckets[].Name' --output text

# Specific data from EC2
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,State.Name]' --output table
```

### Filter by region

```bash
aws s3 ls --region us-west-2
aws rds describe-db-instances --region eu-west-1
```

### Help

```bash
aws [service] help
aws s3 help
aws lambda invoke help
```

---

## Common Workflows

### Download all logs from a Lambda function

```bash
aws logs tail /aws/lambda/my-function --since 24h > lambda-logs.txt
```

### Upload a file to S3 and make it public (if bucket allows)

```bash
aws s3 cp file.txt s3://bucket-name/
aws s3api put-object-acl --bucket bucket-name --key file.txt --acl public-read
```

### Invoke Lambda with input and save output

```bash
aws lambda invoke \
  --function-name process-data \
  --payload '{"input_bucket": "my-data"}' \
  output.json

cat output.json
```

### Check if Lambda function is running (CloudWatch)

```bash
aws logs tail /aws/lambda/my-function --follow
# Watch logs in real-time
```

---

## Troubleshooting

### "Unable to locate credentials"

```bash
# Make sure .env is sourced
source .env

# Or check if credentials file exists
cat ~/.aws/credentials
```

### "AccessDenied" errors

- Check IAM permissions for your user/role
- Verify you're using the right AWS profile: `aws sts get-caller-identity`
- Check if credentials are expired (refresh them)

### Command not found

```bash
aws --version              # Check if CLI is installed
which aws                  # Check if it's in your PATH
```

### Want to see what a command will do without running it

Most AWS CLI commands support `--dry-run`:
```bash
aws ec2 terminate-instances --instance-ids i-xxx --dry-run
# Shows what would happen without actually doing it
```

---

## Things to Remember

- **AWS is region-specific** – specify `--region` if needed
- **S3 bucket names are global** – must be unique across all AWS
- **Lambda invocations cost money** – be careful with automated testing
- **Use `--query` to extract data** – saves you from parsing JSON manually
- **Logs go to CloudWatch** – check there when something goes wrong
- **Start/Stop vs Terminate** – stopping preserves the instance, terminating deletes it
- **Always verify credentials** – run `aws sts get-caller-identity` to confirm