<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 

<%
	'*************************************************************
	' 본인인증 서명을 검증합니다.
	'**************************************************************

	' Kakaocert 이용기관코드, Kakaocert 파트너 사이트에서 확인
	clientCode = "020040000001"	

	' 접수 아이디
	receiptID = "020090817154400001"
	

	On Error Resume Next

		Set result = m_KakaocertService.VerifyAuth(clientCode, receiptID)

		If Err.Number <> 0 then
			code = Err.Number
			message =  Err.Description
			Err.Clears
		End If

	On Error GoTo 0

%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>본인인증 서명검증</legend>
				<% If code = 0 Then %>
					<ul>
						<li>receiptId (접수아이디) : <%=result.receiptId%> </li>
						<li>signedData (전자서명 데이터) : <%=result.signedData%> </li>
					</ul>
				<%	Else  %>
					<ul>
						<li>Response.code: <%=code%> </li>
						<li>Response.message: <%=message%> </li>
					</ul>	
				<%	End If	%>
			</fieldset>
		 </div>
	</body>
</html>