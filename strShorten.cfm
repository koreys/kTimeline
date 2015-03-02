<!---
Author: Korey Stanley
Simple little tag to output a shorten string
Usage: <CF_strShorten var="" len="" />
--->

<CFSET varName = trim(Attributes.var)>
<CFSET varLen = Attributes.len>

<!--- Check Length of varName, if longer then varLen shorten string --->
<CFIF Len(varName) GT varLen>
   <CFSET varNewLength = varLen - 3>
   <CFSET varNewName = Left(varName, varNewLength) & "...">
<CFSET caller.shortenedTxt = #varNewName#>
<CFELSE>
   <CFSET caller.shortenedTxt = #varName#>
</CFIF>
