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
  secret_string = "${var.db_engine}://${var.db_username}:${random_password.password.result}@${aws_docdb_cluster_instance.db_instance.endpoint}:${var.db_port}/?tls=true&tlsCAFile=global-bundle.pem&retryWrites=false"

  depends_on = [
    aws_docdb_cluster.db
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
}

resource "aws_iam_policy" "db_cluster_policy" {
  name = "db-${var.db_name}-cluster-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "docdb:*",
          "rds:*"
        ]
        Resource = aws_docdb_cluster_instance.db_instance.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "db_cluster_policy_attachment" {
  role       = "${var.db_name}-service-account-role"
  policy_arn = aws_iam_policy.db_cluster_policy.arn
}
