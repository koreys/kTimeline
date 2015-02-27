<cfparam name="URL.code" defualt="error">

<doctype HTML>
<html>
<Head>
</head>
<body>

<cfoutput>
<CFIF "URL.code" NEQ "error">
		<!---
		Success!! <br />
		Code is: #URL.code#<br>
		Attempting cfhttp call...<br />
		--->
		<cfhttp url="https://api.instagram.com/oauth/access_token" method="post" resolveurl="true">
			<cfhttpparam type="formField" name="client_id" value="578b4fc24c07486fae6fae76d398b980" />
			<cfhttpparam type="formField" name="client_secret" value="dabc6ff46c5340e8b79a596955378585" />
			<cfhttpparam type="formField" name="grant_type" value="authorization_code" />
			<cfhttpparam type="formField" name="redirect_uri" value="http://office.twininc.com/timeline/Auth.cfm" />
			<cfhttpparam type="formField" name="code" value="#URL.code#" />
		</cfhttp>
		<!---
		Status Code: #cfhttp.statusCode#<br />
		FileContent: #cfhttp.fileContent#<br />
		--->
		<CFSET OAuthToken = deserializeJSON(#cfhttp.fileContent#)>
		<!---
		<CFDUMP var="#OAuthToken#">
		--->

			<CFIF  #cfhttp.statusCode# NEQ '200 OK'>
				ERROR! <br>
				Error msg is: #OAuthToken.error_message#<br>
			<CFELSE>
				<!---
				Yay... Success. Status 200<br>
				User Access token is: #OAuthToken.access_token#<br>
				User Name is: #OAuthToken.user.full_name#<br>
				User Picture:<br><img src="#OAuthToken.user.profile_picture#" width="100">
				--->
				<CFCOOKIE name="instaAccessCode" value="#OAuthToken.access_token#">
				<CFCOOKIE name="instaFullName" value="#OAuthToken.user.full_name#">
				<CFLOCATION URL="userfeed.cfm?access_Token=#OAuthToken.access_token#&user=#OAuthToken.user.full_name#" />
			</CFIF>


<CFELSE>
	<h2>Error: No responce Code from Instagram Callback</h2>
	<!---Timeline.cfm sends an authentication request to instagram... Instgram API
	the calls this page. The callback URL should include a URL.Code var that we use
	as the users access_code from here out --->
</CFIF>



</cfoutput>

</body>
</html>
