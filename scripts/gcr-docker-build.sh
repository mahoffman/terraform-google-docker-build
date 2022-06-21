#!/bin/bash -e
TOKEN=${1}
TAG=${2}
GCP_PROJECT=${3}
CONTEXT=${4}
PLATFORM=${5}
CLOUD_BUILD=${6}
GCP_REGION=${7}

if [ "${CLOUD_BUILD}" == "false" ]
then
    echo ${TOKEN} | docker login -u oauth2accesstoken --password-stdin https://gcr.io || true
    docker build --platform ${PLATFORM} -t gcr.io/${GCP_PROJECT}/${TAG} ${CONTEXT}
    docker push gcr.io/${GCP_PROJECT}/${TAG}
else
    gcloud builds submit --project ${GCP_PROJECT} --region ${GCP_REGION} --tag gcr.io/${GCP_PROJECT}/${TAG} ${CONTEXT} --timeout "1200"
fi
