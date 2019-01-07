
setup() {
    export TMP="$BATS_TEST_DIRNAME/tmp"
}

teardown() {
    [ -d "$TMP" ] && rm -fr "$TMP"/*
}
