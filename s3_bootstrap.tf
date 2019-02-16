
resource "aws_s3_bucket_object" "web_server" {
  bucket = "${var.ops_bucket_name}"
  key    = "web_server_dev/index.html"
  source = "ops_files/index.html"
  etag   = "${md5(file("ops_files/index.html"))}"
}
resource "aws_s3_bucket_object" "web_server_dev" {
  bucket = "${var.ops_bucket_name}"
  key    = "web_server_dev/bootstrap.sh"
  source = "ops_files/bootstrap.sh"
  etag   = "${md5(file("ops_files/bootstrap.sh"))}"
}
