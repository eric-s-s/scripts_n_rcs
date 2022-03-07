#!/bin/bash

####################################################################################################
# Run black, and pylint on staged files in the DataRobot repository before committing.
#
# HOW TO SET UP:
# 1) Save this file to ~/workspace/DataRobot/.git/hooks
# 2) Make sure this file is executable: chmod +x ~/workspace/DataRobot/.git/hooks/pre-commit
#
# HOW TO CONFIGURE:
# If you work on a mac and want to run linter checks that require vagrant, change the value of the
# DR_CHECK_VAGRANT variable from "false" to "true"
: ${DR_CHECK_VAGRANT:=false}
#
# If your development is all business and you don't want emoji in your messages, change the
# value of the DR_PRE_COMMIT_EMOJI variable from "true" to "false"
: ${DR_PRE_COMMIT_EMOJI:=true}
#
# If for some reason you want to disable the pre-commit hook entirely (e.g. you are merging or
# rebasing files that do not pass linter checks), change the value of the DR_NO_VERIFY
# variable from "false" to "true"
: ${DR_NO_VERIFY:=false}
#
# THE GRITTY DETAILS:
# 1) Unlike the PR linter checks, these checks inspect the entire file, not just your changes. If
#    you are changing a file that has errors unrelated to your code, you'll see those. You could be
#    a good corporate citizen and fix them if they're simple, or just use the --no-verify option of
#    the git commit command to bypass all the hooks.
# 2) The black check will format all staged files, and then it will re-stage that entire list of
#    files. If a file has both staged and unstaged changes, the unstaged changes will be staged and
#    included in the commit. I don't think anybody works this way frequently, but this behavior is
#    something to be aware of.
# 3) If you're not running in a DataRobot virtual environment when you commit, the pylint checks
#    will fail. Most of us are running in a correct virtual environment when we commit though, so
#    this restriction shouldn't be a big deal.
# 4) If you are merging or rebasing code that does not pass linter checks, set the DR_NO_VERIFY
#    environment variable to temporarily skip the pre-commit hook.
#
#    export DR_NO_VERIFY=true
#    git --rebase -i master # or `git merge some-branch` or whatever
#    export DR_NO_VERIFY=false
####################################################################################################

if [[ "$DR_PRE_COMMIT_EMOJI" == "true" ]]; then
  # Trailing space makes it look nice
  DR_ERROR_EMOJI="💣 😵 💣 "
  DR_WORK_EMOJI="⚙️ 😐 ⚙️ "
  DR_THINK_EMOJI="💭 😐 💭 "
  DR_FAIL_EMOJI="🚫 😞 🚫 "
  DR_PASS_EMOJI="💕 🤖 💕 "
  DR_WELP_EMOJI="¯\_(ツ)_/¯ "
fi
: ${WORKSPACE:=$HOME/workspace}

if [[ "$DR_NO_VERIFY" == "true" ]]; then
  echo "Skipping pre-commit checks. (To re-enable checks, export DR_NO_VERIFY=false)"
  exit 0
elif [[ "$DR_NO_VERIFY" != "false" ]]; then
  echo "${DR_WELP_EMOJI}DR_NO_VERIFY is neither false nor true, so running pre-commit hooks..."
fi

check_vagrant() {
    # return string:
    #  skip if DR_CHECK_VAGRANT==false and on mac
    #  running if vagrant VM is running
    #  none otherwise
    if [[ "${DR_CHECK_VAGRANT}" == false || ! -f "${WORKSPACE}/Vagrantfile" ]]; then
        case ${OSTYPE} in
            linux*) vagrant=none;;
            darwin*) vagrant=skip;;
        esac
    else
        case $(vagrant status 2>/dev/null | fgrep default) in
            *running*) vagrant=running;;
            *) vagrant=none;;
        esac
    fi
    echo ${vagrant}
}

