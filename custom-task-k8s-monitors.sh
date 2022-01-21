
alias mybjes="kubectl get namespaces | grep "bje-" | wc -l"
alias mylrs="kubectl get namespaces | grep "lrs-" | wc -l"
alias my-report='echo "lrs: $(mylrs), bje: $(mybjes)"'


RECENT_CMD="kubectl get pods -A | grep -E \"(lrs-|bje-)\" | awk 'match(\$6,/^(([0-2]?[0-9]m)|([0-9]+s))/) {print \$0}'"


alias recent-lrs="${RECENT_CMD}"

function watch-recent() {
    watch "${RECENT_CMD}"
}
