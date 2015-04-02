<cfcomponent output="false">

	<!--- Application name, should be unique --->
	<cfset this.name = "kTimeline">
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(1,0,0,0)> <!---1 days--->
	<!--- How long do session vars persist? --->
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0,0,0,15)><!---15 mins--->
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>



	<cffunction name="onApplicationStart" returnType="boolean" output="false">
			<!---
			This is the settings page where you need to input your own values obtained
			from registering your own client with Instagram's developer API.
			Go here: https://instagram.com/developer/ and register a new Client.

			<CFSET REDIRECTURI = "http://YOUR-DOMAIN-NAME/Auth.cfm">
			<CFSET CLIENT_ID = "YOUR-CLENT-ID">
			<CFSET CLIENT_SECRET = "YOUR-CLIENT-SECRET">
			<CFSET SERVERNAME = "YOUR-SERVER-NAME"> //set to 'Dev' or 'Live'

			--->
			<CFSET APPLICATION.REDIRECTURI = "http://test.korey.me/Auth.cfm">
			<CFSET APPLICATION.CLIENT_ID = "dbd3c8d7e0444cf6ab6b50de5f818776">
			<CFSET APPLICATION.CLIENT_SECRET = "7e33a2c5497840df819debc0a575be71">
			<CFSET APPLICATION.SERVERNAME = "Dev">
	  <cfreturn true>
	</cffunction>

<cffunction name="OnRequestStart">
   <!--- OnRequestStart body goes here --->
	<!--- Check to see if reset flag exists in URL. --->
	<cfif structKeyExists( url, "reset" )>
	    <cfset this.onApplicationStart() />
	</cfif>

   <CFIF #TRIM(Left(cgi.SCRIPT_NAME, 11))# EQ '/likeAction'>
   <CFELSE>
   		<CFINCLUDE template="header.cfm" />
   </CFIF>
</cffunction>

</cfcomponent>
