<doctype html>
<html>
<head>
	<title>Instagram Test</title>
</head>
<body>
<CFOUTPUT>

		<CFIF isDefined("cookie.instaAccessCode")>
			<h2>It looks like you are already logged in as: #cookie.instaFullName#</h2>
			<a href="userFeed.cfm?access_Token=#cookie.instaAccessCode#&user=#cookie.instaFullName#">Go to your image feed</a><br />
			<a href="logout.cfm">Log Out</a>
		<CFELSE>
			<h2>Welcome to kTimeline</h2>
			<h5>An Instagram Client for your browser</h5>

			<a href="https://api.instagram.com/oauth/authorize/?client_id=578b4fc24c07486fae6fae76d398b980&redirect_uri=http://korey.me/Auth.cfm&response_type=code">Click here to get authenticated!!</a>

		</CFIF>

</CFOUTPUT>
</body>
</html>
