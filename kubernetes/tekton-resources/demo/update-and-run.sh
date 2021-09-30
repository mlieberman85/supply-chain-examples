#!/usr/bin/env bash
set -u
set -e

remove_old_charts() {
    kubectl delete -k . || true
    ##TODO constraints need time for template CRD's to start before they can be applied
    kubectl delete -f constraint-templates/gatekeeper-constraints.yaml || true
}

install_new_charts() {
    kubectl apply -k . || true
    echo "Wait 5 seconds for gatekeeper-constraint-templates to become available"
    sleep 5
    ##TODO constraints need time for template CRD's to start before they can be applied
    kubectl apply -f constraint-templates/gatekeeper-constraints.yaml || true
}


main(){
    remove_old_charts "$@"
    install_new_charts "$@"
}

main "$@"
