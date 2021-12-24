#!/usr/bin/env bash
set -e

HELM_REPO="helm.regelcloud.com"
charts=$(basename charts/*)

while getopts c: flag
do
    case "${flag}" in
        c) chart=${OPTARG};;
    esac
done

if [ -z $chart ] ; then
    echo "Enter valid chart name: ${charts}"
    exit 1
fi



RELEASE_VERSION_MAJOR=$(cat charts/${chart}/Chart.yaml | grep -w 'version:' | cut -d ':' -f2 | cut -d '.' -f1)
RELEASE_VERSION_MINOR=$(cat charts/${chart}/Chart.yaml | grep -w 'version:' | cut -d ':' -f2 | cut -d '.' -f2)
RELEASE_VERSION_PATCH=$(cat charts/${chart}/Chart.yaml | grep -w 'version:' | cut -d ':' -f2 | cut -d '.' -f3)


APP_VERSION_MAJOR=$(cat charts/${chart}/Chart.yaml | grep -w 'appVersion:' | cut -d ':' -f2 | cut -d '.' -f1)
APP_VERSION_MINOR=$(cat charts/${chart}/Chart.yaml | grep -w 'appVersion:' | cut -d ':' -f2 | cut -d '.' -f2)
APP_VERSION_PATCH=$(cat charts/${chart}/Chart.yaml | grep -w 'appVersion:' | cut -d ':' -f2 | cut -d '.' -f3)

echo "[INFO] Current release version = ${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.${RELEASE_VERSION_PATCH}"
echo "[INFO] New release version = ${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.$(expr ${RELEASE_VERSION_PATCH} + 1)"
echo "[INFO] New app version = ${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.$(expr ${RELEASE_VERSION_PATCH} + 1)"

RELEASE_VERSION_LATEST="${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.$(expr ${APP_VERSION_PATCH} + 1)"
APP_VERSION_LATEST="${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.$(expr ${APP_VERSION_PATCH} + 1)"

echo "${RELEASE_VERSION_MAJOR}.${RELEASE_VERSION_MINOR}.$(expr ${RELEASE_VERSION_PATCH} + 1)" 

for c in ${charts}
do 
    if [[ ${chart} -eq $c ]]; then
        echo "${chart}"
        sed  -i '' "s/version:.*/version: ${RELEASE_VERSION_LATEST}/g" charts/"${chart}"/Chart.yaml
        sed  -i '' "s/appVersion:.*/appVersion: ${APP_VERSION_LATEST}/g" charts/"${chart}"/Chart.yaml
        git pull
        git add .
        git commit -m "Updated helm chart ${chart} to version: ${RELEASE_VERSION_LATEST}"
        git push
        echo "[INFO] Success build & push to ${HELM_REPO}/${chart} ${RELEASE_VERSION_LATEST}"
    fi
done
