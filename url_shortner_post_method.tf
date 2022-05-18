resource "aws_api_gateway_resource" "url_shortner_post_resource" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  parent_id   = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  path_part   = "url-shortner"
}

resource "aws_api_gateway_method" "url_shortner_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id   = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "url_shortner_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id             = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method             = aws_api_gateway_method.url_shortner_post_method.http_method
  integration_http_method = aws_api_gateway_method.url_shortner_post_method.http_method
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-south-1:dynamodb:action/UpdateItem"
  credentials             = aws_iam_role.url_shortner_api_role.arn

  request_templates = {
    "application/json" = <<EOF
    {
        "TableName": "URL-Shortener",
        "ConditionExpression": "attribute_not_exists(id)",
        "Key": {
            "shortId": {
                "S": $input.json('$.shortURL')
            }
        },
        "ExpressionAttributeNames": {
            "#u": "longURL",
            "#o": "owner"
        },
        "ExpressionAttributeValues": {
            ":u": {
                "S": $input.json('$.longURL')
            },
            ":o": {
                "S":  $input.json('$.owner')
            }
        },
        "UpdateExpression": "SET #u = :u, #o = :o",
        "ReturnValues": "ALL_NEW"
    }
    EOF
  }
}

resource "aws_api_gateway_method_response" "url_shortner_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method = aws_api_gateway_method.url_shortner_post_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "url_shortner_post_api_response_integration" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.url_shortner_post_resource.id
  http_method = aws_api_gateway_method.url_shortner_post_method.http_method
  status_code = aws_api_gateway_method_response.url_shortner_post_response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = <<EOF
        #set($DDBResponse = $input.path('$'))
        {
            "shortURL": "$DDBResponse.Attributes.shortId.S",
            "longURL": "$DDBResponse.Attributes.longURL.S",
            "owner": "$DDBResponse.Attributes.owner.S"
        }
        EOF
  }
}
