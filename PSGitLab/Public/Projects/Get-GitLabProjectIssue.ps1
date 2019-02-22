function Get-GitLabProjectIssue {
    <#
        .SYNOPSIS
        Gets GitLab Project Issue.
        .DESCRIPTION
        Gets GitLab Project Issue. Gets all Issues by Default.
  
        If IssueID is passed only specified issue is retured.
        .EXAMPLE
        Get-GitLabProjectIssue -ProjectID 20
        ---------------------------------------------------------------
        Gets all issues for project 20
        .EXAMPLE
        Get-GitLabProjectIssue -ProjectID 20 -IssueID 1
        ---------------------------------------------------------------
        Gets issue 1 for project 20
        .EXAMPLE
        Get-GitLabProjectIssue -ProjectID 20 -State 'opened'
        ---------------------------------------------------------------
        Gets all open issues for project 20
    #>
  
    [CmdletBinding(DefaultParameterSetName = 'AllIssues')]
    [OutputType('GitLab.Issue')]
    Param
    (
      # The ID of a project
      [Parameter(
        HelpMessage = 'ProjectID',
        Mandatory = $true)]
      [Alias('ID')]
      [int]$ProjectID,
  
      # If specified only returns opened or closed issues.
      [Parameter(ParameterSetName = 'AllIssues',
        HelpMessage = 'State (opened|closed)')]
      [validateset('opened', 'closed')]
      [string]$State,
  
      # Return issues for the given scope: created-by-me, assigned-to-me or all
      [Parameter(ParameterSetName = 'AllIssues',
        HelpMessage = 'State (opened|closed)')]
      [ValidateSet('All', 'CreatedByMe', 'AssignedToMe')]
      [String]$Scope,
  
      # If list of label names is specified only issues with any of the labels will be returned
      [Parameter(ParameterSetName = 'AllIssues',
        HelpMessage = 'list of labels')]
      [string[]]$Labels,
  
      # If Specified only issues belonging to specified milestone will be returned
      [Parameter(ParameterSetName = 'AllIssues',
        HelpMessage = 'milestone title')]
      [string[]]$Milestone,
  
      #The ID of a projects issue
      [Parameter(ParameterSetName = 'SingleIssue',
        HelpMessage = 'IssueID',
        Mandatory = $true)]
      [string]$IssueID
    )
  
    $Request = @{
      URI    = "/projects/$ProjectID/issues"
      Method = 'GET'
    }
  
    $GetUrlParameters = @()
  
    if ($PSCmdlet.ParameterSetName -like 'AllIssues') {
      if ($State) {
        $GetUrlParameters += @{state = $State}
      }
  
      if ($Labels) {
        $GetUrlParameters += @{labels = @($Labels) -join ','}
      }
  
      if ($Milestone) {
        $GetUrlParameters += @{milestone = $Milestone}
      }
  
      if ($Scope) {
        # set kebab or snake case depending on version
        $seperator = "_"
        if ([int](get-gitlabversion).version.split(".")[0] -lt 11) {
          $seperator = "-"
        }
        if ($Scope -eq 'CreatedByMe') {
          $GetUrlParameters += @{scope = 'created_by_me' -replace "_", $seperator}
        }
        elseif ($Scope -eq 'AssignedToMe') {
          $GetUrlParameters += @{scope = 'assigned_to_me' -replace "_", $seperator}
        }
        elseif ($Scope -eq 'all') {
          $GetUrlParameters += @{scope = 'all'}
        }
        else {
        }
      }
    }
  
    if ($PSCmdlet.ParameterSetName -like 'SingleIssue') {
      $Request.URI += "/$IssueID"
    }
  
    $URLParameters = GetMethodParameters -GetURLParameters $GetUrlParameters
  
    $Request.uri += $URLParameters
  
    QueryGitLabAPI -Request $Request -ObjectType 'GitLab.Issue'
  }