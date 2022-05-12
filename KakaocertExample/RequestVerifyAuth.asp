<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 

<%
	'**************************************************************
	' �������� ���ڼ����� ��û�մϴ�.
	' - https://www.kakaocert.com/docs/verifyAuth/API/asp#RequestVerifyAuth'
    '**************************************************************

	' Kakaocert �̿����ڵ�, Kakaocert ��Ʈ�� ����Ʈ���� Ȯ��
	Dim clientCode : clientCode = "020040000001"		
	
	' �������� ��û���� ��ü
	Dim requestObj : Set requestObj = New RequestVerifyAuthObj

	' ������ ��ȭ��ȣ, īī���� �����޽��� �� "������" �׸� ǥ��
	requestObj.CallCenterNum = "1600-8536"

	' �����͸�
	requestObj.CallCenterName = "�׽�Ʈ"

	' ������û ����ð�(��), �ִ밪 1000, ������û ����ð�(��) ���� �������� ���� ���·� ó����
	requestObj.Expires_in = 60

	' ������ �������, ���� : YYYYMMDD
	requestObj.ReceiverBirthDay = "19700101"

	' ������ �޴�����ȣ
	requestObj.ReceiverHP = "01012341234"

	' ������ ����
	requestObj.ReceiverName = "ȫ�浿"

	'��Ī�ڵ�, �̿����� ������ ��Ī�ڵ� (��Ʈ�� ����Ʈ���� Ȯ�ΰ���)
	' īī���� �����޽��� �� "��û���" �׸� ǥ��
	' ��Ī�ڵ� �� ����� �̿����� �̿������� "��û���" �׸� ǥ��
	requestObj.SubClientID = ""

	' ������û �޽��� �ΰ�����, īī���� �����޽��� �� ��ܿ� ǥ��
	requestObj.TMSMessage = "TMSMessage0423"

	' ������û �޽��� ����, īī���� �����޽��� �� "��û����" �׸� ǥ��
	requestObj.TMSTitle = "TMSTitle 0423"

	' ���ڼ����� ��ū ����
	requestObj.Token = "TMS Token 0423 "

	' ������� �Ǹ�Ȯ�� ��������
	' true : ������� �Ǹ�Ȯ�� ������ ����
	' false : ������� �Ǹ�Ȯ�� ������ ����
	' īī���� �����޽����� ������ ����ڰ� īī������ ��ȸ���� ���, īī������ ȸ����� ������ ���� ������� �Ǹ�Ȯ�� ������ ���� ���� ���ڼ��� ����
	requestObj.isAllowSimpleRegistYN = false

	' ������ �Ǹ�Ȯ�� ����
	' true : īī�����̰� ���������� ���� Ȯ���� ����� �Ǹ�� ReceiverName ���� ��
	' false : īī�����̰� ���������� ���� Ȯ���� ����� �Ǹ�� RecevierName ���� ������ ����.
	requestObj.isVerifyNameYN = True

  
	'PayLoad, �̿����� ������ payload(�޸�) ��
	requestObj.PayLoad = "Payload123"

	On Error Resume Next

		Dim receiptId : receiptId = m_KakaocertService.RequestVerifyAuth(clientCode, requestObj)

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
				<legend>�������� ��û</legend>
				<% If code = 0 Then %>
					<ul>
						<li>ReceiptId(�������̵�) : <%=receiptId%> </li>
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