﻿###########################################################################################################################################################
# Created By: Cyberhill Partners, LLC.
# https://cyberhillpartners.com
# Date: 2/10/2021
# Description: Lookup Application Accounts
###########################################################################################################################################################

Function Get-SSLookupApplicationAccounts {
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $URI,
         [Parameter(Mandatory=$true, Position=1)]
         [string] $APIKey,
         [Parameter(Mandatory=$False, Position=2)]
         [boolean] $includeAll,
         [Parameter(Mandatory=$False, Position=3)]
         [string] $SearchText,
         [Parameter(Mandatory=$False, Position=4)]
         [int] $Skip,
         [Parameter(Mandatory=$False, Position=5)]
         [string] $SortDirection,
         [Parameter(Mandatory=$False, Position=6)]
         [string] $SortField,
         [Parameter(Mandatory=$False, Position=7)]
         [int] $SortPriority,
         [Parameter(Mandatory=$False, Position=8)]
         [int] $Take = 10
    )

    try
    {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Bearer $APIKey")
    $URI = "$URI/api/v1/application-accounts/lookup?take=$take"
    
    If ($includeAll) {
        $URI = "$URI&filter.includeAll=$includeAll"
    }

    If ($SearchText) {
        $URI = "$URI&filter.searchText=$SearchText"
    }

    If ($Skip) {
        $URI = "$URI&skip=$Skip"
    }

    If ($SortDirection) {
        $URI = "$URI&sortBy[0].direction=$SortDirection"
    }

    If ($SortField) {
        $URI = "$URI&sortBy[0].name=$SortField"
    }

    If ($SortPriority) {
        $URI = "$URI&sortBy[0].priority=$SortPriority"
    }
    
    $ApplicationAccounts = Invoke-RestMethod $URI -Method Get -Headers $headers
    return $ApplicationAccounts
    }
    catch
    {
        $result = $_.Exception.Response.GetResponseStream();
        $reader = New-Object System.IO.StreamReader($result);
        $reader.BaseStream.Position = 0;
        $reader.DiscardBufferedData();
        $responseBody = $reader.ReadToEnd() | ConvertFrom-Json
        Write-Host "ERROR: ($responseBody.error)"
        return;
    }
}