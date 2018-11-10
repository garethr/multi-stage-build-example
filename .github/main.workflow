workflow "Quality" {
  on = "push"
  resolves = ["check"]
}

action "check" {
  uses = "actions/docker/cli@master"
  args = "build --target check ."
}
