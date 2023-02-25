resource "google_service_account" "define_service_account" {
  for_each = var.service_accounts
  account_id   = each.key #"default-vm-sa"
  display_name = each.key #"sa-management-vm"
}
resource "google_project_iam_member" "role-binding" {
  for_each = var.service_accounts
  project = var.project_name #"ahmed-nasr-iti-demo"
  role    = each.value #"roles/container.admin"
  member  = "serviceAccount:${google_service_account.define_service_account[each.key].email}"
}
