include {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = [
      "../common",
      "../iam",
      "../asg",
      "../certs",
      "../security-groups",
    ]
  }

