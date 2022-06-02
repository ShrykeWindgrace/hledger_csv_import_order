with import <nixpkgs> {};

(mkShell.override {stdenv = stdenvNoCC;} ) {
    name = "hledger";
    buildInputs = [
        hledger
        # cross-shell version of an alias
        # this version loses autocompletion, but hledger does not provide it anyway
        (writeShellScriptBin ''h'' ''hledger "$@"'')
    ];
    shellHook = "
        export LEDGER_FILE=test.journal
    ";
}
