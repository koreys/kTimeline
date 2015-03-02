<cfcomponent output="false">

	<!--- Application name, should be unique --->
	<cfset this.name = "kTimeline">
	<!--- How long application vars persist --->
	<cfset this.applicationTimeout = createTimeSpan(0,4,0,0)>
	<!--- Should client vars be enabled? --->
	<cfset this.clientManagement = false>
	<!--- Where should we store them, if enable? --->
	<cfset this.clientStorage = "registry">
	<!--- Where should cflogin stuff persist --->
	<cfset this.loginStorage = "session">
	<!--- Should we even use sessions? --->
	<cfset this.sessionManagement = true>
	<!--- How long do session vars persist? --->
	<cfset this.sessionTimeout = createTimeSpan(0,4,0,0)>
	<!--- Should we set cookies on the browser? --->
	<cfset this.setClientCookies = true>
	<!--- should cookies be domain specific, ie, *.foo.com or www.foo.com --->
	<cfset this.setDomainCookies = false>
	<!--- should we try to block 'bad' input from users --->
	<cfset this.scriptProtect = "none">
	<!--- should we secure our JSON calls? --->
	<cfset this.secureJSON = false>
	<!--- Should we use a prefix in front of JSON strings? --->
	<cfset this.secureJSONPrefix = "">
	<!--- Used to help CF work with missing files and dir indexes --->
	<cfset this.welcomeFileList = "">



<cffunction name="OnRequestStart">
   <!--- OnRequestStart body goes here --->

   <!--- Code for FCKeditor --->
   <cflock scope="Application" type="exclusive" timeout="5">
	 <cfset APPLICATION.userFilesPath = "/UserFiles/">
   </cflock>
   <!--- End Code for FCKeditor--->



   <CFIF #TRIM(Left(cgi.SCRIPT_NAME, 12))# EQ '/priceupdate'>
		<cfinclude template="">
   <CFELSE>
   		<CFINCLUDE template="header.cfm">
   </CFIF>
</cffunction>

</cfcomponent>
