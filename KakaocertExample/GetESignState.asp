<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	'**************************************************************
	' 전자서명 서명상태를 확인합니다.
	'**************************************************************

	' Kakaocert 이용기관코드, Kakaocert 파트너 사이트에서 확인
	Dim clientCode : clientCode = "020040000001"	

	' 접수 아이디
	Dim receiptID : receiptID = "021060416453400001"
	
	On Error Resume Next

	Dim result : Set result = m_KakaocertService.GetESignState(clientCode, receiptID)

	If Err.Number <> 0 Then
		Dim code : code = Err.Number
		Dim message : message = Err.Description
		Err.Clears
	End If	
	On Error GoTo 0 
%>
	<body>
		<div id="content">
			<p class="heading1">Response</p>
			<br/>
			<fieldset class="fieldset1">
				<legend>전자서명 서명상태 확인 </legend>
				<% 
					If code = 0 Then 
				%>
					<ul>
						<li>receiptID (접수 아이디) : <%=result.receiptID %> </li>
						<li>clientCode (이용기관코드) : <%=result.clientCode %> </li>
						<li>clientName (이용기관명) : <%=result.clientName %> </li>
						<li>state (상태코드) : <%=result.state %> </li>
						<li>regDT (등록일시) : <%=result.regDT %> </li>
						<li>expires_in (인증요청 만료시간(초)) : <%=result.expires_in %> </li>
						<li>callCenterNum (고객센터 번호) : <%=result.callCenterNum %> </li>


						<li>allowSimpleRegistYN (은행계좌 실명확인 생략여부	) : <%=result.allowSimpleRegistYN %> </li>
						<li>verifyNameYN (수신자 실명확인 여부) : <%=result.verifyNameYN %> </li>
						<li>payload (payload) : <%=result.payload %> </li>
						<li>requestDT (카카오 인증서버 등록일시) : <%=result.requestDT %> </li>
						<li>expireDT (인증요청 만료일시) : <%=result.expireDT %> </li>
						<li>tmstitle (인증요청 메시지 제목) : <%=result.tmstitle %> </li>
						<li>tmsmessage (인증요청 메시지 부가내용) : <%=result.tmsmessage %> </li>
						<li>subClientName (별칭) : <%=result.subClientName %> </li>
						<li>subClientCode (별칭코드) : <%=result.subClientCode %> </li>
						<li>viewDT (수신자 카카오톡 인증메시지 확인일시) : <%=result.viewDT %> </li>
						<li>completeDT (수신자 카카오톡 전자서명 완료일시	) : <%=result.completeDT %> </li>
						<li>verifyDT (전자서명 검증일시) : <%=result.verifyDT %> </li>
						<li>appUseYN (AppToApp 인증여부) : <%=result.appUseYN %> </li>
						<li>tx_id (카카오톡 트랜잭션아이디[앱스킴 호출용]) : <%=result.tx_id %> </li>
						
					</ul>	
					<%	
						Else
					%>
						<ul>
							<li>Response.code: <%=code%> </li>
							<li>Response.message: <%=message%> </li>
						</ul>	
					<%	
						End If
					%>
			</fieldset>
		 </div>
	</body>
</html>