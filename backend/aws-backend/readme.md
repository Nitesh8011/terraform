## Terraform Backend Setup (S3 + DynamoDB)

This repository uses a **two-step process** to configure the Terraform remote backend safely.

---

### Step 1: Create Backend Infrastructure (Local State)

1. **Comment out the backend block** in `main.tf`:

   ```hcl
   terraform {
     # backend "s3" {
     #   bucket         = "terraform-state-xxxx"
     #   key            = "terraform.tfstate"
     #   region         = "ap-southeast-1"
     #   dynamodb_table = "terraform_state_lock_table"
     # }
   }
#### 2. Initialize Terraform using the local backend:
```hcl
terraform init
```

#### 3. Create the backend resources (S3 bucket and DynamoDB table):

```hcl
terraform apply
```

At this stage:

* Terraform state is stored locally
* S3 bucket is created
* DynamoDB lock table is created

### Step 2: Enable Remote Backend (S3 + DynamoDB)

#### 1. Uncomment the backend block in main.tf.

#### 2. Reinitialize Terraform to enable the remote backend:
```
terraform init
```

Use -migrate-state if Terraform prompts to migrate state.

#### Step 3: Continue normal Terraform workflow:

```
terraform plan
terraform apply
```

### Now:

* Terraform state is stored in S3
* State locking is handled by DynamoDB
* Configuration is safe for team and CI/CD usage

### Notes
* Backend resources must exist before enabling the backend
* Backend configuration does not create resources
* DynamoDB is used only for Terraform state locking