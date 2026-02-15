#!/bin/bash

FRONTEND_IP=$(terraform -chdir=../terraform output -raw frontend_ip 2>/dev/null)
BACKEND_IP=$(terraform -chdir=../terraform output -raw backend_ip 2>/dev/null)

if [[ "$1" == "--list" ]]; then
cat <<EOF
{
  "frontend": {
    "hosts": ["c8.local"]
  },
  "backend": {
    "hosts": ["u21.local"]
  },
  "_meta": {
    "hostvars": {
      "c8.local": {
        "ansible_host": "$FRONTEND_IP",
        "ansible_user": "ec2-user"
      },
      "u21.local": {
        "ansible_host": "$BACKEND_IP",
        "ansible_user": "ubuntu"
      }
    }
  }
}
EOF
else
  echo "{}"
fi
