<CFPARAM Name="URL.userID" Default="">



<CFIF URL.userID EQ "">
    <CFSET URL.userID = #cookie.instaMyId#>
    <CFSET profileImgUrl = "#cookie.instaProfilePic#">
    <CFSET UserName = "#cookie.instaFullName#">
<CFELSE>
    <cfhttp url="https://api.instagram.com/v1/users/#URL.userid#/?access_token=#cookie.instaAccessCode#" method="get" resolveurl="true" result="userInfo"/>
    <CFSET currentUserInfo = deserializeJSON(#userInfo.fileContent#)>
    <CFSET profileImgUrl = "#currentUserInfo.data.profile_picture#">
    <CFSET UserName = "#currentUserInfo.data.full_name#">
</CFIF>


<CFSET followsURL = "https://api.instagram.com/v1/users/#URL.userID#/follows?access_token=#cookie.instaAccessCode#">
<cfhttp url="#followsURL#" method="get" resolveurl="true" />
<CFSET followsDetails = deserializeJSON(#cfhttp.fileContent#)>

<html>
<head>
  <title>Follows</title>

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
  <img src="#profileImgURL#" id="followsImg" class="img-thumbnail">
  <div id="origLikesBox">
    <h1>#UserName#</h1>
    <h2>Follows: #URL.count#</h2>
  </div>
  <div style="clear:both;">&nbsp;</div>
</div>

<!---<CFDUMP var="#followsDetails#">--->

<CFSET followsArrLen = ARRAYLEN(#followsDetails.Data#)>

<CFLOOP from="1" to="#followsArrLen#" index="i">
  <div class="followsBox">

    <img src="#followsDetails.data[#i#].profile_picture#" class="followProfilePic img-thumbnail">
    <div class="followProfileInfo">
      <a href="userfeed.cfm?userid=#followsDetails.data[#i#].id#&user=#followsDetails.data[#i#].full_name#"><b>#followsDetails.data[#i#].full_name#</b> <small>(#followsDetails.data[#i#].username#)</small><br /></a>
    </div>

  </div>
</CFLOOP>

  <div style="clear:both;">&nbsp;</div>
</div>
</CFOUTPUT>

<!---<CFDUMP var="#likesDetails#">--->

</body>
</html>
