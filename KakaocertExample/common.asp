<!--#include virtual="/Kakaocert/Kakaocert.asp"--> 
<%
	'**************************************************************
	' Kakaocert API ASP SDK Example
	'
	' - 업데이트 일자 : 2020-09-10
	' - 연동 기술지원 연락처 : 1600-9854 / 070-4304-2991
	' - 연동 기술지원 이메일 : code@linkhub.co.kr
	'
	' <테스트 연동개발 준비사항>
	' 링크아이디(LinkID)와 비밀키(SecretKey)를 메일로 발급받은 인증정보를 참조하여 변경합니다.
	'**************************************************************

	' 링크아이디 
	LinkID = "TESTER"
	
	' 비밀키
	SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="
	
	set m_KakaocertService = New KakaocertService
	
	' Kakaocert API 서비스 모듈 초기화
	m_KakaocertService.Initialize LinkID, SecretKey

	' 인증토큰 IP제한기능 사용여부, 권장(True)
	m_KakaocertService.IPRestrictOnOff = True

%>