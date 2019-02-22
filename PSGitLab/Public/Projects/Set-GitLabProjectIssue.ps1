function Set-GitLabProjectIssue {
    <#
        .SYNOPSIS
        Sets the properties on the specified issue.
        .DESCRIPTION
        The Set-GitLabProjecctIssue function sets the specified properties on a issue.
        Returns the modified issue when -PassThru is specified.
        .EXAMPLE
        Set-GitLabProjectIssue -ProjectID 20 -IssueID 1 -Title 'Renamed IssueID'
        ---------------------------------------------------------------
        Renames issue 1 on project 20 to 'Renamed IssueID'
        .EXAMPLE
        Set-GitLabProjectIssue -ProjectID 20 -IssueID 1 -StateEvent close
        ---------------------------------------------------------------
        Closes issue 1 on project 20
        .EXAMPLE
        Set-GitLabProjectIssue -ProjectID 20 -IssueID 1 -StateEvent reopen
        ---------------------------------------------------------------
        Reopens issue 1 on project 20
    #>
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param
    (
      # The Project ID
      [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
      [Alias('ID')]
      [int]$ProjectID,
  
      # The ID of the issue
      [Parameter(HelpMessage = 'IssueID',
        Mandatory = $true)]
      [alias('issue_id', 'iid')]
      [int]$IssueID,
  
      # The title for the issue
      [Parameter(Helpmessage = 'The title of an issue')]
      [string]$Title,
  
      # The description for the issue
      [Parameter(Helpmessage = 'The description of the issue', mandatory = $false)]
      [string]$Description,
  
      # Specify the users to assign the issue
      [Parameter(Helpmessage = 'The ID of users to assign issue',
        mandatory = $false)]
      [Alias('assignee_id')]
      [int[]]$AssigneeIDs,
  
      # The milestone ID to assign the issue to
      [Parameter(Helpmessage = 'The ID of a milestone to assign issue', mandatory = $false)]
      [Alias('milestone_id')]
      [int]$MilestoneID,
  
      # the labels to assign to the issue
      # overwrites any labels previously assigned
      [Parameter(HelpMessage = 'label names for an issue', mandatory = $false)]
      [string[]]$Labels,
  
      # Reopens or closes the Issue
      [Parameter(HelpMessage = 'StateEvent (opened|closed)')]
      [validateset('reopen', 'close')]
      [alias('state_event')]
      [string]$StateEvent,
  
      # Modify the creationdate the issue was created.
      [Parameter(Helpmessage = 'the date the issue was created', mandatory = $false)]
      [alias('updated_at')]
      [datetime]$UpdatedAt,
  
      # The Due Date for the issue
      [Parameter(Helpmessage = 'the due date of the issue', mandatory = $false)]
      [alias('due_date')]
      [datetime]$DueDate,
  
      # Return the modified issue
      [Parameter(HelpMessage = 'Passthru the modified issue',
        Mandatory = $false)]
      [switch]$PassThru
    )
  
    $Request = @{
      URI    = "/projects/$ProjectID/issues/$IssueID"
      Method = 'PUT'
    }
  
    $PutUrlParameters = @()
  
    if ($Title) {
      $PutUrlParameters += @{title = $Title}
    }
  
    if ($Description) {
      $PutUrlParameters += @{description = $Description}
    }
  
    if ($PSBoundParameters.ContainsKey('AssigneeIDs')) {
      if (@($AssigneeIDs).count -gt 0 ) {
        $PutUrlParameters += @{assignee_ids = @($AssigneeIDs) -join ','}
      }
      else {
        $PutUrlParameters += @{assignee_ids = 0}
      }
    }
  
    if ($MilestoneID) {
      $PutUrlParameters += @{milestone_id = $MilestoneID}
    }
  
    if ($PSBoundParameters.ContainsKey('Labels')) {
      if (@($Labels).count -gt 0 ) {
        $PutUrlParameters += @{labels = @($Labels) -join ','}
      }
      else {
        $PutUrlParameters += @{labels = ''}
      }
    }
  
    if ($StateEvent) {
      $PutUrlParameters += @{state_event = $StateEvent}
    }
  
    if ($UpdatedAt) {
      $PutUrlParameters += @{updated_at = $UpdatedAt.ToUniversalTime().tostring('s') + 'Z'}
    }
  
    if ($DueDate) {
      $PutUrlParameters += @{due_date = $DueDate.tostring("yyyy'-'MM'-'dd")}
    }
  
    $URLParameters = GetMethodParameters -GetURLParameters $PutUrlParameters
  
    $Request.uri += $URLParameters
  
    $modissue = QueryGitLabAPI -Request $Request -ObjectType 'GitLab.Issue'
  
    if ($PassThru) {
      return $modissue
    }
  }