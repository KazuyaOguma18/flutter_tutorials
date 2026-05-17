# `just upgrade minor` で許容範囲内更新 / `just upgrade major` でメジャー含む更新

minor:
    cd "$PROJECT" && flutter pub upgrade

major:
    cd "$PROJECT" && flutter pub upgrade --major-versions
