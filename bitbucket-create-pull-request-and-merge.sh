#!/usr/bin/env bash

echo -n Git Account:
read account
echo -n Git Username:
read username
echo -n Git Password:
read -s password

repositories=(
    "addon-dto"
    "addon-batch"
    "addon-formatter"
    "addon-data"
    "addon-billing"
    "addon-auth"
    "addon-signature"
    "addon-administration"
    "addon-validator"
    "addon-files"
)

echo ""

for repo in "${repositories[@]}"

do
    echo ${repo}

    result=`curl -u ${username}:${password} -H "Content-Type: application/json" https://api.bitbucket.org/2.0/repositories/${account}/${repo}/pullrequests  -X POST --data '{"title":"Automated Integration: develop -> master", "close_source_branch":false, "source":{"branch":{"name":"develop"}}, "destination":{"branch":{"name":"master"}}}'`

    typeResponse=`echo ${result} | jq '.type'`

    if [[ ${typeResponse} != "\"error\"" ]]; then

        pullRequestId=`echo ${result} | jq '.id | tonumber'`

        echo "Pull request ID: ${pullRequestId}"

        result=`curl -u ${username}:${password} https://api.bitbucket.org/2.0/repositories/${account}/${repo}/pullrequests/${pullRequestId}/merge -X POST `

        mergeRequestState=`echo ${result} | jq '.state'`

        echo "Merge Request State: ${mergeRequestState}"

    else

        echo "Up to date"

        echo ""
    fi

done





