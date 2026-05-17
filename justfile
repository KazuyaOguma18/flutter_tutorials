set shell := ["bash", "-cu"]

# 対象プロジェクト。優先順: PROJECT env > .active-project ファイル > デフォルト
# 切替は `just project set <name>`、確認は `just project [get]`
export PROJECT := env_var_or_default("PROJECT", `cat .active-project 2>/dev/null || echo projects/01_counter_freezed`)

mod gen 'just/gen.just'
mod build 'just/build.just'
mod upgrade 'just/upgrade.just'
mod init 'just/init.just'
mod project 'just/project.just'

# レシピの 1 文字エイリアス
alias g := get
alias t := test
alias a := analyze
alias f := fmt
alias c := clean
alias r := run
alias s := serve

# 利用可能なタスク一覧
default:
    @just --list

# pubspec.yaml に従って依存を取得
get:
    cd "$PROJECT" && flutter pub get

test *args:
    cd "$PROJECT" && flutter test {{args}}

analyze:
    cd "$PROJECT" && flutter analyze

fmt:
    cd "$PROJECT" && dart format .

clean:
    cd "$PROJECT" && flutter clean

# Chrome で起動 / `just run linux` で Linux desktop
run device='chrome':
    cd "$PROJECT" && flutter run -d {{device}}

# devcontainer 等で Web をブラウザから開きたい時用 (要ポート Forward)
serve port='8080':
    cd "$PROJECT" && flutter run -d web-server --web-port={{port}} --web-hostname=0.0.0.0
