#!/bin/sh

main() {
  [ $# -lt 1 ] && run_cli
  case "$1" in
    --exec) exec ${@:2};;
    *) run_cli "$@";;
  esac
}

run_cli() {
  export NEW_RELIC_CONFIG_FILE
  if [ -n "${NEW_RELIC_LICENSE_KEY}" ]; then
    echo "Running with New Relic monitoring..."
    exec newrelic-admin run-program python {{cookiecutter.project_slug}}/cli.py "$@"
  else
    exec python {{cookiecutter.project_slug}}/cli.py "$@"
  fi
}

main "$@"
