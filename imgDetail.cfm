<CFPARAM Name="URL.imgID" default="">
<CFPARAM Name="noLocation" default="false">
<CFPARAM Name="URL.likeIt" default="false">
<CFPARAM Name="URL.unLikeIt" default="false">
<CFPARAM Name="userHasLiked" default = "">


<CFIF URL.imgID EQ "">
	<H4>Error No URL.ImgID provided</h4>
	<cfabort>
<CFELSE>
	<CFSET imgURL = "https://api.instagram.com/v1/media/#URL.imgID#?access_token=#cookie.instaAccessCode#">
</CFIF>

<!---Make call and get all img details --->
<cfhttp url="#imgURL#" method="get" resolveurl="true" />
<CFSET imgDetails = deserializeJSON(#cfhttp.fileContent#)>

<CFIF isDefined("cookie.instaThisImgUser")>
	<cfcookie name="instaImgThisUser" expires="now">
	<cfcookie name="instaImgThisCaption" expires="now">
</CFIF>

<CFCOOKIE name="instaThisImgUser" value="#imgDetails.data.user.full_name#">
<CFCOOKIE name="instaThisImgCaption" value="#imgDetails.data.caption.text#">

<!--- Check if user has requested to like photo --->
<CFIF URL.likeIt EQ "true">
		<CFIF imgDetails.data.user_has_liked NEQ "true">
				<cfhttp url="https://api.instagram.com/v1/media/#URL.imgID#/likes" method="post" resolveurl="true" result="likeResult">
					<cfhttpparam type="formField" name="access_token" value="#cookie.instaAccessCode#" />
				</cfhttp>
				<CFSET userHasLiked = "true">
	  </CFIF>
</CFIF>

<!--- Check if user has requested to unlike photo --->
<CFIF URL.unLikeIt EQ "true">
	<CFIF imgDetails.data.user_has_liked EQ "true">
			<cfhttp url="https://api.instagram.com/v1/media/#URL.imgID#/likes?access_token=#cookie.instaAccessCode#" method="delete" resolveurl="true" result="dellikeResult" />
			<CFSET userHasLiked = "false">
	</CFIF>
</CFIF>





<CFIF !IsDefined("imgDetails.data.location.latitude")>
	<CFSET noLocation = "true">
</CFIF>

<HTML>
<head>
	<title>Image Detail</title>

	<CFIF imgDetails.data.type EQ "video">
			<!--- js and css for video player --->
			<link href="//vjs.zencdn.net/4.12/video-js.css" rel="stylesheet">
		  <script src="//vjs.zencdn.net/4.12/video.js"></script>
  </CFIF>

	<!--
	<script type="text/javascript">
		<CFOUTPUT>

		$( document ).ready(function() {

				console.log("Checking to see if photo is liked...");
				$.ajax({
					type: "GET",
					datatype: "jsonp",
					url: "https://api.instagram.com/v1/media/#URL.imgID#?access_token=#cookie.instaAccessCode#&callback=",
					success: function(data) {
						console.log("Success function fired. Data is: " + data)
						}
				});


				$( "##likeBtnAjax" ).click(function() {
					console.log( "Handler for .click() called." );

							$.ajax({
							  type: "POST",
							  url: "https://api.instagram.com/v1/media/#URL.imgID#/likes",
							  data: { "access_token": "#cookie.instaAccessCode#" },
								dataType: 'json',
								/*
								success: function(data) {
									console.log("The success function got called!! Here is data:" + data)
								}
								*/


							})


						$("##likeBtnAjax").html('<i id="likeBtnHeart" class="fa fa-heart"></i> Liked');

				});


		});

		</CFOUTPUT>
	</script>
  -->

	<CFIF noLocation EQ "false">
		<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAP5fLA7LpG7TNgnFbCtbTjxK8icRWHoTs"></script>

		<script type="text/javascript">


		  function initialize() {

		  	var myLatlng = new google.maps.LatLng(<CFOUTPUT>#imgDetails.data.location.latitude#, #imgDetails.data.location.longitude#</CFOUTPUT>);

			var mapOptions = {
			    center: myLatlng,
			    zoom: 12
			};


			var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

		    <CFIF isDefined("imgDetails.data.location.name")>
				var infowindow = new google.maps.InfoWindow({
					content: "<i class='fa fa-map-marker'></i> <b><cfoutput>#imgDetails.data.location.name#</cfoutput></b>",
					position: myLatlng
				});
				infowindow.open(map);

		    <CFELSE>
				var marker = new google.maps.Marker({
					position: myLatlng,
					map: map,
					title: "Hello World!"
				});
    		</CFIF>



		 }
		 google.maps.event.addDomListener(window, 'load', initialize);

		</script>

    </CFIF>

	<style>

		.container {
			max-width: 680px;
		}


		#map-canvas {
			width: 640px;
			height: 520px;
		}
		#map-canvas img {
			max-width: none;
		}

	</style>
