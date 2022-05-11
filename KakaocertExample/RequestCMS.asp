<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
		<link rel="stylesheet" type="text/css" href="/Example.css" media="screen" />
		<title>Kakaocert SDK ASP Example.</title>
	</head>
<!--#include file="common.asp"--> 

<%
	'**************************************************************
	'  �ڵ���ü ��ݵ��� ���ڼ����� ��û�մϴ�.
    '**************************************************************

	' Kakaocert �̿����ڵ�, Kakaocert ��Ʈ�� ����Ʈ���� Ȯ��
	Dim clientCode : clientCode = "020040000001"		
	
	' App To App ��������
	' True - AppToApp �������, false-Talk Message �������
	Dim isAppUseYN : isAppUseYN = False

	' �ڵ���ü ��ݵ��� ��û���� ��ü
	Dim requestObj : Set requestObj = New RequestCMSObj

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

	' �����ָ�	
	requestObj.BankAccountName = "�����ָ�"
	
	' ���¹�ȣ, �̿����� ����ڰ� �ĺ������� ���������� ���¹�ȣ�� �Ϻθ� ����ŷ ó���� �� ���� (����) 371-02-6***85
	requestObj.BankAccountNum = "9-4324-5**7-58"
	
	' ������� �ڵ�	
	requestObj.BankCode = "004"

	' �����ڹ�ȣ, �̿������� �ο��� ���ĺ���ȣ
	requestObj.ClientUserID = "clientUserID-0423-01"

	'��Ī�ڵ�, �̿����� ������ ��Ī�ڵ� (��Ʈ�� ����Ʈ���� Ȯ�ΰ���)
	' īī���� �����޽��� �� "��û���" �׸� ǥ��
	' ��Ī�ڵ� �� ����� �̿����� �̿������� "��û���" �׸� ǥ��
	requestObj.SubClientID = ""

	' ������û �޽��� �ΰ�����, īī���� �����޽��� �� ��ܿ� ǥ��
	requestObj.TMSMessage = "TMSMessage0423"

	' ������û �޽��� ����, īī���� �����޽��� �� "��û����" �׸� ǥ��
	requestObj.TMSTitle = "TMSTitle 0423"

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

		Dim result : Set result = m_KakaocertService.RequestCMS(clientCode, requestObj, isAppUseYN)

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
				<legend>�ڵ���ü ��ݵ��� ���ڼ��� ��û</legend>
				<% If code = 0 Then %>
					<ul>
						<li>ReceiptId(�������̵�) : <%=result.receiptId%> </li>
						<li>tx_id (īī���� Ʈ����Ǿ��̵�[App��Ŵ ȣ���]) : <%=result.tx_id%> </li>
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