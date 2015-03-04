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
  #origImg {
    width: 30%;
    max-width: 305px;
    float: left;
    margin-left: 20px;
    margin-bottom: 20px;
    margin-right: 20px;
    border: 1px solid black;
  }
  #origLikesBox {
    width: 50%;
    float: left;
    border: 0px dashed blue;
  }
  #likesBox {
    width: 80%;
    float: left;
    margin-left: 20px;
  }
  .likersBox {
    width: 32.5%;
    min-width: 285px;
    height: 110px;
    float: left;
    border: 0px dashed red;
    margin-left: 2px;
    margin-bottom: 11px;
    border-bottom: 1px solid #CCC;
  }
  .profilePic {
    width: 25%;
    float: left;
    border: 1px solid black;

  }
  .profileInfo {
    width: 74%;
    height: 99px;
    float: left;
    border: 0px dashed green;
    padding-left: 7px;
    margin-Left: 1px;
  }
</style>
</head>

<body>

<CFOUTPUT>

<img src="#URL.imgURL#" id="origImg">
<div id="origLikesBox"><h1><i class="fa fa-heart" style="color:red;"></i> Likes Count: #URL.likesCount#</h1></div>
<div id="likesBox">

  <CFSET likersArrLen = ARRAYLEN(#likesDetails.Data#)>
  <CFLOOP from="1" to="#likersArrLen#" index="i">
    <div class="likersBox">

        <img src="#likesDetails.data[#i#].profile_picture#" class="profilePic">

      <div class="profileInfo">
        <a href="userfeed.cfm?userid=#likesDetails.data[#i#].id#&user=#likesDetails.data[#i#].full_name#"><b>#likesDetails.data[#i#].full_name#</b> <small>(#likesDetails.data[#i#].username#)</small><br /></a>
        <CFIF #TRIM(likesDetails.data[#i#].bio)# NEQ "">
            <small>Bio: <cf_strShorten var="#likesDetails.data[#i#].bio#" len="90" />#variables.shortenedTxt#</small>
        </CFIF>
        <br />
        <small><cf_strShorten var="#likesDetails.data[#i#].website#" len="35" />#variables.shortenedTxt#</small>
      </div>
    </div>
  </CFLOOP>

  <div style="clear:both;">&nbsp;</div>
</div>
</CFOUTPUT>

<!--- <CFDUMP var="#likesDetails#"> --->

</body>
</html>
