function Move-GitlabProjectIssue {
    <#
        .SYNOPSIS
        Moves GitLab Project Issue.
        .DESCRIPTION
        Moves a GitLab Project Issue to another project
  
        .EXAMPLE
        Move-GitLabProjectIssue -ProjectID 20 -IssueID 1 -TargetProjectID 21
        ---------------------------------------------------------------
        Moves Issue 1 from project 20 to project 21
        .PARAMETER Whatif
        show the result of the Move-GitlabProjectIssue
        .PARAMETER Confirm
        ask for confirmation before moving the issue
    #>
    [cmdletbinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    [OutputType('GitLab.Issue')]
    Param
    (
      # ID of the project
      [Parameter(
        HelpMessage = 'ProjectID',
        Mandatory = $true)]
      [Alias('ID')]
      [int]$ProjectID,
  
      # IId of the issue
      [Parameter(
        HelpMessage = 'IssueID',
        Mandatory = $true)]
      [Alias('issue_id', 'iid')]
      [string]$IssueID,
  
      # ID of the project to move the issue to
      [Parameter(
        HelpMessage = 'Target ProjectID',
        Mandatory = $true)]
      [int]$TargetProjectID,
  
      # Return the moved issue
      [Parameter(HelpMessage = 'Passthru the moved issue',
        Mandatory = $false)]
      [switch]$PassThru
    )
    try {
      
      $Project = Get-gitlabProject -ID $ProjectID
      $TargetProject = Get-gitlabProject -ID $TargetProjectID
      $Issue = Get-GitlabProjectIssue -ProjectID $ProjectID -IssueID $IssueID
      $formatlist = @(
        $project.path_with_namespace,
        $IssueID,
        $Issue.title
      )
      $issueIdentifier = "{0}#{1} : {2}" -f $formatlist
      $action = "move issue to project {0}" -f $TargetProject.path_with_namespace
  
      if ($PSCmdlet.ShouldProcess($issueIdentifier, $action)) {
  
        $Request = @{
          URI    = "/projects/$ProjectID/issues/$issueID/move"
          Method = 'Post'
        }
  
        $URLParameters = GetMethodParameters -GetURLParameters @{to_project_id = $TargetProjectID}
  
        $Request.uri += $URLParameters
  
        $movedissue = QueryGitLabAPI -Request $Request -ObjectType 'GitLab.Issue'
  
        if ($PassThru) {
          return $movedissue
        }
      }
    }
    catch {
      Write-Error -Message $_
    }
  }