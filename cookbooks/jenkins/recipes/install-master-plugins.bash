#!/bin/bash -e

function install()
{
    local -r pluginList=($(sed -e 's/\n/ /g' <<< "${@}"))

    if [[ "${#pluginList[@]}" -gt '0' ]]
    then
        local -r appName="$(getFileName "${jenkinsDownloadURL:?}")"
        local -r jenkinsCLIPath="${jenkinsTomcatInstallFolder:?}/webapps/${appName}/WEB-INF/jenkins-cli.jar"
        local -r jenkinsAppURL="http://127.0.0.1:${jenkinsTomcatHTTPPort:?}/${appName}"

        checkNonEmptyString "${appName}"
        checkExistFile "${jenkinsCLIPath}"
        checkExistURL "${jenkinsAppURL}"

        java -jar "${jenkinsCLIPath}" -s "${jenkinsAppURL}" install-plugin "${pluginList[@]}"
    else
        info "No installs/updates available"
    fi
}

function main()
{
    appPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "${appPath}/../../../libraries/util.bash"
    source "${appPath}/../attributes/master.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING MASTER PLUGINS JENKINS'

    install "${@}"
    installCleanUp
}

main "${@}"