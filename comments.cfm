<CFPARAM name="URL.mediaID" Defualt="">

<CFIF URL.mediaID EQ "">
    <H2>Error: No Media ID specified in URL</H2>
    <CFABORT>
<CFELSE>
    <CFSET commentsURL = "https://api.instagram.com/v1/media/#URL.mediaID#/comments?access_token=#cookie.instaAccessCode#">
    <cfhttp url="#commentsURL#" method="get" resolveurl="true" />
    <CFSET commentsDetails = deserializeJSON(#cfhttp.fileContent#)>
</CFIF>

<html>
<head>
  <title>Image Comments</title>
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
    #origCommentsBox {
      width: 50%;
      float: left;
      border: 0px dashed blue;
    }
    #CommentsBox {
      width: 80%;
      float: left;
      margin-left: 0px;
    }
    .commentBox {
      width: 98%;
      min-width: 500px;
      height: 110px;
      float: left;
      border: 0px dashed red;
      margin-left: 20px;
      margin-bottom: 5px;
      border-bottom: 1px solid #CCC;
    }
    .profilePic {
      width: 90px;
      float: left;
      border: 1px solid black;

    }
    .commentTxt {
      width: 85%;
      height: 109px;
      float: left;
      border: 0px dashed green;
      padding-left: 7px;
      margin-Left: 1px;
    }
  </style>
</head>
<body>

<CFOUTPUT>
  <!---<CFDUMP var="#commentsDetails#">--->

  <img src="#URL.imgURL#" id="origImg">
  <div id="origCommentsBox">
    <h1><i class="fa fa-comment"></i> Comments Count: #URL.commentsCount#</h1>
  </div>

  <div id="CommentsBox">

    <CFSET CommentsArrLen = ARRAYLEN(#CommentsDetails.Data#)>
    <CFLOOP from="1" to="#CommentsArrLen#" index="i">
      <div class="commentBox">

        <img src="#CommentsDetails.data[#i#].from.profile_picture#" class="profilePic">

        <div class="commentTxt">
          <a href="userfeed.cfm?userid=#commentsDetails.data[#i#].from.id#&user=#commentsDetails.data[#i#].from.full_name#"><b>#commentsDetails.data[#i#].from.full_name#</b> <small>(#commentsDetails.data[#i#].from.username#)</small></a><br />
            <small>#dateTimeFormat(dateAdd("s", #commentsDetails.data[#i#].created_time#, DateConvert("utc2Local", createDateTime(1970, 1, 1, 0,0,0))), 'short')#:</small>
            #commentsDetails.data[#i#].text#
          <br />
        </div>
      </div>
    </CFLOOP>

    <div style="clear:both;">&nbsp;</div>

  </div>

</CFOUTPUT>



</body>
</html>
