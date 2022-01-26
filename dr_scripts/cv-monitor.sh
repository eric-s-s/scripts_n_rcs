CV_RES="null"
STATUS_CODE=""
PID="61f1751a658ad86f55491906"
LID="61f17aee6bb631facbb0e028"
QID="11"

TOKEN="XXX"
function watch-score () {
    while [[ "${CV_RES}" = "null" ]]; do
        sleep 10;
        CV_RES="$(curl --location --request GET "https://staging.datarobot.com/api/v2/projects/${PID}/models/${LID}" --header "Authorization: Bearer ${TOKEN}" | jq ".metrics.MAE.crossValidation ")"
        echo "$(date '+%T.%3N') cv res: ${CV_RES}"
    done
    echo "$(date '+%T.%3N') DONE"

}

function watch-header () {
    while [[ "${STATUS_CODE}" != "303" ]]; do
        sleep 10;
        STATUS_CODE="$(curl -o /dev/null -w "%{http_code}" --request GET "https://staging.datarobot.com/api/v2/projects/${PID}/modelJobs/${QID}/" --header "Authorization: Bearer ${TOKEN}")"
        echo "$(date '+%T.%3N') status ${STATUS_CODE}"
    done
    echo "$(date '+%T.%3N') status DONE"
}

