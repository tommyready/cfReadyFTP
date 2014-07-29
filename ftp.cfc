<cfcomponent displayname="cfReadyFTP">

		<cfset this.name = "cfReadyFTP" />

        <!--- FTP Settings ---->
        <cfset this.ftpHost="" />
        <cfset this.ftpPort="" />
        <cfset this.ftpUser="" />
        <cfset this.ftpPword="" />
        <cfset this.ftpRootDir="/" />
        <cfset this.localDir="C:\" />

        <!--- MISC VARS --->
        <cfset this.connection = '' />
        <cfset this.isConnected = false />

        <cffunction name="init" access="public">
            <cfargument name="ftpHost" required="true" type="string" />
            <cfargument name="ftpPort" required="true" type="numeric" />
            <cfargument name="ftpUser" required="true" type="string" />
            <cfargument name="ftpPword" required="true" type="string" />
            <cfargument name="ftpRootDir" required="true" type="string" />
            <cfargument name="localDir" required="true" type="string" />

            <cfset this.ftpHost = arguments.ftpHost />
            <cfset this.ftpPort = arguments.ftpPort />
            <cfset this.ftpUser = arguments.ftpUser />
            <cfset this.ftpPword = arguments.ftpPword />
            <cfset this.ftpRootDir = arguments.ftpRootDir />
            <cfset this.localDir = arguments.localDir />

            <cfreturn this />
        </cffunction>

        <cffunction name="open" access="public">

            <cfif this.isConnected eq false>
            	<cfftp
                		action="open"
                		connection="this.connection"
                        server="#this.ftpHost#"
                        username="#this.ftpUser#"
                        password="#this.ftpPword#"
                        port="#this.ftpPort#"
                        stoponerror="yes" />

               <cfif cfftp.succeeded eq 'YES'>
                  <cfset this.isConnected = true />
               </cfif>
            </cfif>

            <cfreturn this.isConnected />
        </cffunction>

        <cffunction name="close" access="public">

            <cfif this.isConnected>
            	<cfftp
                		action="close"
                		connection="this.connection"
                        stoponerror="yes" />

               <cfif cfftp.succeeded eq 'YES'>
                  <cfset this.isConnected = false />
               </cfif>
            </cfif>

            <cfreturn this.isConnected />
        </cffunction>


        <cffunction name="getFileList" returntype="string" access="public">
			<cfargument name="directoryToGet" type="string" required="false" default="#this.ftpRootDir#" />

			<cfset local.getDir = ( trim(arguments.directoryToGet) NEQ '' ? this.ftpRootDir & trim(arguments.directoryToGet) : this.ftpRootDir ) />

        	<cfif this.isConnected>
        		<cfftp connection="this.Connection" action="ListDir" directory="#local.getDir#" name="local.fileList" stoponerror="Yes">
            <cfelse><!--- We Arent Connected so Reconnect --->
            	<cfset open() />
                <cfftp connection="this.Connection" action="ListDir" directory="#local.getDir#" name="local.fileList" stoponerror="Yes">
            </cfif>

            <cfreturn local.fileList />
		</cffunction>

        <cffunction name="getFile" returntype="string" access="public">
			<cfargument name="fileToGet" type="string" required="true" />
		    <cfargument name="directoryToGet" type="string" required="false" default="#this.ftpRootDir#" />
		    <cfargument name="directoryToPut" type="string" required="false" default="#this.localDir#" />
		    <cfargument name="overwritePutFile" type="string" required="false" default="no" />


			<cfset local.getFile = trim(arguments.directoryToGet) & trim(arguments.fileToGet) />
			<cfset local.putFile = trim(arguments.directoryToPut) & trim(arguments.fileToGet) />



			<cfset open() /><!--- Verify Connection State --->

            <cfftp
            		action="getfile"
                    transfermode="binary"
                    connection="this.connection"
                    remotefile="#local.getFile#"
                    localFile="#local.getFile#"
                    failifexists="#local.overwritePutFile#"
                    />

        	<cfreturn "#cfftp.succeeded#" />
        </cffunction>

</cfcomponent>
