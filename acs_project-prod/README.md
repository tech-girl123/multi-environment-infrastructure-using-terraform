# acs_project
In this project we will deploy different environments such as dev, prod, staging with the features of auto scaling and load balancing.
To successfully deploy the 2-tier static website follow the following steps:
pre-requisite - S3 bucket for each environment i.e., dev, prod, staging in the respective directories using the command given: ssh-keygen -t rsa -g dev-key, 
ssh-keygen -t rsa -g prod-key
ssh-keygen -t rsa -g staging-key
Lastly, change the locations wherever necessary, for-example,insert the path of new s3-bucket.
Start deploying for dev network with commands 
tf init
tf validate
tf plan
tf apply --auto-approve.
For dev webserver with commands 
tf init
tf validate
tf plan
tf apply --auto-approve.
Then the dns name of the static website is available as the output, then the website is visible with the names of the group members :)
