<CFPARAM Name="URL.max_id" default="">
<CFPARAM Name="URL.userid" default="">

<CFIF URL.userid EQ "">
	<CFIF URL.max_id NEQ "">
		<CFSET feedURL = "https://api.instagram.com/v1/users/self/feed?access_token=#cookie.instaAccessCode#&max_id=#URL.max_id#">
	<CFELSE>
		<CFSET feedURL = "https://api.instagram.com/v1/users/self/feed?access_token=#cookie.instaAccessCode#">
	</CFIF>
<CFELSE>
	<CFIF URL.max_id NEQ "">
		<CFSET feedURL = "https://api.instagram.com/v1/users/#URL.userid#/media/recent/?access_token=#cookie.instaAccessCode#&max_id=#URL.max_id#">
	<CFELSE>
		<CFSET feedURL = "https://api.instagram.com/v1/users/#URL.userid#/media/recent/?access_token=#cookie.instaAccessCode#">
	</CFIF>
</CFIF>

<cfhttp url="#feedURL#" method="get" resolveurl="true" />
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

	<CFIF  #cfhttp.statusCode# NEQ '200 OK'>
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
 <!---  <CFDUMP var="#UserFeed#"> --->

	<CFIF isDefined("userFeed.meta.error_message")>
			<CFIF TRIM(userFeed.meta.error_message) EQ TRIM("you cannot view this resource")>
				<h3>Sorry the user is private</h3>
				<CFABORT>
			<CFELSE>
				Error: #userFeed.meta.error_message#<br>
				<CFABORT>
			</CFIF>
  </CFIF>
	<cfset myArrayLen = #arraylen(userfeed.data)#>

	<div class="container-fluid" style="border:0px dashed blue;">

	<CFIF URL.userid EQ "">
		<CFSET userInfoURL = "https://api.instagram.com/v1/users/#cookie.instaMyID#/?access_token=#cookie.instaAccessCode#">
	<CFELSE>
		<CFSET userInfoURL = "https://api.instagram.com/v1/users/#URL.userid#/?access_token=#cookie.instaAccessCode#">
	</CFIF>

	<cfhttp url="#userInfoURL#" method="get" resolveurl="true" result="userInfo"/>
	<CFSET currentUserInfo = deserializeJSON(#userInfo.fileContent#)>

  <img src="#currentUserInfo.data.profile_picture#" class="profilePic img-thumbnail">
	<div id="profileInfoContainer">
			<h2 id="userTitle">#currentUserInfo.data.full_name# Image Feed</h2>
			<br />
			<div class="countsDiv">
				<span class="label label-success">Images: #currentUserInfo.data.counts.media#</span>
				<span class="label label-info">Following: #currentUserInfo.data.counts.follows#</span>
				<span class="label label-primary">Followers: #currentUserInfo.data.counts.followed_by#</span>
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
				  <a href="userfeed.cfm?max_id=#userfeed.pagination.next_max_id#&access_token=#cookie.instaAccessCode#&user=#URL.user#&userid=#URL.userid#"><i class="fa fa-forward fa-3x"></i><br>Next</a>
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
