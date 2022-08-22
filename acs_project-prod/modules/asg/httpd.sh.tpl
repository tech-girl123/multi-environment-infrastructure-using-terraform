#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

echo "<html>
<head>
    
    
</head>
<body>
    <h1>Welcome to the project of ACS730 :)</h1> 
    <h4>Project completed by Group Members-</h4>
    <h4>Muskan Katariya</h4>
    <h4>Raj Patel</h4>
    <h4>Bhavik Bhanushali</h4>
    <h4>Hasan Bukhari</h4>
    <img src="s3://prod-acs730-project-group13/image/1.jpg" >
</body>
</html>" > /var/www/html/index.html
