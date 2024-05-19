resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "master_user_secret" {
  name = "db-${var.db_name}-url-secret"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "master_user_secret_version" {
  secret_id     = aws_secretsmanager_secret.master_user_secret.id
  secret_string = "${var.db_engine}://${aws_db_instance.db.username}:${random_password.password.result}@${aws_db_instance.db.address}:${var.db_port}/${var.db_name}"

  depends_on = [
    aws_db_instance.db
  ]
}

resource "aws_iam_policy" "db_secret_policy" {
  name = "db-${var.db_name}-secret-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:*",
        ]
        Resource = "arn:aws:secretsmanager:*:*:secret:db-${var.db_name}-url-secret-*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "db_secret_policy_attachment" {
  role       = "${var.db_name}-service-account-role"
  policy_arn = aws_iam_policy.db_secret_policy.arn

  depends_on = [
    aws_iam_policy.db_secret_policy
  ]
}
