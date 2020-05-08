<!--#include file="Linkhub.asp"--> 
<html>
<head>
	<title>jsSHA - SHA Hashes in 유티에프 JavaScript</title>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
</head>
<body>
<div>
<%
	set m_linkhub = new Linkhub
	m_linkhub.LinkID = "TESTER"
	m_linkhub.SecretKey = "rwtm9A5KjzRMePE9z9mpXl0UKshv3iSBs7v16N2Fs0s="

	'On Error Resume Next
	Set token = m_linkhub.getToken("POPBILL_TEST","1231212312",array("member","110"))
	
	If Err.Number <> 0 then
		Response.Write("Error Number -> " & Err.Number)
		Response.write("<BR>Error Source -> " & Err.Source)
		Response.Write("<BR>Error Desc   -> " & Err.Description)
		Err.Clears
	Else
		Response.write token.usercode
	End If

	On Error GoTo 0

	Response.write "<br/>"

	On Error Resume Next

	remainPoint = m_linkhub.getBalance(token.session_token,"POPBILL_TEST")

	If Err.Number <> 0 then
		Response.Write("Error Number -> " & Err.Number)
		Response.write("<BR>Error Source -> " & Err.Source)
		Response.Write("<BR>Error Desc   -> " & Err.Description)
		Err.Clears
	Else
		Response.write "RemainPoint : " + CStr(remainpoint)
	End If

	On Error GoTo 0

	Response.write "<br/>"

	On Error Resume Next

	remainPoint = m_linkhub.getPartnerBalance(token.session_token,"POPBILL_TEST")

	If Err.Number <> 0 then
		Response.Write("Error Number -> " & Err.Number)
		Response.write("<BR>Error Source -> " & Err.Source)
		Response.Write("<BR>Error Desc   -> " & Err.Description)
		Err.Clears
	Else
		Response.write "RemainPoint : " + CStr(remainpoint)
	End If

	On Error GoTo 0

%>
</div>
</body>
</html>