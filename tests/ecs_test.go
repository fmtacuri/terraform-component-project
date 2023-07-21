package tests

import (
	"testing"
	"crypto/tls"
	"fmt"
	"time"
	
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
  )
  
  // Standard Go test, with the "Test" prefix and accepting the *testing.T struct.
  func TestECS(t *testing.T) {
	// I work in eu-west-2, you may differ
	awsRegion := "us-west-2"
    //fileContent := ""
	// This is using the terraform package that has a sensible retry function.
	terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
	  // Our Terraform code is in the /aws folder.
	  TerraformDir: "../main",
  
	  // This allows us to define Terraform variables. We have a variable named
	  // "bucket_name" which essentially is a suffix. Here we are are using the
	  // random package to get a unique id we can use for testing, as bucket names
	  // have to be unique.
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

	// Get the DNS so we can query AWS
	dnsalb := terraform.Output(t, terraformOpts, "nginx_dns_lb")

	time.Sleep(120 * time.Second)

	tlsConfig := tls.Config{}
	statusCode, body := http_helper.HttpGet(t, fmt.Sprintf("http://%s", dnsalb), &tlsConfig)

	// check exists bucket AWS S3
	aws.AssertS3BucketExists(t, awsRegion, bucketID)
	// check exists instance EC2
	assert.Contains(t, instanceID, "Flugel")

	assert.Equal(t, 200, statusCode)
	assert.NotNil(t, body)

  }