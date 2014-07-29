<cfset local.ftpHost = 'myftpserver.com' /> <!--- Can Also Be An Ip Address --->
<cfset local.ftpUser = 'theUser' />
<cfset local.ftpPword = 'thePassword' />
<cfset local.ftpPort = '21' />
<cfset local.ftpDir = '/' />
<cfset local.localDir = "c:\temp" /> <!--- Physical Path on Local Machine --->

<!---- Create FTP Object ---->
<cfset local.ftpObj = CreateObject("component","ftp").init(
																				local.ftpHost,
																				local.ftpPort,
																				local.ftpUser,
																				local.ftpPword,
																				local.ftpDir,
																				local.localDir
																				) />


<!---- Open FTP Connection --->
<cfset local.openConnection = local.ftpObj.Open() />

<cfdump var="#local.openConnection#" />

<!---- Close FTP Connection ---->
<cfset local.ftpObj.Close() />

<!---
Get Files from Directory
Note: The FTP directory file list is returned if no directory argument passed
--->
<cfset local.ftpFileList = local.ftpObj.getFileList() />

<cfdump var="#local.ftpFileList#" />


<!---
CFFTP.Successed is Returned (Yes or No)
---->
<cfset local.getFile = local.ftpObj.getFile('test.pdf') />

<cfdump var="#local.getFile #">
