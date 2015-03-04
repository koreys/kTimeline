<CFPARAM Name="URL.imgID" default="">
<CFPARAM Name="noLocation" default="false">

<CFIF URL.imgID EQ "">
	<H4>Error No URL.ImgID provided</h4>
	<cfabort>
<CFELSE>
	<CFSET imgURL = "https://api.instagram.com/v1/media/#URL.imgID#?access_token=#URL.access_token#">
</CFIF>

<cfhttp url="#imgURL#" method="get" resolveurl="true" />
<CFSET imgDetails = deserializeJSON(#cfhttp.fileContent#)>

<CFIF !IsDefined("imgDetails.data.location.latitude")>
	<CFSET noLocation = "true">
</CFIF>

<HTML>
<head>
	<title>Image Detail</title>
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
			max-width: 720px;
		}


		#map-canvas {
			width: 680px;
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

				<div style="clear:both;"></div>
			</div><!-- End Jumbotron -->


			<img src="#imgDetails.data.images.standard_resolution.url#" class="center-block">

			<div class="well well-sm" style="margin-top:5px;">
				<b>Likes:</b>
				<cfset likesArrayLen = #ARRAYLEN(imgDetails.data.likes.data)#>
				<cfloop from="1" to="#likesArrayLen#" index="x">
						<a href="userfeed.cfm?access_token=#cookie.instaAccessCode#&userid=#imgDetails.data.likes.data[#x#].id#&user=#imgDetails.data.likes.data[#x#].full_name#">#imgDetails.data.likes.data[#x#].full_name#</a>,
				</cfloop>
				<CFIF  #imgDetails.data.likes.count# GT #likesArrayLen#>
						<a href="likes.cfm?mediaID=#URL.imgID#&likesCount=#imgDetails.data.likes.count#&imgURL=#imgDetails.data.images.low_resolution.url#"><small><b>...See All Likes</b></small></a>
				</CFIF>

				<CFIF #ARRAYLEN(imgDetails.data.users_in_photo)# GT 0>
						<br />
						<b>Tagged in Photo:</b><br>
						<CFSET taggedLen = ARRAYLEN(imgDetails.data.users_in_photo)>
						<CFLOOP from="1" to="#taggedLen#" index="t">
								<a href="userfeed.cfm?access_token=#cookie.instaAccessCode#&userid=#imgDetails.data.users_in_photo[#t#].user.id#&user=#imgDetails.data.users_in_photo[#t#].user.full_name#">#imgDetails.data.users_in_photo[#t#].user.full_name#,</a>
						</CFLOOP>
				</CFIF>

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

	<CFDUMP var="#imgDetails#">
</CFOUTPUT>

</body>
