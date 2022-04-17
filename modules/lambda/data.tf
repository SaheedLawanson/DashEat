data "archive_file" "create_dist_pkg" {
    for_each = var.functions
    source_dir = "${path.module}/functions/${each.key}"
    output_path = "${path.module}/zip/${each.key}.zip"
    type = "zip"
}