get_vagrant_workspace () {
    # returns the workspace directory for the enabled shared folder set inside
    # in the vagrant VM
    if [[ ! -f "${WORKSPACE}/vagrant.yml" ]]; then
        echo "Could not find path to ${WORKSPACE}/vagrant.yml. Make sure $WORKSPACE is correct."
    fi
    as='/enable: true/{enable="true"}$1=="  remote"&&enable=="true"{print $2;exit;}'
    awk -F': ' "$as" ${WORKSPACE}/vagrant.yml
}

portable_xargs_r() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    xargs "$@"
  elif [[ "$OSTYPE" == "linux"* ]]; then
    xargs -r "$@"
  else
    echo "${DR_ERROR_EMOJI}Unknown OS type. Aborting commit."
    exit 1
  fi
}

get_staged_files_to_process() {
    git diff $(git merge-base master HEAD) --name-only --diff-filter=d | grep \\.py$ | portable_xargs_r ls -d 2>/dev/null
}

process_precommit_checks() {
    FILES_LIST="$(get_staged_files_to_process)"

    if [[ -n $FILES_LIST ]]; then
      # Execute black to reformat all added/modified files that have been blackified
      RUNBLACK_CMD="./run_black.sh $FILES_LIST"
      echo "${DR_WORK_EMOJI}Formatting changed files with black..."
      $RUNBLACK_CMD
      BLACK_ERRORS=$?

      if [ $BLACK_ERRORS -ne 0 ]; then
        echo "${DR_ERROR_EMOJI}Black failed to format file(s). Aborting commit."
        exit $BLACK_ERRORS
      fi

      # Re-stage files that may have been changed by black
      git add $FILES_LIST

      # Re-fetch changed files in case all changes have been reformatted away
      FILES_LIST="$(get_staged_files_to_process)"
      echo $FILES_LIST
    else
      exit 0  # Return 0 to allow the commit to proceed, since it doesn't include Python files
    fi

    if [[ -n $FILES_LIST ]]; then
      # Execute drpythonlint to find linter errors
      # (Redirect standard error to /dev/null to suppress the pandas.core.datetools FutureWarning)
      DRPYLINT_CMD="drpythonlint --disable=I,C,R --reports=n $FILES_LIST"
      if hash -- drpythonlint 2>/dev/null; then
        echo "${DR_THINK_EMOJI}Checking for python linter errors..."
        $DRPYLINT_CMD 2>/dev/null
      else
        echo "${DR_ERROR_EMOJI}Python linter could not be found. Have you activated a virtual environment?"
        false
      fi
      DRPYLINT_ERRORS=$?

      # Abort the commit if linter or code style errors were found
      if [ $DRPYLINT_ERRORS -ne 0 ]; then
        echo "${DR_FAIL_EMOJI}Found python linter errors. Aborting commit. (Use --no-verify to skip this check.)"
        exit $DRPYLINT_ERRORS
      else
        echo "${DR_PASS_EMOJI}All checks passed. Committing..."
      fi
    else
      echo "${DR_WELP_EMOJI}No files left to commit."
      exit 1
    fi
}


have_vagrant=$(check_vagrant)
if [[ ${have_vagrant} == running ]]; then
  rmt_workspace=$(get_vagrant_workspace)
  echo "${DR_WORK_EMOJI}Vagrant Workspace: ${rmt_workspace}"
  echo "${DR_WORK_EMOJI}Launching pre-commit script via Vagrant..."
  vagrant ssh -c "(source ~/.quantum/control-env/bin/virtualenvwrapper.sh && workon dev && cd ${rmt_workspace}/DataRobot && /usr/bin/env WORKSPACE=${rmt_workspace} GIT_DIR=${rmt_workspace}/DataRobot/.git DR_CHECK_VAGRANT=false ./.git/hooks/pre-commit)"
else
  echo "${DR_WORK_EMOJI}Running pre-commit script..."
  process_precommit_checks
fi
