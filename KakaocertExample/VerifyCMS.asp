<%@ Language = "VBScript" %>
<% Option Explicit %>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 

<%
	'*************************************************************
	' 자동이체 출금동의 서명을 검증합니다.
	' - 서명검증시 전자서명 데이터 전문(signedData)이 반환됩니다.
	' - 카카오페이 서비스 운영정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류처리됩니다.
	'**************************************************************

	' Kakaocert 이용기관코드, Kakaocert 파트너 사이트에서 확인
	Dim clientCode : clientCode = "020040000050"	

	' 접수 아이디
	Dim receiptID : receiptID = "021060211283500001"
	

	On Error Resume Next

		Dim result : Set result = m_KakaocertService.VerifyCMS(clientCode, receiptID)

		If Err.Number <> 0 then
			Dim code : code = Err.Number
			Dim message : message =  Err.Description
			Err.Clears
		End If

	On Error GoTo 0

%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>자동이체 출금동의 서명검증</legend>
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