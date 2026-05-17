# `just build` (デフォルトは web) / `just build web` / `just build linux`

[private]
_build target:
    cd "$PROJECT" && flutter build {{target}}

# デフォルトは web ビルド
default: web

web: (_build "web")

linux: (_build "linux")
