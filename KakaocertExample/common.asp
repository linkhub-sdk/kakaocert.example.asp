<!--#include virtual="/Kakaocert/Kakaocert.asp"--> 
<%
	'**************************************************************
	' Kakaocert API ASP SDK Example
	'
	' - ������Ʈ ���� : 2020-09-10
	' - ���� ������� ����ó : 1600-9854 / 070-4304-2991
	' - ���� ������� �̸��� : code@linkhub.co.kr
	'
	' <�׽�Ʈ �������� �غ����>
	' ��ũ���̵�(LinkID)�� ���Ű(SecretKey)�� ���Ϸ� �߱޹��� ���������� �����Ͽ� �����մϴ�.
	'**************************************************************

	' ��ũ���̵� 
	LinkID = "TESTER"
	
	' ���Ű
	SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="
	
	set m_KakaocertService = New KakaocertService
	
	' Kakaocert API ���� ��� �ʱ�ȭ
	m_KakaocertService.Initialize LinkID, SecretKey

	' ������ū IP���ѱ�� ��뿩��, ����(True)
	m_KakaocertService.IPRestrictOnOff = True

%>