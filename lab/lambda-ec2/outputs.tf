output "invoke_arn" {
  value = {
    for function_key, function in aws_lambda_function.functions :
    function_key => ({
      "function_name" = function.function_name
      "invoke_arn"    = function.invoke_arn
    })
  }
}
