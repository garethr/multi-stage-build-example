workflow "Quality" {
  on = "push"
  resolves = ["check", "test", "lint"]
}

action "check" {
  uses = "actions/docker/cli@master"
  args = "build --target check ."
}

action "test" {
  uses = "actions/docker/cli@master"
  args = "build --target test ."
}

action "lint" {
  uses = "actions/docker/cli@master"
  args = "run -i hadolint/hadolint hadolint --ignore SC2035 - < Dockerfile"
}

