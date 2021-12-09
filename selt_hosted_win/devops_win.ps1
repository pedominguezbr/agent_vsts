param (
    [string]$AZP_URL,
    [string]$AZP_TOKEN,
    [string]$AZP_POOL,
    [string]$AZP_AGENT_NAME
)

Write-Host "start"

# if (test-path "c:\agent")
# {
#     Remove-Item -Path "c:\agent" -Force -Confirm:$false -Recurse
# }

# new-item -ItemType Directory -Force -Path "c:\agent"
set-location "c:\agent"

# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# $wr = Invoke-WebRequest https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest
# $tag = ($wr | ConvertFrom-Json)[0].tag_name
# $tag = $tag.Substring(1)

# write-host "$tag is the latest version"
# $url = "https://vstsagentpackage.azureedge.net/agent/$tag/vsts-agent-win-x64-$tag.zip"

# Invoke-WebRequest $url -Out agent.zip
# Expand-Archive -Path agent.zip -DestinationPath $PWD
.\config.cmd --unattended --url $AZP_URL --auth pat --token $AZP_TOKEN --pool $AZP_POOL --agent $AZP_AGENT_NAME --acceptTeeEula --runAsService

exit 0
