
$url = $env:AZP_URL
$token = $env:AZP_TOKEN
$pool = $env:AZP_POOL
$agentName = $env:AZP_AGENT_NAME

Write-Verbose -Verbose "Configuring agent $agentName for pool $pool"

.\config.cmd --unattended `
            --url $url  `
            --auth pat  `
            --token $token  `
            --pool $pool  `
            --agent $agentName  `
            --acceptteeeula `
            --replace `
            --gituseschannel

.\run.cmd
