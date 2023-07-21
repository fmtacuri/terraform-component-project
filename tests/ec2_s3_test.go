package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
  )
  
  // Standard Go test, with the "Test" prefix and accepting the *testing.T struct.
  func TestS3EC2(t *testing.T) {
	// I work in eu-west-2, you may differ
	awsRegion := "us-west-2"
    //fileContent := ""
	// This is using the terraform package that has a sensible retry function.
	terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
	  // Our Terraform code is in the /aws folder.
	  TerraformDir: "../main",
  
	  Vars: map[string]interface{}{},
  
	  // Setting the environment variables, specifically the AWS region.
	  EnvVars: map[string]string{
		"AWS_DEFAULT_REGION": awsRegion,
	  },
	})
  
	// We want to destroy the infrastructure after testing.
	defer terraform.Destroy(t, terraformOpts)
  
	// Deploy the infrastructure with the options defined above
	terraform.InitAndApply(t, terraformOpts)

	// Get the bucket ID so we can query AWS
	bucketID := terraform.Output(t, terraformOpts, "bucket_id")

	// Get the EC2 Instance ID so we can query AWS
	instanceID := terraform.Output(t, terraformOpts, "instance_id")

	// check exists bucket AWS S3
	aws.AssertS3BucketExists(t, awsRegion, bucketID)
	// check exists instance EC2
	assert.Contains(t, instanceID, "Flugel")
  }