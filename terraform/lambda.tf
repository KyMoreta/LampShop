resource "aws_iam_role" "iam_for_lambda" {
  name = "myHtmlFunctionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    git_commit           = "5701ae6abe3539312d7f701e8b585f10e26baf59"
    git_file             = "terraform/lambda.tf"
    git_last_modified_at = "2022-05-10 15:53:13"
    git_last_modified_by = "niftyshorts@gmail.com"
    git_modifiers        = "niftyshorts"
    git_org              = "GBaileyMcEwan"
    git_repo             = "lambdaapp"
    yor_trace            = "f44cb890-b0b8-479f-b815-aacf9fb2eef3"
  }
}

resource "aws_lambda_function" "myHtmlFunction2" {
  # checkov:skip=806755667406840832_AWS_1676466381910: ADD REASON
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "myHtmlFunction.zip"
  function_name = "myHtmlFunction2"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("myHtmlFunction.zip")

  runtime = "python3.8"

  tags = {
    Name                 = "GordonRockABS"
    yor_trace            = "9c46e110-f6f5-4cab-8070-9c5125a3e2e0"
    git_commit           = "d32ae52822f73509e5611e19f43fe00e6b67872d"
    git_file             = "terraform/lambda.tf"
    git_last_modified_at = "2023-04-07 11:22:00"
    git_last_modified_by = "niftyshorts@gmail.com"
    git_modifiers        = "niftyshorts"
    git_org              = "GBaileyMcEwan"
    git_repo             = "lambdaapp"
  }
}


# resource "aws_lambda_function_url" "myHtmlFunctionURLAuth" {
#   function_name      = "myHtmlFunction2"
#   authorization_type = "NONE"

#   depends_on = [aws_lambda_function.myHtmlFunction2]
# }

resource "null_resource" "replaceNginxFunctionURL" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    //command = "sed -i 's/MYFUNCTIONURL/${aws_lambda_function_url.myHtmlFunctionURLAuth.function_url}/g' ../nginx/index.html"
    # command = <<-EOT
    #GORDON="${aws_lambda_function_url.myHtmlFunctionURLAuth.function_url}"
    #sed -i "s|MYFUNCTIONURL|$GORDON|" ../nginx/index.html
    #EOT
    command = <<-EOT
GORDON="https://jiygj809q8.execute-api.af-south-1.amazonaws.com/prod/"
sed -i "s|MYFUNCTIONURL|$GORDON|" ../nginx/index.html
EOT
  }
  #depends_on = [aws_lambda_function_url.myHtmlFunctionURLAuth]

}

# output "functionURL" {
#   description = "Lambda Function URL"
#   value       = aws_lambda_function_url.myHtmlFunctionURLAuth.function_url

#   depends_on = [aws_lambda_function_url.myHtmlFunctionURLAuth]
# }