{
  "action": [
    {
      "check": [
        {
          "args": "build --target check .",
          "uses": "actions/docker/cli@master"
        }
      ]
    },
    {
      "test": [
        {
          "args": "build --target test .",
          "uses": "actions/docker/cli@master"
        }
      ]
    },
    {
      "security": [
        {
          "args": "build --target security --build-arg MICROSCANNER=${MICROSCANNER} .",
          "secrets": [
            "MICROSCANNER"
          ],
          "uses": "actions/docker/cli@master"
        }
      ]
    },
    {
      "lint": [
        {
          "args": "run -i hadolint/hadolint hadolint --ignore SC2035 - \u003c Dockerfile",
          "uses": "actions/docker/cli@master"
        }
      ]
    },
    {
      "build": [
        {
          "args": "build -t sample .",
          "uses": "actions/docker/cli@master"
        }
      ]
    },
    {
      "validate": [
        {
          "args": "test --image sample --config structure-tests.yaml",
          "needs": "build",
          "uses": "docker://gcr.io/gcp-runtimes/container-structure-test"
        }
      ]
    }
  ],
  "workflow": [
    {
      "Quality": [
        {
          "on": "push",
          "resolves": [
            "check",
            "test",
            "lint",
            "security",
            "validate"
          ]
        }
      ]
    }
  ]
}
