<CFPARAM name="URL.mediaID" Defualt="">

<CFIF URL.mediaID EQ "">
    <H2>Error: No Media ID specified in URL</H2>
    <CFABORT>
<CFELSE>
    <CFSET likesURL = "https://api.instagram.com/v1/media/#URL.mediaID#/likes?access_token=#cookie.instaAccessCode#">
    <cfhttp url="#likesURL#" method="get" resolveurl="true" />
    <CFSET likesDetails = deserializeJSON(#cfhttp.fileContent#)>
</CFIF>

<html>
<head>
  <title>Image Likes</title>

<style>
  .container {
    max-width: 850px;
  }
</style>
</head>

<body>

<CFOUTPUT>
<div class="container" style="border:0px dashed red;">

<div class="well">
  <img src="#URL.imgURL#" id="origImg" class="img-thumbnail">
  <div id="origLikesBox">
    <h1>#cookie.instaImgUser#</h1>
    <h2><i class="fa fa-heart" style="color:red;"></i> Likes Count: #URL.likesCount#</h2>
    <h5>#cookie.instaImgCaption#</h5>
  </div>
  <div style="clear:both;">&nbsp;</div>
</div>



<CFSET likersArrLen = ARRAYLEN(#likesDetails.Data#)>

<CFLOOP from="1" to="#likersArrLen#" index="i">
  <div class="likersBox">

    <img src="#likesDetails.data[#i#].profile_picture#" class="likeProfilePic img-thumbnail">
    <div class="likeProfileInfo">
      <a href="userfeed.cfm?userid=#likesDetails.data[#i#].id#&user=#likesDetails.data[#i#].full_name#"><b>#likesDetails.data[#i#].full_name#</b> <small>(#likesDetails.data[#i#].username#)</small><br /></a>
    </div>

  </div>
</CFLOOP>

  <div style="clear:both;">&nbsp;</div>
</div>
</CFOUTPUT>

<!---<CFDUMP var="#likesDetails#">--->

</body>
</html>
