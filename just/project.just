# プロジェクト管理: アクティブなプロジェクトの確認と切替
# 状態は .active-project に保存される (PROJECT env が設定されていればそちらが優先)

# 引数なしは get と同等
default: get

# 現在アクティブなプロジェクトを表示
get:
    @echo "$PROJECT"

# アクティブなプロジェクトを切り替える (例: `just project set 02_my_sample`)
set name:
    @echo "projects/{{name}}" > "{{justfile_directory()}}/.active-project"
    @echo "active: projects/{{name}}"
