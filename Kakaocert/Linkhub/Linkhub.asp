<!--#include file="json2.asp"--> 
<%
Const linkhub_ServiceURL = "https://auth.linkhub.co.kr"

class Linkhub

'http://support.microsoft.com/kb/299692
'UniStrToUTF8 - CopyMemory

Private m_linkID
Private m_secretKey
Private m_sha1

Public Property Let LinkID(ByVal value)
    m_linkID = value
End Property

Public Property Let SecretKey(ByVal value)
    m_secretKey = value
End Property

Public Sub Class_Initialize
	Set m_sha1 = GetObject( "script:" & Request.ServerVariables("APPL_PHYSICAL_PATH") + "Kakaocert\Linkhub" & "\sha1.wsc" )
End Sub

Public Sub Class_Terminate
	Set m_sha1 = Nothing 
End Sub 

Public function getTime
	Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
    Call winhttp1.Open("GET", linkhub_ServiceURL + "/Time")

    winhttp1.send
	winhttp1.WaitForResponse
    result = winhttp1.responseText


    If winhttp1.Status <> 200 Then
		Set er = parse(result)
		Err.raise er.code , "LINKHUB", er.message
    End If

    Set winhttp1 = Nothing
       
    getTime = result
End Function

public function getToken(serviceID , access_id, Scope, forwardIP)

	Set postObject = JSON.parse("{}")
    postObject.set "access_id", access_id
	postObject.Set "scope",Scope

	postData = toString(postObject)

	xDate = getTime
	Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
	Call winhttp1.Open("POST", linkhub_ServiceURL + "/" + serviceID + "/Token")
	Call winhttp1.setRequestHeader("x-lh-date", xdate)
	Call winhttp1.setRequestHeader("x-lh-version", "1.0")
    If forwardIP <> "" Then 
			Call winhttp1.setRequestHeader("x-lh-forwarded", forwardIP)
	End If 

	target = "POST" + Chr(10)
	target = target + m_sha1.b64_md5(postData) + Chr(10)
	target = target + xDate + Chr(10)
	target = target + "1.0" + Chr(10)
	target = target + "/" + serviceID + "/Token"

	Bearer =  m_sha1.b64_hmac_sha1(m_secretKey,target)

	Call winhttp1.setRequestHeader("Authorization", "LINKHUB " + m_linkID + " " + Bearer)

	winhttp1.send (postData)
	winhttp1.WaitForResponse
	result =  winhttp1.responseText
	
	If winhttp1.Status <> 200 Then
		Set er = parse(result)
		Err.raise er.code ,"LINKHUB", er.message
    End if
	Set getToken = parse(result)
	
	Set winhttp1 = nothing
	Set sha1 = Nothing

end function

Public Function GetBalance(BearerToken, serviceID )

    Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
    Call winhttp1.Open("GET", linkhub_ServiceURL + "/" + serviceID + "/Point")
    Call winhttp1.setRequestHeader("Authorization", "Bearer " + BearerToken)
    
    winhttp1.send
    winhttp1.WaitForResponse
    result = winhttp1.responseText
       
    If winhttp1.Status <> 200 Then
		Set er = parse(result)
		Err.raise er.code , "LINKHUB", er.message
    End If
    
    Set winhttp1 = Nothing
    Set parsedDic = parse(result)
    
    GetBalance = CDbl(parsedDic.remainPoint)

End Function

Public Function GetPartnerBalance(BearerToken, serviceID)

    Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
    Call winhttp1.Open("GET", linkhub_ServiceURL + "/" + serviceID + "/PartnerPoint")
    Call winhttp1.setRequestHeader("Authorization", "Bearer " + BearerToken)
    
    winhttp1.send
    winhttp1.WaitForResponse
    result = winhttp1.responseText
    
    If winhttp1.Status <> 200 Then
        Set er = parse(result)
		Err.raise er.code , "LINKHUB", er.message
    End If
    
    Set winhttp1 = Nothing
    Set parsedDic = parse(result)
    GetPartnerBalance = CDbl(parsedDic.remainPoint)

End Function

' 파트너 포인트 충전 팝업 URL - 2017/08/29 추가
Public Function GetPartnerURL(BearerToken, serviceID, TOGO)

    Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
    Call winhttp1.Open("GET", linkhub_ServiceURL + "/" + serviceID + "/URL?TG=" + TOGO)
    Call winhttp1.setRequestHeader("Authorization", "Bearer " + BearerToken)
    
    winhttp1.send
    winhttp1.WaitForResponse
    result = winhttp1.responseText
    
    If winhttp1.Status <> 200 Then
        Set er = parse(result)
		Err.raise er.code , "LINKHUB", er.message
    End If
    
    Set winhttp1 = Nothing
    Set parsedDic = parse(result)
    GetPartnerURL = parsedDic.url

End Function

public Function toString(object)
	toString = JSON.Stringify(object)
End Function

Public Function parse(jsonString)
	Set parse = JSON.parse(jsonString)
End Function

'end of class
end Class

%>