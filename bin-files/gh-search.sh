
# gh auth login
gh auth status

gh api \
  -H "Accept: application/vnd.github.text-match+json" \
  "/search/code?per_page=100&q=org%3Adatarobot+%22Custom%20Task%20Prediction%20Made%22" \
  | tee >(jq .total_count > tmp.txt) | jq '.items[] | .html_url, .text_matches' \
  && echo "TOTAL: $(cat tmp.txt)" && rm tmp.txt

#curl -s\
#  -H "Accept: application/vnd.github+json" \
#  -H "Authorization: Bearer ${token}" \
#  "https://api.github.com/search/code?q=org%3Adatarobot+%22Custom+Task+Prediction+Made%22" \
  #| jq '.items'
  #"https://api.github.com/search/code?q=queue-exec-manager-batch-job-execution+org%3Adatarobot" \
  #"https://api.github.com/search/code?q=execmanagerbje+org%3Adatarobot" \
