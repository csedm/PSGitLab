function New-GitLabProjectIssue {
    <#
        .SYNOPSIS
        Creates a new project issue.
        .DESCRIPTION
        The New-GitLabProjectIssue functions creates a new function in the specified project.
        .EXAMPLE
        New-GitLabProjectIssue -ProjectID 20 -Title 'Important Issue'
        ---------------------------------------------------------------
        Creates the Issue title 'Important Issue' in project with ID 20
        .EXAMPLE
        New-GitLabProjectIssue -ProjectID 20 -Title 'Important Issue' -PassThru
        ---------------------------------------------------------------
        Creates the Issue title 'Important Issue' in project with ID 20 and returns the new issue.
    #>
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param
    (
      #The Id of the project
      [Parameter(HelpMessage = 'ProjectID',
        Mandatory = $true)]
      [Alias('ID')]
      [int]$ProjectID,
  
      # The title of the new issue
      [Parameter(Helpmessage = 'The title of an issue',
        mandatory = $true)]
      [string]$Title,
  
      # The description of the new issue
      [Parameter(Helpmessage = 'The description of the issue',
        mandatory = $false)]
      [string]$Description,
  
      # Specify the users to assign the issue
      [Parameter(Helpmessage = 'The ID of users to assign issue',
        mandatory = $false)]
      [Alias('assignee_id')]
      [int[]]$AssigneeIDs,
  
      # Specify the ID of the milestone to assign the issue
      [Parameter(Helpmessage = 'The ID of a milestone to assign issue',
        mandatory = $false)]
      [Alias('milestone_id')]
      [int]$MilestoneID,
  
      # Specify the labels for the new issue
      [Parameter(HelpMessage = 'label names for an issue',
        mandatory = $false)]
      [string[]]$Labels,
  
      # Specify the date the issue was created
      [Parameter(Helpmessage = 'the date the issue was created',
        mandatory = $false)]
      [alias('created_at')]
      [datetime]$CreatedAt,
  
      # Specify the due date for the issue
      [Parameter(Helpmessage = 'the due date of the issue',
        mandatory = $false)]
      [alias('due_date')]
      [datetime]$DueDate,
  
      # Passthru the created Issue
      [Parameter(HelpMessage = 'Passthru the created project',
        Mandatory = $false)]
      [switch]$PassThru
    )
  
    $Request = @{
      URI    = "/projects/$ProjectID/issues"
      Method = 'POST'
    }
  
    $PostUrlParameters = @()
  
    $PostUrlParameters += @{title = $Title}
  
    if ($Description) {
      $PostUrlParameters += @{description = $Description}
    }
  
    if ($AssigneeIDs) {
      $PostUrlParameters += @{assignee_ids = @($AssigneeIDs) -join ','}
    }
  
    if ($MilestoneID) {
      $PostUrlParameters += @{milestone_id = $MilestoneID}
    }
  
    if ($Labels) {
      $PostUrlParameters += @{labels = @($Labels) -join ','}
    }
  
    if ($CreatedAt) {
      $PostUrlParameters += @{created_at = $CreatedAt.ToUniversalTime().tostring('s') + 'Z'}
    }
  
    if ($DueDate) {
      $PostUrlParameters += @{due_date = $DueDate.tostring("yyyy'-'MM'-'dd")}
    }
  
    $URLParameters = GetMethodParameters -GetURLParameters $PostUrlParameters
  
    $Request.uri += $URLParameters
  
    $newissue = QueryGitLabAPI -Request $Request -ObjectType 'GitLab.Issue'
  
    if ($PassThru) {
      return $newissue
    }
  }