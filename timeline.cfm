<CFSET redirectUri = "stream.korey.me/Auth.cfm">
<doctype html>
<html>
<head>
	<title>kTimeline - Instagram Client</title>
	<style>
	#loginBox {
		width: 400px;
		background-color: #CCC;
		padding: 1px 20px 20px 20px;
		border-radius: 8px;
	}
	</style>
</head>
<body>
<CFOUTPUT>

<div class="container">
	<div class="center-block" id="loginBox">
		<CFIF isDefined("cookie.instaAccessCode")>
			<center>
				<h2>It looks like you are already logged in as: #cookie.instaFullName#</h2>
				<a href="userFeed.cfm?access_Token=#cookie.instaAccessCode#&user=#cookie.instaFullName#">Go to your image feed</a><br />
				<a href="logout.cfm">Log Out</a>
			</center>
		<CFELSE>
			<center>
				<h2>Welcome to kTimeline</h2>
				<h5>An Instagram Client for your browser</h5>
				<a class="btn btn-primary" href="https://api.instagram.com/oauth/authorize/?client_id=578b4fc24c07486fae6fae76d398b980&redirect_uri=#redirectUri#&response_type=code&scope=likes">Click here to get authenticated!!</a>
			</center>
		</CFIF>
	</div><!-- End LoginBox -->

</div><!--End Container -->

</CFOUTPUT>
</body>
</html>
