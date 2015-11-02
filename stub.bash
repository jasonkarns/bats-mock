stub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  shift

  export "${prefix}_STUB_PLAN"="${BATS_TMPDIR}/${program}-stub-plan"
  export "${prefix}_STUB_RUN"="${BATS_TMPDIR}/${program}-stub-run"
  export "${prefix}_STUB_END"=

  mkdir -p "${BATS_TMPDIR}/bin"
  ln -sf "${BATS_TEST_DIRNAME}/stubs/stub" "${BATS_TMPDIR}/bin/${program}"

  touch "${BATS_TMPDIR}/${program}-stub-plan"
  for arg in "$@"; do printf "%s\n" "$arg" >> "${BATS_TMPDIR}/${program}-stub-plan"; done
}

unstub() {
  local program="$1"
  local prefix="$(echo "$program" | tr a-z- A-Z_)"
  local path="${BATS_TMPDIR}/bin/${program}"

  export "${prefix}_STUB_END"=1

  local STATUS=0
  "$path" || STATUS="$?"

  rm -f "$path"
  rm -f "${BATS_TMPDIR}/${program}-stub-plan" "${BATS_TMPDIR}/${program}-stub-run"
  return "$STATUS"
}
