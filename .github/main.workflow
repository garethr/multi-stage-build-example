workflow "Quality" {
  on = "push"
  resolves = ["check", "test", "lint", "validate"]
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

action "build" {
  uses = "actions/docker/cli@master"
  args = "build -t sample ."
}

action "validate" {
  uses = "actions/docker/cli@master"
  needs = "build"
  args = "run -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`/structure-tests.yaml:/tmp/tests.yaml gcr.io/gcp-runtimes/container-structure-test test --image sample --config /tmp/tests.yaml"
}

