#!/usr/bin/env bash
set -e

HELM_REPO="helm.regelcloud.com"
charts=$(basename charts/*)

RELEASE_VERSION_MAJOR=$(cut -d'.' -f1 < release)
RELEASE_VERSION_MINOR=$(cut -d'.' -f2 < release)
RELEASE_VERSION_PATCH=$(cut -d'.' -f3 < release)

echo "[INFO] Current release version = ${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.${RELEASE_VERSION_PATCH}"
echo "[INFO] New release version = ${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.$(expr ${RELEASE_VERSION_PATCH} + 1)"
RELEASE_VERSION_LATEST="${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.$(expr ${RELEASE_VERSION_PATCH} + 1)"
echo "${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.$(expr ${RELEASE_VERSION_PATCH} + 1)" > release

for chart in ${charts}
do 
    echo "${chart}"
    sed  -i '' "s/version:.*/version: ${RELEASE_VERSION_LATEST}/g" charts/"${chart}"/Chart.yaml
done

git pull
git add .
git commit -m "Updated helm charts version: ${RELEASE_VERSION_LATEST}"
git push
echo "[INFO] Success build & push to ${HELM_REPO}: ${RELEASE_VERSION_LATEST}"
