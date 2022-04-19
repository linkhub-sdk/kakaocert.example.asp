<!--#include virtual="/Kakaocert/Kakaocert.asp"--> 
<%
	'**************************************************************
	' Kakaocert API ASP SDK Example
	'
	' - 업데이트 일자 : 2022-04-19
	' - 연동 기술지원 연락처 : 1600-9854
	' - 연동 기술지원 이메일 : code@linkhubcorp.com
	'
	' <테스트 연동개발 준비사항>
	' 링크아이디(LinkID)와 비밀키(SecretKey)를 메일로 발급받은 인증정보를 참조하여 변경합니다.
	'**************************************************************

	' 링크아이디 
	Dim LinkID : LinkID = "TESTER"
	
	' 비밀키
	Dim SecretKey : SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="
	
	Dim m_KakaocertService : set m_KakaocertService = New KakaocertService
	
	' Kakaocert API 서비스 모듈 초기화
	m_KakaocertService.Initialize LinkID, SecretKey

	' 인증토큰 IP제한기능 사용여부, 권장(True)
	m_KakaocertService.IPRestrictOnOff = True

	' 카카오써트 API 서비스 고정 IP 사용여부, True-사용, False-미사용, 기본값(False)
	m_KakaocertService.useStaticIP = False
	
	' 로컬시스템 시간 사용여부 True-사용, False-미사용, 기본값(True)
	m_KakaocertService.UseLocalTimeYN = True
%>