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
    .origImg {
      width: 28%;
      float: left;
      margin-bottom: 20px;
      margin-right: 20px;
    }
    .origCommentsBox {
      width: 68%;
      float: left;
      border: 0px dashed blue;
    }
    #CommentsBox {
      width: 80%;
      float: left;
      margin-left: 0px;
    }
    .container {
      max-width: 850px;
    }
  </style>
</head>
<body>

<CFOUTPUT>
  <!---<CFDUMP var="#commentsDetails#">--->
<div class="container">
  <div class="well">
    <img src="#URL.imgURL#" class="origImg img-thumbnail">
    <div class="origCommentsBox">
      <h1>#cookie.instaImgUser#</h1>
      <h2><i class="fa fa-comment"></i> Comments Count: #URL.commentsCount#</h2>
      <h5>#cookie.instaImgCaption#</h5>
    </div>
    <div style="clear:both;"></div>
  </div>

  <CFSET CommentsArrLen = ARRAYLEN(#CommentsDetails.Data#)>
  <CFLOOP from="1" to="#CommentsArrLen#" index="i">
      <div class="media" style="margin-left: 20px;border-bottom:1px solid ##ccc;">
        <div class="media-left">
          <a href="##">
            <img class="media-object" src="#CommentsDetails.data[#i#].from.profile_picture#" style="width:65px;">
          </a>
        </div>
        <div class="media-body">
            <h4 class="media-heading">#commentsDetails.data[#i#].from.full_name# <small>(#commentsDetails.data[#i#].from.username#)</small></h4>
            #commentsDetails.data[#i#].text#
        </div>
      </div>
  </CFLOOP>

</div><!---End container--->

</CFOUTPUT>



</body>
</html>
