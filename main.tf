terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.token
}

resource "github_repository" "git" {
  name        = "terraform-github-repo"
  description = "My awesome web page"
  visibility  = "public"
  auto_init   = true
}
resource "github_repository_file" "file" {
  repository = github_repository.git.name
  file       = "test.html"
  branch     = "main"
  content    = "Hello world!!!!!!"
}
resource "github_branch" "gitbranch" {
  repository    = "terraform-github-repo"
  branch        = "development"
  source_branch = "main"
  depends_on    = [github_repository_file.file]
}
resource "github_branch_protection" "protect" {
  pattern       = "main"
  repository_id = github_repository.git.name

}
data "github_repository" "data_git" {
  name = "terraform-github-repo"

}
output "name" {
  value = data.github_repository.data_git.repo_id
}