</head>
<body>
<CFOUTPUT>
	<!---
	Status Code: #cfhttp.statusCode#<br />

	<CFIF isDefined("likeResult.fileContent")>
		LikeResult: #likeResult.fileContent# <br />
	</CFIF>

	<CFIF isDefined("dellikeResult.fileContent")>
		delLikeResult: #dellikeResult.fileContent# <br />
	</CFIF>
	--->


	<div class="container" style="border:0px dashed grey;">
			<div class="jumbotron">
				<img src="#imgDetails.data.user.profile_picture#" class="img-thumbnail" style="float:left;margin-right:20px;">
				<h2 style="display:inline;">
						#imgDetails.data.user.full_name#
						<small>
							<a href="userfeed.cfm?access_token=#cookie.instaAccessCode#&userid=#imgDetails.data.user.id#&user=#imgDetails.data.user.full_name#">(#imgDetails.data.user.username#)</a>
						</small>
				</h2>
				<br />
				<i class="fa fa-heart" style="color: red;"></i> #imgDetails.data.likes.count# | <i class="fa fa-comment"></i> #imgDetails.data.comments.count#
				<br />
				<b>Filter:</b> #imgDetails.data.filter#
				<br />
				<b>Posted:</b> #dateTimeFormat(dateAdd("s", #imgDetails.data.created_time#, DateConvert("utc2Local", createDateTime(1970, 1, 1, 0,0,0))), 'short')#
				<!---
				<br />
				<div class="btn btn-default" id="likeBtnAjax"><i class="fa fa-heart-o"></i> Like</div>
				--->

				<div style="clear:both;"></div>
			</div><!-- End Jumbotron -->

			<CFIF imgDetails.data.type EQ "Video">
				<video id="insta_video" class="video-js vjs-default-skin center-block vjs-big-play-centered"
					  controls preload="auto" width="640" height="640"
					  poster="#imgDetails.data.images.standard_resolution.url#"
					  data-setup='{"example_option":true}'>
					 <source src="#imgDetails.data.videos.standard_resolution.url#" type='video/mp4' />
					 <p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p>
				</video>
			<CFELSE>
					<img src="#imgDetails.data.images.standard_resolution.url#" class="center-block img-thumbnail">
			</CFIF>

			<!--- Begin Likes Well --->
			<div class="well well-sm" style="margin-top:5px;">
				<CFIF #userHasLiked# EQ "">
						<CFIF #imgDetails.data.user_has_liked# EQ "true">
								<a href="imgDetail.cfm?imgId=#url.imgID#&access_token=#cookie.instaAccessCode#&unLikeIt=true" class="btn btn-default" id="likeBtn"><i class="fa fa-heart" style="color:red;"></i> Liked</a>
						<CFELSE>
								<a href="imgDetail.cfm?imgId=#url.imgID#&access_token=#cookie.instaAccessCode#&likeIt=true" class="btn btn-default" id="likeBtn"><i class="fa fa-heart-o"></i> Like</a>
						</CFIF>
				<CFELSEIF #userHasLiked# EQ "true">
						<a href="imgDetail.cfm?imgId=#url.imgID#&access_token=#cookie.instaAccessCode#&unLikeIt=true" class="btn btn-default" id="likeBtn"><i class="fa fa-heart" style="color:red;"></i> Liked</a>
				<CFELSEIF #userHasLiked# EQ "false">
						<a href="imgDetail.cfm?imgId=#url.imgID#&access_token=#cookie.instaAccessCode#&likeIt=true" class="btn btn-default" id="likeBtn"><i class="fa fa-heart-o"></i> Like</a>
				</CFIF>

				<b>Likes:</b>
				<cfset likesArrayLen = #ARRAYLEN(imgDetails.data.likes.data)#>
				<cfloop from="1" to="#likesArrayLen#" index="x">
						<a href="userfeed.cfm?access_token=#cookie.instaAccessCode#&userid=#imgDetails.data.likes.data[#x#].id#&user=#imgDetails.data.likes.data[#x#].full_name#">#imgDetails.data.likes.data[#x#].username#</a>,
				</cfloop>
				<CFIF  #imgDetails.data.likes.count# GT #likesArrayLen#>
						<a href="likes.cfm?mediaID=#URL.imgID#&likesCount=#imgDetails.data.likes.count#&imgURL=#imgDetails.data.images.low_resolution.url#"><span class="pull-right"><small><b>...See All Likes</b></small></span></a>
				</CFIF>

				<CFIF #ARRAYLEN(imgDetails.data.users_in_photo)# GT 0>
						<br />
						<b>Tagged in Photo:</b><br>
						<CFSET taggedLen = ARRAYLEN(imgDetails.data.users_in_photo)>
						<CFLOOP from="1" to="#taggedLen#" index="t">
								<a href="userfeed.cfm?access_token=#cookie.instaAccessCode#&userid=#imgDetails.data.users_in_photo[#t#].user.id#&user=#imgDetails.data.users_in_photo[#t#].user.full_name#">#TRIM(imgDetails.data.users_in_photo[#t#].user.full_name)#,</a>
						</CFLOOP>
				</CFIF>
				<div class="clear:both;">&nbsp;</div>
			</div><!-- End Likers Well -->


			<div id="commentsDiv">
				<CFSET commentsLen = ARRAYLEN(imgDetails.data.comments.data)>
				<CFIF isDefined("imgDetails.data.caption.from.full_name")>
					<b><a href="userfeed.cfm?access_token=#cookie.instaAccessCode#&userid=#imgDetails.data.user.id#&user=#imgDetails.data.user.full_name#">#imgDetails.data.caption.from.full_name#</a></b>
					<!--- search Caption for @ usernames --->
							<cfset captionArray = #listToArray(imgDetails.data.caption.text, " ")#>
							<cfset captionArLen = ArrayLen(captionArray)>
							<!---<CFDUMP var="#captionArray#">--->
							<CFSET userNameAr = arrayNew(1)>
							<CFLOOP from="1" To="#captionArLen#" index="x">
								<CFIF TRIM(LEFT(captionArray[#x#],1)) EQ "@">
									<CFSET temp = ArrayAppend(userNameAr, #captionArray[#x#]#)>
								</CFIF>
							</CFLOOP>
							<!---<CFDUMP var="#userNameAr#">--->
							<CFSET newCaptionTxt = "#imgDetails.data.caption.text#">
							<CFLOOP array="#userNameAr#" index="un">

								<CFSET userSearchURL = "https://api.instagram.com/v1/users/search?q=#un#&count=1&access_token=#cookie.instaAccessCode#">
								<cfhttp url="#userSearchURL#" method="get" resolveurl="true" result="userSearch"/>
								<CFSET userDetails = deserializeJSON(#userSearch.fileContent#)>
								<!---<CFDUMP var="#userDetails#">--->
								<CFIF isDefined("userDetails.data[1].id")>
									<CFSET newCaptionTxt = #REPLACE(#newCaptionTxt#, #un#, "<a href='userfeed.cfm?access_token=#URL.access_token#&userid=#userDetails.data[1].id#&user=#userDetails.data[1].full_name#'>" & #un# & "</a>")#>
								</CFIF>
							</CFLOOP>
					<!---End Search for usernames --->

					<!--- search Caption for Hashtags --->
							<cfset hashtagArray = #listToArray(newCaptionTxt, " ")#>
							<cfset hashtagArLen = ArrayLen(hashtagArray)>
							<!---<CFDUMP var="#hashtagArray#">--->
							<CFSET tagsAr = arrayNew(1)>
							<CFLOOP from="1" To="#hashtagArLen#" index="x">
								<CFIF TRIM(LEFT(hashtagArray[#x#],1)) EQ "##">
									<CFSET temp = ArrayAppend(tagsAr, #hashtagArray[#x#]#)>
								</CFIF>
							</CFLOOP>
							<!---<CFDUMP var="#tagsAr#">--->
							<CFLOOP array="#tagsAr#" index="tag">
								<CFSET newCaptionTxt = #REPLACE(#newCaptionTxt#, #tag#, "<a href='hashtag.cfm?access_token=#URL.access_token#&hashtag=#tag#'>" & #tag# & "</a>")#>
							</CFLOOP>
					<!---End Search for hashtags --->
					#newCaptionTxt#<br>
				</CFIF>

				<CFLOOP from="1" to="#commentsLen#" index="i">
					<b><a href="userfeed.cfm?access_token=#URL.access_token#&userid=#imgDetails.data.comments.data[#i#].from.id#&user=#imgDetails.data.comments.data[#i#].from.full_name#">#imgDetails.data.comments.data[#i#].from.full_name#</a></b>
					#imgDetails.data.comments.data[#i#].text#<br />
				</CFLOOP>
				<CFIF isDeFined("imgDetails.data.comments.count")>
					<CFIF #imgDetails.data.comments.count# GT #commentsLen#>
						<a href="comments.cfm?mediaID=#URL.imgID#&CommentsCount=#imgDetails.data.comments.count#&imgURL=#imgDetails.data.images.low_resolution.url#">See More Comments...</a>
					</CFIF>
				</CFIF>
				<br>
				<CFIF noLocation EQ "false">
					<CFIF #IsDefined("imgDetails.data.location.name")#>
						<i class="fa fa-map-marker"></i> <b>#imgDetails.data.location.name#</b>
					<CFELSE>
						<b>Location</b>
					</CFIF>
				</CFIF>
			</div>

			<div id="map-canvas"></div>
		</div><!-- End Comments Div -->





	</div><!-- End Container fluid -->

	<!---<CFDUMP var="#imgDetails#">--->
</CFOUTPUT>

</body>
