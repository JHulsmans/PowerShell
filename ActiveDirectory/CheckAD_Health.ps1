$ADForestName = "sub.fqdn.tld"

$GetPDCNow =Get-ADForest $ADForestName | Select-Object -ExpandProperty RootDomain | Get-ADDomain | Select-Object -Property PDCEmulator

$GetPDCNowServer = $GetPDCNow.PDCEmulator

$FinalStatus="Ok"

 

Get-ADReplicationPartnerMetadata -Target * -Partition * -EnumerationServer $GetPDCNowServer -Filter {(LastReplicationResult -ne "0")} | Select-Object LastReplicationAttempt, LastReplicationResult, LastReplicationSuccess, Partition, Partner, Server | Export-CSV "$ResultFile" -NoType -Append -ErrorAction SilentlyContinue

 

$TotNow = GC $ResultFile

$TotCountNow = $TotNow.Count

IF ($TotCountNow -ge 2)

{

    $AnyOneOk = "Yes"

    $RCSV = Import-CSV $TestCSVFile

    ForEach ($AllItems in $RCSV)

    {

        IF ($AllItems.LastReplicationResult -eq "0")

        {

            $FinalStatus="Ok"

            $TestStatus="Passed"

            $SumVal=""

            $TestText="Active Directory replication is working."

        }

        else

        {

            $AnyGap = "Yes"

            $SumVal = ""

            $TestStatus = "Critical"

            $TestText="Replication errors occurred. Active Directory domain controllers are causing replication errors."

            $FinalStatus="NOTOK"           

            break

        }

    }

}

$TestText

 

IF ($FinalStatus -eq "NOTOK")

{

    ## Since some replication errors were reported, start email procedure here...

 

### START - Modify Email parameters here

$message = @"                                

Active Directory Replication Status

 

Active Directory Forest: $ADForestName

                                  

Thank you,

PowerShell Script

"@

 

$SMTPPasswordNow = "PasswordHere"

$ThisUserName = "UserName"

$MyClearTextPassword = $SMTPPasswordNow

$SecurePassword = Convertto-SecureString –String $MyClearTextPassword –AsPlainText –force

$ToEmailNow ="EmailAddressHere"

$EmailSubject = "SubjectHere"

$SMTPUseSSLOrNot = "Yes"

$SMTPServerNow = "SMTPServerName"

$SMTPSenderNow = "SMTPSenderName"

$SMTPPortNow = "SMTPPortHere"

 

### END - Modify Email parameters here

 

$AttachmentFile = $ResultFile

 

$creds = new-object -typename System.Management.Automation.PSCredential -argumentlist "$ThisUserName", $SecurePassword

Send-MailMessage -Credential $Creds -smtpServer $SMTPServerNow -from $SMTPSenderNow -Port $SMTPPortNow -to $ToEmailNow -subject $EmailSubject -attachment $AttachmentFile -UseSsl -body $message

}