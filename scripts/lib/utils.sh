#!/usr/bin/env bash
set -euo pipefail

color() { # usage: color "<ansi>" "<msg>"
  printf "%b%s%b\n" "$1" "$2" "\e[0m"
}
info() { color "\e[34m" "$*"; }
ok() { color "\e[32m" "$*"; }
warn() { color "\e[33m" "$*"; }
fail() { color "\e[31m" "$*"; }

http_status() { # usage: http_status <curl-args...>
  curl -sS -o /dev/null -w '%{http_code}' "$@"
}

expect_status() { # usage: expect_status <expected> <curl-args...>
  local expected="$1"
  shift
  local got
  got="$(http_status "$@")"
  if [[ $got == "$expected" ]]; then
    ok "[PASS] $* → $got"
  else
    fail "[FAIL] $* → expected $expected, got $got"
    exit 1
  fi
}

retry() { # usage: retry <retries> <sleep_seconds> <cmd...>
  local -r retries="$1" delay="$2"
  shift 2
  local attempt=1
  until "$@"; do
    if ((attempt >= retries)); then return 1; fi
    sleep "$delay"
    attempt=$((attempt + 1))
  done
}

wait_http_ok_with_token() { # usage: wait_http_ok_with_token <url> <token>
  local url="$1" token="$2"
  info "Waiting for 200 OK at $url"
  retry 120 1 curl -sfI --header "Authorization: Bearer $token" "$url" >/dev/null
}

find_pod_by_label() { # usage: find_pod_by_label <namespace> <label>
  local ns="$1" label="$2"
  kubectl -n "$ns" get pod -l "$label" -o jsonpath='{.items[0].metadata.name}'
}

exec_pod_http_status() { # usage: exec_pod_http_status <ns> <pod> <curl-args...>
  local ns="$1" pod="$2"
  shift 2
  kubectl -n "$ns" exec "$pod" -- curl -sS -o /dev/null -w '%{http_code}' "$@"
}

expect_pod_status() { # usage: expect_pod_status <expected> <ns> <pod> <curl-args...>
  local expected="$1" ns="$2" pod="$3"
  shift 3
  local got
  got="$(exec_pod_http_status "$ns" "$pod" "$@")"
  if [[ $got == "$expected" ]]; then
    ok "[PASS] ($ns/$pod) $* → $got"
  else
    fail "[FAIL] ($ns/$pod) $* → expected $expected, got $got"
    exit 1
  fi
}
