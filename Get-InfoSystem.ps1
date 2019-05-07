function Get-InfoSystem{
param (

        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='infoObject')]
        [ValidateSet('infoObject')]
        [string]$Get_infoObject,
        
        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='Compilation')]
        [ValidateSet('Compilation')]
        [string]$Get_Compilation,
        
        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='HostName')]
        [ValidateSet('HostName')]
        [string]$Get_HostName,

        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='OS')]
        [ValidateSet('OS')]
        [string]$Get_OS,

        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='HotFix')]
        [ValidateSet('HotFix')]
        [string]$Get_HotFix,

        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='AdminUsers')]
        [ValidateSet('AdminUsers')]
        [string]$Get_AdminUsers,

        [parameter(mandatory=$false)]
        [parameter(ParameterSetName='Process')]
        [ValidateSet('Process')]
        [string]$Get_Process


)
  
    $compilation = Get-WmiObject -Class Win32_OperatingSystem 
    $hostname = Get-WmiObject -Class Win32_ComputerSystem
    $os = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $hotfix = Get-WmiObject -Class win32_quickfixengineering
    $useradmins = Get-LocalGroupMember -Group "Administrators"
    $process = Get-WmiObject -Class win32_process


    $Object = New-Object -TypeName PSObject
    $Object | Add-Member -MemberType NoteProperty -Name Compilation -Value $compilation.Version
    $Object | Add-Member -MemberType NoteProperty -Name HostName -Value $hostname.Name
    $Object | Add-Member -MemberType NoteProperty -Name OS -Value $os.ProductName
    $Object | Add-Member -MemberType NoteProperty -Name HotFix -Value $hotfix.HotFixID
    $Object | Add-Member -MemberType NoteProperty -Name AdminUsers -Value $useradmin.Name
    $Object | Add-Member -MemberType NoteProperty -Name Process -Value $process.Name

    switch ($psCmdlet.ParameterSetName) {
    
         "infoObject" {Write-Output $Object}

         "Compilation" {Write-Output $Object | Select Compilation }
         
         "HostName" {Write-Output $Object | Select Hostname}

         "OS" {Write-Output $Object | Select OS}

         "HotFix" {Write-Output $Object | Select -ExpandProperty HotFix}

         "AdminUsers" {Write-Output $Object | Select -ExpandProperty AdminUsers}

         "Process" {Write-Output $Object | Select -ExpandProperty Process}
                         
        }  
 
}
