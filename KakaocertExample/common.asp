<!--#include virtual="/Kakaocert/Kakaocert.asp"--> 
<%
	'**************************************************************
	' Kakaocert API ASP SDK Example
	'
	' - ������Ʈ ���� : 2021-06-02
	' - ���� ������� ����ó : 1600-9854 / 070-4304-2991
	' - ���� ������� �̸��� : code@linkhub.co.kr
	'
	' <�׽�Ʈ �������� �غ����>
	' ��ũ���̵�(LinkID)�� ���Ű(SecretKey)�� ���Ϸ� �߱޹��� ���������� �����Ͽ� �����մϴ�.
	'**************************************************************

	' ��ũ���̵� 
	Dim LinkID : LinkID = "KAKAOCERT0406"
	
	' ���Ű
	Dim SecretKey : SecretKey = "9HOTRlrOipIPRGkDdELwYnESP4XTOGZbXrD67FvNyqU="
	
	Dim m_KakaocertService : set m_KakaocertService = New KakaocertService
	
	' Kakaocert API ���� ��� �ʱ�ȭ
	m_KakaocertService.Initialize LinkID, SecretKey

	' ������ū IP���ѱ�� ��뿩��, ����(True)
	m_KakaocertService.IPRestrictOnOff = True

	' īī����Ʈ API ���� ���� IP ��뿩��(GA), True-���, False-�̻��, �⺻��(False)
	m_KakaocertService.useStaticIP = False

%>