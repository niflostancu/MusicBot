#!/bin/bash
# Script for creating / modifying MusicBot ConfigMap on your k8s cluster

# Note: overwrite inside 'helm/deploy.local.sh'
KUBECONFIG=${KUBECONFIG:-}
K8S_NAMESPACE=default
MUSICBOT_CONFIGMAP=musicbot

# Config files to include inside the ConfigMap
CONFIG_FILES=(aliases.json autoplaylist.txt blacklist.txt options.ini
	permissions.ini whitelist.txt)

[[ -f "helm/deploy.local.sh" ]] && . helm/deploy.local.sh

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
FROM_FILES=()
for file in "${CONFIG_FILES[@]}"; do FROM_FILES+=("--from-file=$file=$SRCDIR/config/$file"); done

export KUBECONFIG
# dry-run trick for create or replace
kubectl -n "$K8S_NAMESPACE" create configmap "$MUSICBOT_CONFIGMAP" \
	"${FROM_FILES[@]}" --dry-run=client -o yaml | kubectl apply -f -

