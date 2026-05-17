# Freezed / json_serializable などの build_runner 系

[private]
_runner mode:
    cd "$PROJECT" && dart run build_runner {{mode}} --delete-conflicting-outputs

# 一回限りの生成
build: (_runner "build")

# ファイル変更を監視して継続的に生成
watch: (_runner "watch")

# 生成物を全削除
clean:
    cd "$PROJECT" && dart run build_runner clean

# 全削除 → 再生成
rebuild: clean build
