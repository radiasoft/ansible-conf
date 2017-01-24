#!/bin/bash

set -e -u -o pipefail

# From http://theoldschooldevops.com/2008/02/09/bash-ini-parser/

cfg_parser ()
{
    ini="$(<$1)"                # read the file
    ini="${ini//[/\[}"          # escape [
    ini="${ini//]/\]}"          # escape ]
    IFS=$'\n' && ini=( ${ini} ) # convert to line-array
    ini=( ${ini[*]//;*/} )      # remove comments with ;
    ini=( ${ini[*]/\    =/=} )  # remove tabs before =
    ini=( ${ini[*]/=\   /=} )   # remove tabs be =
    ini=( ${ini[*]/\ =\ /=} )   # remove anything with a space around =
    ini=( ${ini[*]/#\\[/\}$'\n'cfg.section.} ) # set section prefix
    ini=( ${ini[*]/%\\]/ \(} )    # convert text2function (1)
    ini=( ${ini[*]/=/=\( } )    # convert item to array
    ini=( ${ini[*]/%/ \)} )     # close array parenthesis
    ini=( ${ini[*]/%\\ \)/ \\} ) # the multiline trick
    ini=( ${ini[*]/%\( \)/\(\) \{} ) # convert text2function (2)
    ini=( ${ini[*]/%\} \)/\}} ) # remove extra parenthesis
    ini[0]="" # remove first element
    ini[${#ini[*]} + 1]='}'    # add the last brace
    eval "$(echo "${ini[*]}")" # eval the result
}
 
cfg_writer ()
{
    IFS=' '$'\n'
    fun="$(declare -F)"
    fun="${fun//declare -f/}"
    for f in $fun; do
        [ "${f#cfg.section}" == "${f}" ] && continue
        item="$(declare -f ${f})"
        item="${item##*\{}"
        item="${item%\}}"
        item="${item//=*;/}"
        vars="${item//=*/}"
        eval $f
        echo "[${f#cfg.section.}]"
        for var in $vars; do
            echo $var=\"${!var}\"
        done
    done
}

if [[ -z ${AWS_DEFAULT_PROFILE+x} ]]; then
    AWS_DEFAULT_PROFILE=default
fi

if [[ -z ${AWS_CONFIG_FILE+x} ]]; then
    AWS_CONFIG_FILE="$HOME/.aws/config"
fi

if [[ -f "$AWS_CONFIG_FILE" ]]; then
    cfg_parser "$AWS_CONFIG_FILE"
    cfg.section.$AWS_DEFAULT_PROFILE

    printf "export TF_VAR_aws_access_key=$aws_access_key_id\n"
    printf "export TF_VAR_aws_secret_key=$aws_secret_access_key\n"
fi

