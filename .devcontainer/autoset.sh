# cwd が */projects/<name>/... 配下のとき PROJECT=projects/<name> を自動 export
_flutter_proj() {
    case "$PWD" in
        */projects/*) p="${PWD#*/projects/}"; export PROJECT="projects/${p%%/*}" ;;
        *) unset PROJECT ;;
    esac
}
PROMPT_COMMAND="_flutter_proj;${PROMPT_COMMAND:-}"
