function Remove-GitlabProjectIssue {
    <#
        .SYNOPSIS
        Removes GitLab Project Issue.
        .DESCRIPTION
        Removes a GitLab Project Issue.
        Soft deletes the issue in question.
        .EXAMPLE
        Remove-GitLabProjectIssue -ProjectID 20 -IssueID 1
        ---------------------------------------------------------------
        Removes Issue 1 from project 20
        .PARAMETER Whatif
        show the result of the Remove-gitlabProjectIssue
        .PARAMETER Confirm
        ask for confirmation before removing the issue
  
    #>
    [cmdletbinding(SupportsShouldProcess = $True, ConfirmImpact = 'High')]
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
      [string]$IssueID
    )
    try {
  
      $Project = Get-gitlabProject -ID $ProjectID
      $Issue = Get-GitlabProjectIssue -ProjectID $ProjectID -IssueID $IssueID
      $formatlist = @(
        $project.path_with_namespace,
        $IssueID,
        $Issue.title
      )
      $issueIdentifier = "{0}#{1} : {2}" -f $formatlist
  
      if ($PSCmdlet.ShouldProcess($issueIdentifier, 'Delete Issue')) {
  
        $Request = @{
          URI    = "/projects/$ProjectID/issues/$issueID"
          Method = 'DELETE'
        }
  
        $QueryResult = QueryGitLabAPI -Request $Request
      }
    }
    catch {
      Write-Error -Message $_
    }
  }