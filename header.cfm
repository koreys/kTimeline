<!DOCTYPE html>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<!-- Bootstrap compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- Bootstrap compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<!-- Font Awesome -->
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<!--
<link href="/css/animate.min.css" rel="stylesheet">
-->
<!-- Check for Authentication cookie -->
<CFIF !isDefined("cookie.instaAccessCode")><!--If the cookie isnt defined send user to Auth.cfm -->
		<CFSET myFeedHref = "timeline.cfm">
<CFELSE>
		<CFSET myFeedHref = "userfeed.cfm?access_token=#cookie.instaAccessCode#&user=#cookie.instaFullName#">
</CFIF>

<CFOUTPUT>
<div class="navbar navbar-default" >
	<div class="container-fluid">
		<div class="navbar-header">
			<a class="navbar-brand" href="##">kTimeline</a>
		</div>

		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		  <ul class="nav navbar-nav">
			<li class="active"><a href="#myFeedHref#">My Timeline</a></li>
			<li><a href="logout.cfm">Log Out</a></li>
			<!---
			<li class="dropdown">
			  <a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
			  <ul class="dropdown-menu" role="menu">
				<li><a href="##">Action</a></li>
				<li><a href="##">Another action</a></li>
				<li><a href="##">Something else here</a></li>
				<li class="divider"></li>
				<li><a href="##">Separated link</a></li>
				<li class="divider"></li>
				<li><a href="##">One more separated link</a></li>
			  </ul>
			</li>
			--->
		  </ul>
			<!---
		  <form class="navbar-form navbar-right" role="search">
			<div class="form-group">
			  <input type="text" class="form-control" placeholder="Search">
			</div>
			<button type="submit" class="btn btn-default">Submit</button>
		  </form>
			--->
		</div><!-- /.navbar-collapse -->
    </div><!-- /container-fluid -->
</div><!-- /navbar -->
</CFOUTPUT>
