<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 

<%
	'*************************************************************
	' �������� ������ �����մϴ�.
	' - ��������� ���ڼ��� ������ ����(signedData)�� ��ȯ�˴ϴ�.
	' - �������� ��û�� �ۼ��� Token�� ���� ������ ��ȯ�Ǵ� signedData�� 
	'   ���Ͽ��θ� Ȯ���Ͽ� �������� ������ �Ϸ��մϴ�.
 	' - īī������ ���� ���å�� ���� ���� API�� 1ȸ�� ȣ���� �� �ֽ��ϴ�. ��õ��� ����ó���˴ϴ�.
	'**************************************************************

	' Kakaocert �̿����ڵ�, Kakaocert ��Ʈ�� ����Ʈ���� Ȯ��
	clientCode = "020040000001"	

	' ���� ���̵�
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
				<legend>�������� �������</legend>
				<% If code = 0 Then %>
					<ul>
						<li>receiptId (�������̵�) : <%=result.receiptId%> </li>
						<li>signedData (���ڼ��� ������) : <%=result.signedData%> </li>
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