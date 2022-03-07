#!/usr/bin/env bash

# see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones for timezones

CBOLD=$'\e[1;36m'
CRESET=$'\e[0m'

fdate() {
  local timezone="${1}"
  local localtz="$(date '+%Z')"
  local time="${2}"
  local format="+%a %d %b %Y  %H:%M:%S %Z"
  if [ -n "${time:-}" ]; then
    TZ=:${timezone} date -d "${time} ${localtz}" "${format}"
  else
    TZ=${timezone} date "${format}"
  fi
}

main() {
  local important=''
  local name=''
  local tzs=(
    0 'US/Pacific'
    1 'US/Mountain'
    0 'US/Central'
    1 'US/Eastern'
    0 'UTC'
    0 'Iceland'
    1 'Asia/Taipei'
    0 'Europe/Dublin'
    0 'Europe/Prague'
    0 'Europe/Vienna'
    1 'Europe/Kiev'
    0 'Europe/Helsinki'
    0 'Europe/Vilnius'
    0 'Europe/Tallinn'
  )

  (
    printf -- '  Timezone|Date/Time\n' "${delim}"
    printf -- '  --------|---------\n' "${delim}"

    for (( i=0; i<${#tzs[@]}; i++ )); do
      important="${tzs[$i]}"
      ((i += 1))

      name="  ${tzs[$i]}"
      [ "${important}" -eq 1 ] && name="${CBOLD}> ${tzs[$i]}${CRESET}"

      printf '%s|%s\n' "${name}" "$(fdate ${tzs[$i]} ${1:-})"
    done
  ) | column -t -s'|'
}
main ${@}
