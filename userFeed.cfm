<CFPARAM Name="URL.max_id" default="">
<CFPARAM Name="URL.username" default="">
<CFPARAM Name="URL.userID" default="">

<CFIF URL.username EQ "">
		<CFIF URL.userID EQ "">
			<CFSET userID = "#cookie.instaMyID#" >
		<CFELSE>
			<CFSET userID = "#URL.userID#">
		</CFIF>
<CFELSE>
		<!--- Use the username to search for the userid --->
		<CFSET userSearchURL = "https://api.instagram.com/v1/users/search?q=#URL.username#&count=1&access_token=#cookie.instaAccessCode#">
		<cfhttp url="#userSearchURL#" method="get" resolveurl="true" result="userSearch"/>
		<!---<CFDUMP var="#userSearch.fileContent#">--->
		<CFSET userDetails = deserializeJSON(#userSearch.fileContent#)>
		<!---<CFDUMP var="#userDetails#">--->
		<CFIF isDefined("userDetails.data[1].id")>
			<CFSET userID = "#userDetails.data[1].id#" >
		<CFELSE>
			<h1>Error!: No userid could be found :-(</h1>
			<CFABORT>
		</CFIF>
</CFIF>

<CFIF URL.username EQ "" AND URL.userID EQ "">
		<CFIF URL.max_id NEQ "">
			<CFSET feedURL = "https://api.instagram.com/v1/users/self/feed?access_token=#cookie.instaAccessCode#&max_id=#URL.max_id#">
			<CFSET self = "true">
		<CFELSE>
			<!---Korey Test--->
			<CFSET feedURL = "https://api.instagram.com/v1/users/self/feed?access_token=#cookie.instaAccessCode#">
			<CFSET self = "true">
		</CFIF>
<CFELSE>
		<CFIF URL.max_id NEQ "">
			<CFSET feedURL = "https://api.instagram.com/v1/users/#userID#/media/recent/?access_token=#cookie.instaAccessCode#&max_id=#URL.max_id#">
		  <CFSET self = "false">
		<CFELSE>
			<CFSET feedURL = "https://api.instagram.com/v1/users/#userID#/media/recent/?access_token=#cookie.instaAccessCode#">
			<CFSET self = "false">
		</CFIF>
</CFIF>

<cfhttp url="#feedURL#" method="get" resolveurl="true" />

<CFIF  #cfhttp.statusCode# NEQ '200 OK'>
		<!---<CFDUMP var="#cfhttp.fileContent#">--->
		<CFSET errorFeed = deserializeJSON(#cfhttp.fileContent#)>
		<CFIF #errorFeed.meta.code# EQ '400'>
			<Div style="width:400px;" class="well center-block"><center><h2><i class="fa fa-user-secret"></i> Sorry</h2><br /><h4>This user is private</h4></center></div>
			<CFABORT>
		<CFELSE>
			ERROR! <br>
			<CFDUMP var="#errorFeed#">
			<CFABORT>
		</CFIF>
<CFELSE>
		<CFSET UserFeed = deserializeJSON(#cfhttp.fileContent#)>
</CFIF>

<CFSET myImagesURL = "userfeed.cfm?access_token=#cookie.instaAccessCode#&user=#cookie.instaFullName#&userid=#cookie.instaMyID#">
<CFSET followsURL = "follows.cfm?userID=#userID#">
<CFSET followedByURL = "followedBy.cfm?userID=#userID#">


<HTML>
<head>
	<title>Image Feed</title>
</head>
<body>
<CFOUTPUT>
	<!---
	Status Code: #cfhttp.statusCode#<br />
	Current feedURL: #feedURL#<br>
	--->
 <!---  <CFDUMP var="#UserFeed#"> --->

	<cfset myArrayLen = #arraylen(userfeed.data)#>

	<div class="container-fluid" style="border:0px dashed blue;">

	<CFSET userInfoURL = "https://api.instagram.com/v1/users/#userID#/?access_token=#cookie.instaAccessCode#">
	<cfhttp url="#userInfoURL#" method="get" resolveurl="true" result="userInfo"/>
	<CFSET currentUserInfo = deserializeJSON(#userInfo.fileContent#)>

  <img src="#currentUserInfo.data.profile_picture#" class="profilePic img-thumbnail">
	<div id="profileInfoContainer">
			<h2 id="userTitle">#currentUserInfo.data.full_name# Image Feed</h2>
			<br />
			<div class="countsDiv">
					<a href="#myImagesURL#" class="btn btn-success">Images: #currentUserInfo.data.counts.media#</a>
					<a href="#followsURL#&count=#currentUserInfo.data.counts.follows#" class="btn btn-info">Following: #currentUserInfo.data.counts.follows#</a>
					<a href="#followedByURL#&count=#currentUserInfo.data.counts.followed_by#" class="btn btn-primary">Followed By: #currentUserInfo.data.counts.followed_by#</a>
			</div>
			<div class="profileBioDiv">
				#currentUserInfo.data.bio#
			</div>
  </div>

	<div style="clear:both;"></div>
	<CFLOOP From="1" to="#myArrayLen#" index="i">
		<div class="instaImgDiv">
			<div class="nameBlock">
				<CFIF TRIM(userfeed.data[#i#].user.full_name) EQ "">
					#userfeed.data[#i#].user.username#
				<CFELSE>
				  #userfeed.data[#i#].user.full_name#
				</CFIF>
			</div>
			<div class="likesAndCommentBlock">
				<i class="fa fa-heart" style="color: red;"></i>  #userfeed.data[#i#].likes.count# | <i class="fa fa-comment"></i> #userfeed.data[#i#].comments.count#
			</div>
			<a href="imgDetail.cfm?imgID=#userfeed.data[#i#].id#&access_token=#cookie.instaAccessCode#">
				<img class="img-thumbnail" src="#userfeed.data[#i#].images.low_resolution.url#">
				<CFIF #userfeed.data[#i#].type# EQ "video">
					<i class="fa fa-youtube-play fa-4x instaVideo"></i>
				</CFIF>
		  </a>
		</div>
	</CFLOOP>

	<div class="instaImgDiv">
		<div class="moreDiv">
			<center>
				<CFIF isDefined("userfeed.pagination.next_max_id")>
					<CFIF self EQ "true">
				  		<a href="userfeed.cfm?max_id=#userfeed.pagination.next_max_id#&access_token=#cookie.instaAccessCode#"><i class="fa fa-forward fa-3x"></i><br>Next</a>
			  	<CFELSE>
						<a href="userfeed.cfm?max_id=#userfeed.pagination.next_max_id#&access_token=#cookie.instaAccessCode#&userid=#userID#"><i class="fa fa-forward fa-3x"></i><br>Next</a>
					</CFIF>
				</CFIF>
			</center>
		</div>
	</div>

	<div style="clear:both"></div>
	</div>
	<br>
</CFOUTPUT>

</body>
</html>
