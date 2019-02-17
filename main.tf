resource "aws_budgets_budget" "monthly_budget" {
  name         = "Maximum monthly expenses"
  limit_amount = "${var.amount}"

  time_unit   = "MONTHLY"
  budget_type = "COST"
  limit_unit  = "USD"
}

locals {
  month_in_secs = "21600"
}

resource "aws_cloudwatch_metric_alarm" "monthly_charges" {
    alarm_name = "Total monthly charges (max. ${var.amount})"

    provider = "aws.us-east-1"
    namespace = "AWS/Billing"
    metric_name = "EstimatedCharges"
    comparison_operator = "GreaterThanThreshold"
    dimensions { "Currency" = "USD" }
    threshold = "${var.amount}"
    period = "${locals.month_in_secs}"
    alarm_actions = [ "${aws_sns_topic.billing.arn}" ]

    statistic = "Maximum"
    evaluation_periods = "1"
}
