# `just build` (= web) / `just build web` / `just build linux`

web: (_build "web")

linux: (_build "linux")

[private]
_build target:
    cd "$PROJECT" && flutter build {{target}}
