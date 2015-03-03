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
		.instaImgDiv {
			width: 346px;
			float: left;
			padding-left: 20px;
			padding-right: 20px;
			border: 0px solid blue;
			margin-bottom: 15px;
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
	<h2 id="userTitle">#URL.user# Recent Images</h2>
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
	<div style="clear:both"></div>
	</div>
	<br>
	<CFIF isDefined("userfeed.pagination.next_max_id")>
		 <a href="userfeed.cfm?max_id=#userfeed.pagination.next_max_id#&access_token=#cookie.instaAccessCode#&user=#URL.user#">See More</a>
	</CFIF>
</CFOUTPUT>

</body>
</html>
