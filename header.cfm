<!DOCTYPE html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<!-- Bootstrap compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- Bootstrap compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<!-- Font Awesome -->
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<!-- My Specific Styles - Korey -->
<link href="/css/style.css" rel="stylesheet">

<!-- Check for Authentication cookie -->
<CFIF isDefined("cookie.instaAccessCode")>
	<CFSET myFeedHref = "userfeed.cfm?access_token=#cookie.instaAccessCode#&user=#cookie.instaFullName#">
	<CFSET myImagesHref = "userfeed.cfm?access_token=#cookie.instaAccessCode#&user=#cookie.instaFullName#&userid=#cookie.instaMyID#">
<CFELSE>
	<CFSET myFeedHref = "timeline.cfm">
	<CFSET myImagesHref = "##">
</CFIF>

<CFOUTPUT>
<div class="navbar navbar-default" >
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
			<a class="navbar-brand" href="##"><img src="img/Logo.png" class="navLogo"></li></a>
		</div>

		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		  <ul class="nav navbar-nav">
					<li class="active"><a href="#myFeedHref#"><i class="fa fa-home"></i> Image Feed</a></li>
					<li><a href="#myImagesHref#"><i class="fa fa-user"></i> My Images</a></li>
					<li><a href="logout.cfm"><i class="fa fa-sign-out"></i> Log Out</a></li>
		  </ul>

		  <form class="navbar-form navbar-right" role="search">
					<div class="form-group">
						  <input type="text" class="form-control" placeholder="Search Users (Soon)">
					</div>
					<button type="submit" class="btn btn-default">Submit</button>
		  </form>


			<p class="navbar-text navbar-right"><CFIF #APPLICATION.serverName# EQ "Dev">DEV SERVER - #this.name#</CFIF> Build: 4.01.15.01</p>


		</div><!-- /.navbar-collapse -->
  </div><!-- /container-fluid -->
</div><!-- /navbar -->
</CFOUTPUT>
