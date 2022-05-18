resource "aws_api_gateway_rest_api" "url_shortner_api" {
  name        = "URLShortener"
  description = "This is my API for url shortner"
}

resource "aws_api_gateway_deployment" "url_shortner_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
}

resource "aws_api_gateway_stage" "url_shortner_api_stage" {
  deployment_id = aws_api_gateway_deployment.url_shortner_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  stage_name    = "dev"
}

output "API_URL" {
  value = aws_api_gateway_stage.url_shortner_api_stage.invoke_url
}
