set shell := ["bash", "-cu"]

# 対象プロジェクト。`just PROJECT=projects/02_xxx get` のように上書き可能
export PROJECT := env_var_or_default("PROJECT", "projects/01_counter_freezed")

mod gen
mod build
mod upgrade
mod init

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
