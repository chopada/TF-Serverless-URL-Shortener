# **Serverless URL Shortener**

A serverless implementation of an URL Shortener Service without AWS Lambda Functions

## The AWS Serverless Ecosystem

> Serverless is a way to describe the services, practices, and strategies that enable you to build more agile applications so you can innovate and respond to change faster. With serverless computing, infrastructure management tasks like capacity provisioning and patching are handled by AWS, so you can focus on only writing code that serves your customers.

**Serverless Computing = FaaS [Functions as a Service] + BaaS [Backend as a Service]**

### Serverless Services of AWS

* **Compute:** AWS Lambda, AWS Fargate
* **Storage:** Amazon DynamoDB, Amazon S3, etc.
* **Application Integration:** Amazon API Gateway, etc.

## **Introduction**

We have developed an URL Shortener Service using various services of the AWS Serverless Ecosystem. We are going to focus mainly on the backend of the application.

To implement our project in a simplified way, we will use only the 2 most important services: the **API Gateway** and **DynamoDB**.

The main benifit is we can implementaion this simple url shortening without lambda funtion.

![abc](https://dashbird.io/wp-content/uploads/2020/10/api-gateway-proxy-database-architecture-diagram-1.gif)

I have written it completely in **Terraform**

## Deployment Instructions

### Authentication

Create AWS Profile `terraform_admin`

```
$ aws configure --profile terraform_admin

AWS Access Key ID: yourID
AWS Secret Access Key: yourSecert
Default region name : aws-region
Default output format : env
```

### Deployment

Run following commands in root directory of project

```
terraform init
terraform apply
```

Output

```
API_URL = "https://<API_ID>.execute-api.ap-south-1.amazonaws.com/dev"
GET_URL_SHORTENER = "/url-shortener/{shortId}"
POST_URL_SHORTENER = "/url-shortener"
```

### Testing

Do post api call to\
 `https://<API_ID>.execute-api.ap-south-1.amazonaws.com/dev/url-shortener`

Request Body:

```
{
  "longURL": "https://halfsquare.in",
  "owner": "Tushar",
  "shortURL": "Halfsquare"
}
```

Response:

```
{
  "shortURL": "Halfsquare",
  "longURL": "https://halfsquare.in",
  "owner": "Tushar"
}
```

Short url is generated now you can hit GET call or go to the folowing link in your browser\
`https://<API_ID>.execute-api.ap-south-1.amazonaws.com/dev/url-shortener/<SHORT_ID>`\
In our case SHORT_ID is `Halfsquare`

### Delete Deployment

Run following command

```
terraform destroy
```
