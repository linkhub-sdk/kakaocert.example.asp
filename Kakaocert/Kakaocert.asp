<!--#include file="Linkhub/Linkhub.asp"--> 
<%
Application("LINKHUB_TOKEN_SCOPE_KAKAOCERT") = Array("member","310","320","330")
Const ServiceID = "KAKAOCERT"
Const ServiceURL = "https://kakaocert-api.linkhub.co.kr"

Const APIVersion = "1.0"
Const adTypeBinary = 1
Const adTypeText = 2


Class KakaocertService

	Private m_TokenDic
	Private m_Linkhub
	Private m_IPRestrictOnOff


	Public Property Let IPRestrictOnOff(ByVal value)
		m_IPRestrictOnOff = value
	End Property

	Public Sub Class_Initialize
		
		On Error Resume next
		If  Not(KAKAOCERT_TOKEN_CACHE Is Nothing) Then
			Set m_TokenDic = KAKAOCERT_TOKEN_CACHE
		Else
			Set m_TokenDic = server.CreateObject("Scripting.Dictionary")
		End If
		On Error GoTo 0
		If isEmpty( m_TokenDic) Then
			Set m_TokenDic = server.CreateObject("Scripting.Dictionary")
		End If
		
		m_IPRestrictOnOff = True
		Set m_Linkhub = New Linkhub
		
	End Sub

	Public Sub Class_Terminate
		Set m_Linkhub = Nothing 
	End Sub 

	Private Property Get m_scope
		m_scope = Application("LINKHUB_TOKEN_SCOPE_KAKAOCERT")
	End Property

	Public Sub AddScope(scope)
		t = Application("LINKHUB_TOKEN_SCOPE_KAKAOCERT")
		ReDim Preserve t(Ubound(t)+1)
		t(Ubound(t)) = scope
		Application("LINKHUB_TOKEN_SCOPE_KAKAOCERT") = t
	End Sub

	Public Sub Initialize(linkID, SecretKey )
		m_Linkhub.LinkID = linkID
		m_Linkhub.SecretKey = SecretKey
	End Sub

	Public Function getSession_token(ClientCode)
		refresh = False
		Set m_Token = Nothing
		
		If m_TokenDic.Exists(ClientCode) Then 
			Set m_Token = m_TokenDic.Item(ClientCode)
		End If
		
		If m_Token Is Nothing Then
			refresh = True
		Else
			'CheckScope
			For Each scope In m_scope
				If InStr(m_Token.strScope,scope) = 0 Then
					refresh = True
					Exit for
				End if
			Next
			If refresh = False then
				Dim utcnow
				utcnow = CDate(Replace(left(m_linkhub.getTime,19),"T" , " " ))
				refresh = CDate(Replace(left(m_Token.expiration,19),"T" , " " )) < utcnow
			End if
		End If
		
		If refresh Then
			If m_TokenDic.Exists(ClientCode) Then m_TokenDic.remove ClientCode
			Set m_Token = m_Linkhub.getToken(ServiceID, ClientCode, m_scope, IIf(m_IPRestrictOnOff, "", "*"))
			m_Token.set "strScope", Join(m_scope,"|")
			m_TokenDic.Add ClientCode, m_Token
		End If
		
		getSession_token = m_Token.session_token
	End Function


	'Private Functions
	Public Function httpGET(url , BearerToken , UserID )
		Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")
		Call winhttp1.Open("GET", ServiceURL + url, false)
		
		Call winhttp1.setRequestHeader("Authorization", "Bearer " + BearerToken)
		Call winhttp1.setRequestHeader("x-pb-version", APIVersion)
		
		winhttp1.Send
		winhttp1.WaitForResponse
		result = winhttp1.responseText

		If winhttp1.Status <> 200 Then
			Set winhttp1 = Nothing
			Set parsedDic = m_Linkhub.parse(result)
			Err.raise parsedDic.code, "KAKAOCERT", parsedDic.message
		End If
		
		Set winhttp1 = Nothing
		
		Set httpGET = m_Linkhub.parse(result)
	End Function


	Public Function httpPOST(url , BearerToken , override , postdata ,  UserID)
		
		Set winhttp1 = CreateObject("WinHttp.WinHttpRequest.5.1")

		Call winhttp1.Open("POST", ServiceURL + url)
		Call winhttp1.setRequestHeader("x-pb-version", APIVersion)
		Call winhttp1.setRequestHeader("Content-Type", "Application/json")
		
		If BearerToken <> "" Then
			Call winhttp1.setRequestHeader("Authorization", "Bearer " + BearerToken)
		End If

		xDate = m_linkhub.getTime
		Call winhttp1.setRequestHeader("x-lh-date", xDate)
		Call winhttp1.setRequestHeader("x-lh-version", "1.0")
	

		target = "POST" + Chr(10)
		target = target + m_Linkhub.b64md5(postData) + Chr(10)
		target = target + xDate + Chr(10)
		target = target + "1.0" + Chr(10)
		
		auth_target =  m_Linkhub.b64hmacsha1(m_Linkhub.SecretKey, target)

		Call winhttp1.setRequestHeader("x-kc-auth", m_Linkhub.LinkID + " " +auth_target)

		winhttp1.Send (postdata)
		winhttp1.WaitForResponse
		result = winhttp1.responseText
		
		If winhttp1.Status <> 200 Then
			Set winhttp1 = Nothing
			Set parsedDic = m_Linkhub.parse(result)
			Err.raise parsedDic.code, "KAKAOCERT", parsedDic.message
		End If
		
		Set winhttp1 = Nothing
		Set httpPOST = m_Linkhub.parse(result)
	End Function

	Private Function StringToBytes(Str)
	  Dim Stream : Set Stream = Server.CreateObject("ADODB.Stream")
	  Stream.Type = adTypeText
	  Stream.Charset = "UTF-8"
	  Stream.Open
	  Stream.WriteText Str
	  Stream.Flush
	  Stream.Position = 0
	  Stream.Type = adTypeBinary
	  buffer= Stream.Read
	  Stream.Close
	  'Remove BOM.
	  Set Stream = Server.CreateObject("ADODB.Stream")
	  Stream.Type = adTypeBinary
	  Stream.Open
	  Stream.write buffer
	  Stream.Flush
	  Stream.Position = 3
	  StringToBytes= Stream.Read
	  Stream.Close
	  Set Stream = Nothing
	 
	End Function

	Private Function GetFile(FileName)
		Dim Stream: Set Stream = CreateObject("ADODB.Stream")
		Stream.Type = adTypeBinary
		Stream.Open
		Stream.LoadFromFile FileName
		GetFile = Stream.Read
		Stream.Close
	End Function

	Private Function GetOnlyFileName(ByVal FilePath ) 
		 Temp = Split(FilePath, "\")
		 GetOnlyFileName = Split(FilePath, "\")(UBound(Temp))
	End Function

	Private Function IIf(condition , trueState,falseState)
		If condition Then 
			IIf = trueState
		Else
			IIf = falseState
		End if
	End Function
	public Function toString(object)
		toString = m_Linkhub.toString(object)
	End Function

	Public Function parse(jsonString)
		Set parse = m_Linkhub.parse(jsonString)
	End Function

	Public Function RequestESign(ClientCode, ByRef RequestESignObj, IsAppUseYN)
		
		RequestESignObj.isAppUseYN = IsAppUseYN

		Set tmpDic = RequestESignObj.toJsonInfo

		postdata = toString(tmpDic)

		Set infoTmp = New ResponseESign
		
		Set result = httpPOST("/SignToken/Request", getSession_token(ClientCode), "", postdata, "")

		infoTmp.fromJsonInfo result

		Set RequestESign = infoTmp

	End Function 

	Public Function RequestVerifyAuth(ClientCode, ByRef RequestVerifyAuthObj)
		
		Set tmpDic = RequestVerifyAuthObj.toJsonInfo

		postdata = toString(tmpDic)
		
		Set result = httpPOST("/SignIdentity/Request", getSession_token(ClientCode), "", postdata, "")

		RequestVerifyAuth = result.receiptId

	End Function

	Public Function RequestCMS(ClientCode, ByRef RequestCMSObj)
		
		Set tmpDic = RequestCMSObj.toJsonInfo

		postdata = toString(tmpDic)
		
		Set result = httpPOST("/SignDirectDebit/Request", getSession_token(ClientCode), "", postdata, "")

		RequestCMS = result.receiptId

	End Function

	Public Function GetESignState(ClientCode, ReceiptID)
		If ClientCode = "" Then
			Err.Raise -99999999, "KAKAOCERT", "이용기관코드가 입력되지 않았습니다."
		End If

		If ReceiptID = "" Then
			Err.Raise -99999999, "KAKAOCERT", "접수아이디가 입력되지 않았습니다."
		End If

		uri = "/SignToken/Status/" + ReceiptID

		Set infoTmp = New ResultESignObj

		Set result = httpGET(uri, getSession_token(ClientCode), "")

		infoTmp.fromJsonInfo result
		Set GetESignState = infoTmp
	End Function 


	Public Function GetCMSState(ClientCode, ReceiptID)
		If ClientCode = "" Then
			Err.Raise -99999999, "KAKAOCERT", "이용기관코드가 입력되지 않았습니다."
		End If

		If ReceiptID = "" Then
			Err.Raise -99999999, "KAKAOCERT", "접수아이디가 입력되지 않았습니다."
		End If


		Set infoTmp = New ResultCMSObj

		Set result = httpGET("/SignDirectDebit/Status/" + ReceiptID, getSession_token(ClientCode), "")

		infoTmp.fromJsonInfo result
		Set GetCMSState = infoTmp
	End Function 

	Public Function GetVerifyAuthState(ClientCode, ReceiptID)
		If ClientCode = "" Then
			Err.Raise -99999999, "KAKAOCERT", "이용기관코드가 입력되지 않았습니다."
		End If

		If ReceiptID = "" Then
			Err.Raise -99999999, "KAKAOCERT", "접수아이디가 입력되지 않았습니다."
		End If


		Set infoTmp = New ResultVerifyAuthObj

		Set result = httpGET("/SignIdentity/Status/" + ReceiptID, getSession_token(ClientCode), "")

		infoTmp.fromJsonInfo result
		Set GetVerifyAuthState = infoTmp
	End Function 


	Public Function VerifyESign(ClientCode, ReceiptID, Signature)
		If ClientCode = "" Then
			Err.Raise -99999999, "KAKAOCERT", "이용기관코드가 입력되지 않았습니다."
		End If

		If ReceiptID = "" Then
			Err.Raise -99999999, "KAKAOCERT", "접수아이디가 입력되지 않았습니다."
		End If

		uri = "/SignToken/Verify/" + ReceiptID

		If Signature <> "" Then
			uri = uri+"/"+Signature
		End If 

		Set infoTmp = New ResponseVerify

		Set result = httpGET(uri, getSession_token(ClientCode), "")

		infoTmp.fromJsonInfo result
		Set VerifyESign = infoTmp
	End Function 

	Public Function VerifyCMS(ClientCode, ReceiptID)
		If ClientCode = "" Then
			Err.Raise -99999999, "KAKAOCERT", "이용기관코드가 입력되지 않았습니다."
		End If

		If ReceiptID = "" Then
			Err.Raise -99999999, "KAKAOCERT", "접수아이디가 입력되지 않았습니다."
		End If


		Set infoTmp = New ResponseVerify

		Set result = httpGET("/SignDirectDebit/Verify/" + ReceiptID, getSession_token(ClientCode), "")

		infoTmp.fromJsonInfo result
		Set VerifyCMS = infoTmp
	End Function 

	Public Function VerifyAuth(ClientCode, ReceiptID)
		If ClientCode = "" Then
			Err.Raise -99999999, "KAKAOCERT", "이용기관코드가 입력되지 않았습니다."
		End If

		If ReceiptID = "" Then
			Err.Raise -99999999, "KAKAOCERT", "접수아이디가 입력되지 않았습니다."
		End If


		Set infoTmp = New ResponseVerify

		Set result = httpGET("/SignIdentity/Verify/" + ReceiptID, getSession_token(ClientCode), "")

		infoTmp.fromJsonInfo result
		Set VerifyAuth = infoTmp
	End Function 

End Class

Class ResponseESign
	Public tx_id
	Public receiptId

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		receiptId = jsonInfo.receiptId
		tx_id = jsonInfo.tx_id
		On Error GoTo 0
	End Sub
End Class

Class ResponseVerify
	Public signedData
	Public receiptId

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		receiptId = jsonInfo.receiptId
		signedData = jsonInfo.signedData
		On Error GoTo 0
	End Sub
End Class


Class RequestESignObj

	public CallCenterNum
	public Expires_in
	public PayLoad
	public ReceiverBirthDay
	public ReceiverHP
	public ReceiverName
	public SubClientID
	public TMSMessage
	public TMSTitle
	public Token
	public isAllowSimpleRegistYN
	public isVerifyNameYN
	Public isAppUseYN

	Public Function toJsonInfo()
		Set toJsonInfo = JSON.parse("{}")
		toJsonInfo.Set "CallCenterNum", CallCenterNum
		toJsonInfo.Set "Expires_in", Expires_in
		toJsonInfo.Set "PayLoad", PayLoad
		toJsonInfo.Set "ReceiverBirthDay", ReceiverBirthDay
		toJsonInfo.Set "ReceiverHP", ReceiverHP
		toJsonInfo.Set "ReceiverName", ReceiverName
		toJsonInfo.Set "SubClientID", SubClientID
		toJsonInfo.Set "TMSMessage", TMSMessage
		toJsonInfo.Set "TMSTitle", TMSTitle
		toJsonInfo.Set "Token", Token
		toJsonInfo.Set "isAllowSimpleRegistYN", isAllowSimpleRegistYN
		toJsonInfo.Set "isVerifyNameYN", isVerifyNameYN
		toJsonInfo.Set "isAppUseYN", isAppUseYN
	End Function 

End Class

Class ResultESignObj

	public receiptID
	public regDT
	public state
	public expires_in
	public callCenterNum

	public allowSimpleRegistYN
	public verifyNameYN
	public payload
	public requestDT
	public expireDT
	public clientCode
	public clientName
	public tmstitle
	public tmsmessage


	public subClientName
	public subClientCode
	public viewDT
	public completeDT
	public verifyDT
	public appUseYN
	Public tx_id

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		receiptID = jsonInfo.receiptID
		regDT = jsonInfo.regDT
		state = jsonInfo.state
		receiverHP = jsonInfo.receiverHP
		receiverName = jsonInfo.receiverName
		receiverBirthday = jsonInfo.receiverBirthday
		expires_in = jsonInfo.expires_in
		callCenterNum = jsonInfo.callCenterNum

		allowSimpleRegistYN = jsonInfo.allowSimpleRegistYN
		verifyNameYN = jsonInfo.verifyNameYN
		payload = jsonInfo.payload
		requestDT = jsonInfo.requestDT
		expireDT = jsonInfo.expireDT
		clientCode = jsonInfo.clientCode
		clientName = jsonInfo.clientName
		tmstitle = jsonInfo.tmstitle
		tmsmessage = jsonInfo.tmsmessage

		subClientName = jsonInfo.subClientName
		subClientCode = jsonInfo.subClientCode
		viewDT = jsonInfo.viewDT
		completeDT = jsonInfo.completeDT
		verifyDT = jsonInfo.verifyDT
		appUseYN = jsonInfo.appUseYN
		tx_id = jsonInfo.tx_id

		On Error GoTo 0
	End Sub

End Class

Class RequestVerifyAuthObj

	public CallCenterNum
	public Expires_in
	public PayLoad
	public ReceiverBirthDay
	public ReceiverHP
	public ReceiverName
	public SubClientID
	public TMSMessage
	public TMSTitle
	public Token
	public isAllowSimpleRegistYN
	public isVerifyNameYN

	Public Function toJsonInfo()
		Set toJsonInfo = JSON.parse("{}")
		toJsonInfo.Set "CallCenterNum", CallCenterNum
		toJsonInfo.Set "Expires_in", Expires_in
		toJsonInfo.Set "PayLoad", PayLoad
		toJsonInfo.Set "ReceiverBirthDay", ReceiverBirthDay
		toJsonInfo.Set "ReceiverHP", ReceiverHP
		toJsonInfo.Set "ReceiverName", ReceiverName
		toJsonInfo.Set "SubClientID", SubClientID
		toJsonInfo.Set "TMSMessage", TMSMessage
		toJsonInfo.Set "TMSTitle", TMSTitle
		toJsonInfo.Set "Token", Token
		toJsonInfo.Set "isAllowSimpleRegistYN", isAllowSimpleRegistYN
		toJsonInfo.Set "isVerifyNameYN", isVerifyNameYN
	End Function 

End Class

Class ResultVerifyAuthObj

	public receiptID
	public regDT
	public state
	public expires_in
	public callCenterNum

	public allowSimpleRegistYN
	public verifyNameYN
	public payload
	public requestDT
	public expireDT
	public clientCode
	public clientName
	public tmstitle
	public tmsmessage


	public subClientName
	public subClientCode
	public viewDT
	public completeDT
	public verifyDT

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		receiptID = jsonInfo.receiptID
		regDT = jsonInfo.regDT
		state = jsonInfo.state
		receiverHP = jsonInfo.receiverHP
		receiverName = jsonInfo.receiverName
		receiverBirthday = jsonInfo.receiverBirthday
		expires_in = jsonInfo.expires_in
		callCenterNum = jsonInfo.callCenterNum

		allowSimpleRegistYN = jsonInfo.allowSimpleRegistYN
		verifyNameYN = jsonInfo.verifyNameYN
		payload = jsonInfo.payload
		requestDT = jsonInfo.requestDT
		expireDT = jsonInfo.expireDT
		clientCode = jsonInfo.clientCode
		clientName = jsonInfo.clientName
		tmstitle = jsonInfo.tmstitle
		tmsmessage = jsonInfo.tmsmessage

		subClientName = jsonInfo.subClientName
		subClientCode = jsonInfo.subClientCode
		viewDT = jsonInfo.viewDT
		completeDT = jsonInfo.completeDT
		verifyDT = jsonInfo.verifyDT

		On Error GoTo 0
	End Sub

End Class

Class RequestCMSObj

	public CallCenterNum
	public Expires_in
	public PayLoad
	public ReceiverBirthDay
	public ReceiverHP
	public ReceiverName
	public SubClientID
	public TMSMessage
	public TMSTitle
	public isAllowSimpleRegistYN
	public isVerifyNameYN
	Public BankAccountName
	Public BankAccountNum
	Public BankCode
	Public ClientUserID

	Public Function toJsonInfo()
		Set toJsonInfo = JSON.parse("{}")
		toJsonInfo.Set "CallCenterNum", CallCenterNum
		toJsonInfo.Set "Expires_in", Expires_in
		toJsonInfo.Set "PayLoad", PayLoad
		toJsonInfo.Set "ReceiverBirthDay", ReceiverBirthDay
		toJsonInfo.Set "ReceiverHP", ReceiverHP
		toJsonInfo.Set "ReceiverName", ReceiverName
		toJsonInfo.Set "SubClientID", SubClientID
		toJsonInfo.Set "TMSMessage", TMSMessage
		toJsonInfo.Set "TMSTitle", TMSTitle
		toJsonInfo.Set "isAllowSimpleRegistYN", isAllowSimpleRegistYN
		toJsonInfo.Set "isVerifyNameYN", isVerifyNameYN
		toJsonInfo.Set "BankAccountName", BankAccountName
		toJsonInfo.Set "BankAccountNum", BankAccountNum
		toJsonInfo.Set "BankCode", BankCode
		toJsonInfo.Set "ClientUserID", ClientUserID
	End Function 

End Class

Class ResultCMSObj

	public receiptID
	public regDT
	public state
	public expires_in
	public callCenterNum
	public token
	public allowSimpleRegistYN
	
	public verifyNameYN
	public payload
	public requestDT
	public expireDT
	public clientCode

	public clientName
	public tmstitle
	public tmsmessage

	public subClientName

	public subClientCode
	public viewDT
	public completeDT
	public verifyDT

	Public Sub fromJsonInfo(jsonInfo)
		On Error Resume Next
		receiptID = jsonInfo.receiptID	
		regDT = jsonInfo.regDT
		state = jsonInfo.state
		expires_in = jsonInfo.expires_in
		callCenterNum = jsonInfo.callCenterNum
		token = jsonInfo.token
		allowSimpleRegistYN = jsonInfo.allowSimpleRegistYN

		verifyNameYN = jsonInfo.verifyNameYN
		payload = jsonInfo.payload
		requestDT = jsonInfo.requestDT
		expireDT = jsonInfo.expireDT
		clientCode = jsonInfo.clientCode

		clientName = jsonInfo.clientName
		tmstitle = jsonInfo.tmstitle
		tmsmessage = jsonInfo.tmsmessage

		subClientName = jsonInfo.subClientName

		subClientCode = jsonInfo.subClientCode
		viewDT = jsonInfo.viewDT
		completeDT = jsonInfo.completeDT
		verifyDT = jsonInfo.verifyDT

		On Error GoTo 0
	End Sub

End Class

%>