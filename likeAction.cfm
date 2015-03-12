<cfprocessingdirective suppressWhiteSpace="true">
<CFPARAM Name="URL.imgID" Defualt="">

<CFSET imgInfoURL = "https://api.instagram.com/v1/media/#URL.imgID#?access_token=#cookie.instaAccessCode#">
<CFSET imgLikeURL = "https://api.instagram.com/v1/media/#URL.imgID#/likes">
<CFSET imgUnLikeURL = "https://api.instagram.com/v1/media/#URL.imgID#/likes?access_token=#cookie.instaAccessCode#">

<!--- First check if photo is already liked --->
<cfhttp url="#imgInfoURL#" method="get" resolveurl="true" />
<CFSET imgDetails = deserializeJSON(#cfhttp.fileContent#)>

<CFIF imgDetails.data.user_has_liked EQ "true">
    <CFSET likeIt = "False">
<CFELSE>
    <CFSET likeIt = "True">
</CFIF>

<!--- Check if user has requested to like photo then like it and return the result--->
<CFIF likeIt EQ "true">
		<cfhttp url="#imgLikeURL#" method="post" resolveurl="true" result="likeResult">
			  <cfhttpparam type="formField" name="access_token" value="#cookie.instaAccessCode#" />
		</cfhttp>
    <CFOUTPUT>
        <CFSET returnData = DeserializeJSON(#likeResult.fileContent#)>
        <CFIF returnData.meta.code EQ "200">
          ImgLiked
        <CFELSE>
          ImgNotLiked
        </CFIF>
    </CFOUTPUT>
<CFELSE>
		<cfhttp url="#imgUnlikeURL#" method="delete" resolveurl="true" result="delLikeResult" />
    <CFOUTPUT>
        <CFSET returnData = DeserializeJSON(#delLikeResult.fileContent#)>
        <CFIF returnData.meta.code EQ "200">
          ImgLikeRemoved
        <CFELSE>
          ImgLikeNotRemoved
        </CFIF>
    </CFOUTPUT>
</CFIF>
</cfprocessingdirective>
