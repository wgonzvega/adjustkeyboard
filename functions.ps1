function Get-PipelineBeginEnd {
    param (
        [string]$SomeInput
    )
    begin {
        "Begin: The input is $SomeInput"
    }
    process {
        "The value is: $_"
    }
    end {
        "End:   The input is $SomeInput"
    }
}#Get-PipelineBeginEnd
1, 2, 3 | Get-PipelineBeginEnd -SomeInput 'Test'