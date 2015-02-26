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
					content: "<i class='icon-map-marker'></i> <b><cfoutput>#imgDetails.data.location.name#</cfoutput></b>",
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
		.instaImgDiv {
			width: 846px;
			float: left;
			padding-left: 20px;
			padding-right: 20px;
			border: 0px dashed blue;
		}
		.nameBlock {
			display: block;
			border: 0px dashed green;
		}
		#profileCol {
			width: 140px;
			height: 645px;
			float: left;
			border: 0px solid red;
		}
		#imgCol {
			width: 660px;
			height: 645px;
			float: left;
			border: 0px solid red;

		}
		#commentsDiv {
			width: 660px;
			margin-left: 140px;
			border: 0px solid blue;
			float: left;
			padding-left: 10px;
			padding-right: 10px;
		}
		.instaImg {
			border: 2px solid black;
			margin-left: 10px;
		}
		.profilePic {
			border: 1px solid black;
			width: 120px;
			margin-left: 10px;
		}
		#feedDiv {
			border:0px solid red;
		}
		#userTitle {
			margin-left: 20px;
		}
		.likesAndCommentBlock {
			display: inline;
			border: 0px dashed red;
			float: left;
			margin-left: 10px;
		}
		#map-canvas {
			width: 640px;
			height: 500px;
			margin-left: 150px;
			float: left;
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
	<div class="instaImgDiv">
		<div class="nameBlock">
			<h2>#imgDetails.data.user.full_name#</h2>
		</div>
		<div id="profileCol">
		 	<img src="#imgDetails.data.user.profile_picture#" class="profilePic">
		 	<div class="likesAndCommentBlock">
				<i class="fa fa-heart" style="color: red;"></i>  #imgDetails.data.likes.count# | <i class="fa fa-comment"></i> #imgDetails.data.comments.count#
				<br>&nbsp;<br>
				<b>Filter:</b> #imgDetails.data.filter#<br>
				<b>Search Tags:</b><br>
				<cfset tagsArrayLen = #ARRAYLEN(imgDetails.data.tags)#>
				<cfloop from="1" to="#tagsArrayLen#" index="x">
					#imgDetails.data.tags[#x#]#<br>
				</cfloop>
				<br>
				<CFIF #ARRAYLEN(imgDetails.data.users_in_photo)# GT 0>
					<b>Tagged in Photo:</b><br>
					<CFSET taggedLen = ARRAYLEN(imgDetails.data.users_in_photo)>
					<CFLOOP from="1" to="#taggedLen#" index="t">
						#imgDetails.data.users_in_photo[#t#].user.full_name#<br>
					</CFLOOP>
				</CFIF>

			</div>
		</div>
		<div id="imgCol">
			<img src="#imgDetails.data.images.standard_resolution.url#" class="instaImg">
		</div>

		<div id="commentsDiv">
			<CFSET commentsLen = ARRAYLEN(imgDetails.data.comments.data)>
			<CFIF isDefined("imgDetails.data.caption.from.full_name")>
				<b>#imgDetails.data.caption.from.full_name#</b>
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

							<CFSET userSearchURL = "https://api.instagram.com/v1/users/search?q=#un#&count=1&access_token=#URL.access_token#">
							<cfhttp url="#userSearchURL#" method="get" resolveurl="true" result="userSearch"/>
							<CFSET userDetails = deserializeJSON(#userSearch.fileContent#)>
							<!---<CFDUMP var="#userDetails#">--->
							<CFSET newCaptionTxt = #REPLACE(#newCaptionTxt#, #un#, "<a href='userfeed.cfm?access_token=#URL.access_token#&userid=#userDetails.data[1].id#&user=#userDetails.data[1].full_name#'>" & #un# & "</a>")#>
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
							<CFSET newCaptionTxt = #REPLACE(#newCaptionTxt#, #tag#, "<a href=''>" & #tag# & "</a>")#>
						</CFLOOP>
				<!---End Search for hashtags --->
				#newCaptionTxt#<br>
			</CFIF>
			<CFLOOP from="1" to="#commentsLen#" index="i">
				<b>#imgDetails.data.comments.data[#i#].from.full_name#</b>
				#imgDetails.data.comments.data[#i#].text#<br />
			</CFLOOP>
			<br>
			<CFIF noLocation EQ "false">
				<CFIF #IsDefined("imgDetails.data.location.name")#>
					<i class="icon-map-marker"></i> <b>#imgDetails.data.location.name#</b>
				<CFELSE>
					<b>Location</b>
				</CFIF>
			</CFIF>
		</div>
		<div id="map-canvas"></div>


	</div>

	<CFDUMP var="#imgDetails#">
</CFOUTPUT>

</body>
