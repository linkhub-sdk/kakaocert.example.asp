<!--#include virtual="/Kakaocert/Kakaocert.asp"--> 
<%
	'**************************************************************
	' Kakaocert API ASP SDK Example
	'
	' - ������Ʈ ���� : 2022-04-19
	' - ���� ������� ����ó : 1600-9854
	' - ���� ������� �̸��� : code@linkhubcorp.com
	'
	' <�׽�Ʈ �������� �غ����>
	' ��ũ���̵�(LinkID)�� ���Ű(SecretKey)�� ���Ϸ� �߱޹��� ���������� �����Ͽ� �����մϴ�.
	'**************************************************************

	' ��ũ���̵� 
	Dim LinkID : LinkID = "TESTER"
	
	' ���Ű
	Dim SecretKey : SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="
	
	Dim m_KakaocertService : set m_KakaocertService = New KakaocertService
	
	' Kakaocert API ���� ��� �ʱ�ȭ
	m_KakaocertService.Initialize LinkID, SecretKey

	' ������ū IP���ѱ�� ��뿩��, ����(True)
	m_KakaocertService.IPRestrictOnOff = True

	' īī����Ʈ API ���� ���� IP ��뿩��, True-���, False-�̻��, �⺻��(False)
	m_KakaocertService.useStaticIP = False
	
	' ���ýý��� �ð� ��뿩�� True-���, False-�̻��, �⺻��(True)
	m_KakaocertService.UseLocalTimeYN = True
%>