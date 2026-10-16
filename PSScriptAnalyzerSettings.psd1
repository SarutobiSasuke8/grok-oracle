# PSScriptAnalyzer settings for grok-oracle.
# Run locally:  Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
@{
    # Information-level findings are advisory; CI fails on Error and Warning only.
    Severity     = @('Error', 'Warning')

    ExcludeRules = @(
        # Both scripts are interactive helpers whose whole job is to print a
        # coloured handoff block or install message for a human to read and copy.
        # Write-Host is the intended output channel here, not a pipeline mistake,
        # and the tests mock it to assert what is printed.
        'PSAvoidUsingWriteHost'
    )
}
