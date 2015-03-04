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
	<style>
		.profilePic {
			width: 125px;
			margin-left: 20px;
			margin-bottom: 15px;
			border: 1px solid black;
			float: left;
		}
		.profileBioDiv {
			float: left;
			margin-left: 20px;
			border: 0px solid red;
			width: 95%;
		}
		.countsDiv {
			float: left;
			margin-left: 20px;
			margin-bottom: 10px;
			border: 0px solid red;
			width: 95%;
		}
		.instaImgDiv {
			width: 346px;
			float: left;
			padding-left: 20px;
			padding-right: 20px;
			border: 0px solid blue;
			margin-bottom: 15px;
		}
		.moreDiv {
			width: 306px;
			height: 306px;
			padding-top: 45px;
			margin-top: 20px;
			border: 2px solid black;
			font-size: 50px;
			color: #CCC;
		}
		.nameBlock {
			display: inline;
			border: 0px dashed blue;
			float: left;
		}
		.likesAndCommentBlock {
			display: inline;
			border: 0px dashed red;
			float: right;
			text-align: right;
		}
		.instaImg {
			border: 1px solid black;
		}
		#feedDiv {
			border: 0px solid red;
		}
		#userTitle {
			margin-left: 20px;
			margin-top: 0px;
			float: left;
			width: 95%;
		}
		#profileInfoContainer {
			width: 80%;
			border: 0px solid green;
			float: left;
			height: 125px;
		}

	</style>
</head>
<body>
<CFOUTPUT>
	<!---
	Status Code: #cfhttp.statusCode#<br />
	Current feedURL: #feedURL#<br>
	--->

 <CFSET UserFeed = deserializeJSON(#cfhttp.fileContent#)>
 <!---<CFDUMP var="#UserFeed#">--->

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

	<div id="feedDiv">

	<CFIF URL.userid EQ "">
		<CFSET userInfoURL = "https://api.instagram.com/v1/users/#cookie.instaMyID#/?access_token=#cookie.instaAccessCode#">
	<CFELSE>
		<CFSET userInfoURL = "https://api.instagram.com/v1/users/#URL.userid#/?access_token=#cookie.instaAccessCode#">
	</CFIF>

	<cfhttp url="#userInfoURL#" method="get" resolveurl="true" result="userInfo"/>
	<CFSET currentUserInfo = deserializeJSON(#userInfo.fileContent#)>

  <img src="#currentUserInfo.data.profile_picture#" class="profilePic">
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
				#userfeed.data[#i#].user.full_name#
			</div>
			<div class="likesAndCommentBlock">
				<i class="fa fa-heart" style="color: red;"></i>  #userfeed.data[#i#].likes.count# | <i class="fa fa-comment"></i> #userfeed.data[#i#].comments.count#
			</div>
			<a href="imgDetail.cfm?imgID=#userfeed.data[#i#].id#&access_token=#cookie.instaAccessCode#">
		    	<img class="instaImg" src="#userfeed.data[#i#].images.low_resolution.url#">
		    </a>
		</div>
	</CFLOOP>

	<div class="instaImgDiv">
		<div class="moreDiv">
			<center>
				<CFIF isDefined("userfeed.pagination.next_max_id")>
				  <a href="userfeed.cfm?max_id=#userfeed.pagination.next_max_id#&access_token=#cookie.instaAccessCode#&user=#URL.user#&userid=#URL.userid#"><i class="fa fa-play-circle-o fa-3x"></i><br>Next</a>
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
