<CFPARAM Name="URL.hashtag" default="">
<CFPARAM Name="maxTagID" default="">

<CFIF URL.hashtag EQ "">
		<h1>Error!: No hashtag provided :-(</h1>
		<CFABORT>
</CFIF>
<CFIF maxTagId EQ "">
  <cfset hashTagUrl ="https://api.instagram.com/v1/tags/#TRIM(url.hashtag)#/media/recent?access_token=#cookie.instaAccessCode#">
<CFELSE>
  <cfset hashTagUrl ="https://api.instagram.com/v1/tags/#TRIM(url.hashtag)#/media/recent?access_token=#cookie.instaAccessCode#&max_tag_id=#URL.maxTagID#">
</CFIF>
<cfhttp url="#hashTagURL#" method="get" resolveurl="true" />

<CFIF  #cfhttp.statusCode# NEQ '200 OK'>
		<!---<CFDUMP var="#cfhttp.fileContent#">--->
		<CFSET errorFeed = deserializeJSON(#cfhttp.fileContent#)>
		ERROR! <br>
		<CFDUMP var="#errorFeed#">
		<CFABORT>
<CFELSE>
		<CFSET hashTagFeed = deserializeJSON(#cfhttp.fileContent#)>
</CFIF>



<HTML>
<head>
	<title>Hashtag: <cfoutput>#url.hashtag#</cfoutput></title>
</head>
<body>
<CFOUTPUT>

<!---<CFDUMP var="#hashTagFeed#">--->


<cfset myArrayLen = #arraylen(hashTagfeed.data)#>

<div class="container-fluid" style="border:0px dashed blue;">

<div id="profileInfoContainer">
		<h2>Hashtag ###URL.hashTag#</h2>
</div>

<div style="clear:both;"></div>
<CFLOOP From="1" to="#myArrayLen#" index="i">
	<div class="instaImgDiv">
		<div class="nameBlock">
			<CFIF TRIM(hashTagFeed.data[#i#].user.full_name) EQ "">
				#hashTagfeed.data[#i#].user.username#
			<CFELSE>
			  #hashTagfeed.data[#i#].user.full_name#
			</CFIF>
		</div>
		<div class="likesAndCommentBlock">
			<i class="fa fa-heart" style="color: red;"></i>  #hashTagfeed.data[#i#].likes.count# | <i class="fa fa-comment"></i> #hashTagfeed.data[#i#].comments.count#
		</div>
		<a href="imgDetail.cfm?imgID=#hashTagfeed.data[#i#].id#">
			<img class="img-thumbnail" src="#hashTagfeed.data[#i#].images.low_resolution.url#">
			<CFIF #hashTagfeed.data[#i#].type# EQ "video">
				<i class="fa fa-youtube-play fa-4x instaVideo"></i>
			</CFIF>
	  </a>
	</div>
</CFLOOP>

<CFIF isDefined("hashTagfeed.pagination.next_max_tag_id")>
  <div class="instaImgDiv">
  	<div class="moreDiv">
  		<center>
  			  <a href="hashtag.cfm?maxTagID=#hashTagfeed.pagination.next_max_tag_id#&hashTag=#URL.hashtag#"><i class="fa fa-forward fa-3x"></i><br>Next</a>
  		</center>
  	</div>
  </div>
</CFIF>

<div style="clear:both"></div>
</div>
<br>
</CFOUTPUT>

</body>
</html>
