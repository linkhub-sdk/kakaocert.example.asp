<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 
<%
	'**************************************************************
	' ���ڼ��� ������¸� Ȯ���մϴ�.
	'**************************************************************

	' Kakaocert �̿����ڵ�, Kakaocert ��Ʈ�� ����Ʈ���� Ȯ��
	Dim clientCode : clientCode = "020040000001"	

	' ���� ���̵�
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
				<legend>���ڼ��� ������� Ȯ�� </legend>
				<% 
					If code = 0 Then 
				%>
					<ul>
						<li>receiptID (���� ���̵�) : <%=result.receiptID %> </li>
						<li>clientCode (�̿����ڵ�) : <%=result.clientCode %> </li>
						<li>clientName (�̿�����) : <%=result.clientName %> </li>
						<li>state (�����ڵ�) : <%=result.state %> </li>
						<li>regDT (����Ͻ�) : <%=result.regDT %> </li>
						<li>expires_in (������û ����ð�(��)) : <%=result.expires_in %> </li>
						<li>callCenterNum (������ ��ȣ) : <%=result.callCenterNum %> </li>


						<li>allowSimpleRegistYN (������� �Ǹ�Ȯ�� ��������	) : <%=result.allowSimpleRegistYN %> </li>
						<li>verifyNameYN (������ �Ǹ�Ȯ�� ����) : <%=result.verifyNameYN %> </li>
						<li>payload (payload) : <%=result.payload %> </li>
						<li>requestDT (īī�� �������� ����Ͻ�) : <%=result.requestDT %> </li>
						<li>expireDT (������û �����Ͻ�) : <%=result.expireDT %> </li>
						<li>tmstitle (������û �޽��� ����) : <%=result.tmstitle %> </li>
						<li>tmsmessage (������û �޽��� �ΰ�����) : <%=result.tmsmessage %> </li>
						<li>subClientName (��Ī) : <%=result.subClientName %> </li>
						<li>subClientCode (��Ī�ڵ�) : <%=result.subClientCode %> </li>
						<li>viewDT (������ īī���� �����޽��� Ȯ���Ͻ�) : <%=result.viewDT %> </li>
						<li>completeDT (������ īī���� ���ڼ��� �Ϸ��Ͻ�	) : <%=result.completeDT %> </li>
						<li>verifyDT (���ڼ��� �����Ͻ�) : <%=result.verifyDT %> </li>
						<li>appUseYN (AppToApp ��������) : <%=result.appUseYN %> </li>
						<li>tx_id (īī���� Ʈ����Ǿ��̵�[�۽�Ŵ ȣ���]) : <%=result.tx_id %> </li>
						
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