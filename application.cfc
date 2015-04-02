<cfcomponent output="false">

	<!--- Application name, should be unique --->
	<cfset this.name = "kTimeline">
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(10,0,0,0)> <!---10 days--->
	<!--- How long do session vars persist? --->
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimeSpan(0,20,0,0)><!---20 mins--->
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>
	<!--- should we secure our JSON calls? --->

	<!--- These are the 3 application setting you need to update to match your settings. --->

	<CFSET this.RedirectURI = "http://test.korey.me/Auth.cfm">
	<CFSET this.client_id = "dbd3c8d7e0444cf6ab6b50de5f818776">
	<CFSET this.client_secret = "7e33a2c5497840df819debc0a575be71">
	<CFSET this.serverName = "Dev">


<cffunction name="OnRequestStart">
   <!--- OnRequestStart body goes here --->

   <CFIF #TRIM(Left(cgi.SCRIPT_NAME, 11))# EQ '/likeAction'>
   <CFELSE>
   		<CFINCLUDE template="header.cfm">
   </CFIF>
</cffunction>

</cfcomponent>
