# PROJECT で指定したディレクトリに各プラットフォームの足場ファイルを追加

[private]
_create *platforms:
    mkdir -p "$PROJECT" && cd "$PROJECT" && \
        flutter create . --platforms={{platforms}} \
            --org com.example.tutorials \
            --project-name "$(basename "$PROJECT")"

# Web + Linux 両対応
platforms: (_create "web,linux")

web: (_create "web")

linux: (_create "linux")
