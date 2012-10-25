
<%
'erased connections
' END OF INIT

'
' ConnDB - Connect to the database
'
sub ConnDb
	set cnnData = Server.CreateObject("ADODB.Connection")
	cnnData.ConnectionTimeout = cnnCSentry_ConnectionTimeout
	cnnData.CommandTimeout = cnnCSentry_CommandTimeout
	cnnData.CursorLocation = cnnCSentry_CursorLocation
	cnnData.Open cnnCSentry_ConnectionString ', cnnCSentry_RuntimeUserName, cnnCSentry_RuntimePassword
	
	set gblCommand = Server.CreateObject("ADODB.Command")
	set gblCommand.ActiveConnection = cnnData
		
end sub

sub DiscDb
	set gblCommand = nothing
	cnnData.Close
	set cnnData = nothing
end sub

sub A1Titles(strTitle)
%>
<link href="http://wunderlandgames.com/showtimes.css" rel="stylesheet" type="text/css" />

<TABLE BGCOLOR = #FFFFFF WIDTH=100% cellspacing=0 cellpadding=0>
<TR><TD><FONT COLOR="CornflowerBlue" size=3><B><%=strTitle%></B></FONT></TD></TR>
</TABLE>
<%
end sub

sub AolTitles(strTitle)
%>
<TABLE BGCOLOR = #FFFFFF WIDTH=100% cellspacing=0 cellpadding=0>
<TR><TD><FONT COLOR="CornflowerBlue" size=3><B><%=strTitle%></B></FONT></TD></TR>
</TABLE>
<SCRIPT>
document.title="CinemaSource: <%=strTitle%>";
</SCRIPT>
<BR><BR>
<%
end sub

sub Titles(strTitle)
%>
<BR>
<TABLE BORDER=0 BGCOLOR = #FFFFFF WIDTH=100% style="border-width:1px; border-color:#0D5180; border-style: solid">
<TR><TD><FONT COLOR="#0D5180"><B><%=strTitle%></B></FONT></TD></TR>
</TABLE>
<SCRIPT>
document.title="ExhibitorAds <%=strTitle%>";
</SCRIPT>
<BR>
<%
end sub

'
' WaitWindow
' Display a transient message
'
sub WaitWindow(strData, iWin)

end sub

'
' ntrim
' Return a trimmed, possibly null string
'
Function ntrim(sti)

    ntrim = ""
    On Error Resume Next

    ' Turn a null into an empty string, or trim results
    If Not IsNull(sti) Then
        ntrim = Trim(sti)
    End If

    On Error GoTo 0
End Function

'
' pstr
' Return a string with a space in front of it, blank strings as blank
'
Function pstr(sti)

    If sti = "" Then
        pstr = ""
    Else
        pstr = " " + sti
    End If
    
End Function

'
' FixShowtimes - Try to reformat showtimes so that they are all valid
'
function FixShowtimes
dim i 
dim strTime

	' All ok so far
	FixShowtimes = true
	
	' For each timeslot	
	for i = 1 to MAXTIMES
	
		' Get time
		fld = "time" & cstr(i)
		strTime = ntrim(SCREENS.Fields(fld))
		
		' If there IS a time there..
		if len(strTime) > 0 then
			'
			' If someone popped an AM or PM in there, remove it
			'
			strTime = ucase(replace(strTime, " ", ""))
			if right(strTime,2) = "AM" then
				strMer = "AM"
			else
				if right(strTime,2) = "PM" then
					strMer = "PM"
				else
					strMer = ""
				end if
			end if
			strTime = replace(strTime, "AM", "")
			strTime = replace(strTime, "PM", "")
						
			'
			' How long is it after removing the colon?
			' Based on that, we will extract the Hours and Minutes
			'
			strHour = ""
			strMin = ""
			strTime = replace(strTime, ":", "")			
			strTime = replace(strTime, ";", "")	' Accept semicolons too
			strTime = replace(strTime, ".", "")	' Accept periods too
			select case len(strTime)
			
				'
				' Length = 3 :: HMM
				'
				case 3:
					strHour = left(strTime,1)
					strMin = right(strTime,2)

				'
				' Length = 4 :: HHMM
				'
				case 4:
					strHour = left(strTime,2)
					strMin = right(strTime,2)
				
				'
				' Length = 1: H
				'
				case 1:
					strHour = strTime
					strMin = "00"

				'
				' Length = 2: HH
				'
				case 2:
					strHour = strTime
					strMin = "00"
				
				'
				' Length > 4 :: Error 
				'
				case else:
					Response.Write "Bad Len: " & SCREENS.Fields(fld) & " is " & len(strTime)
					FixShowtimes = false
			end select
			
			'
			' Was it a good time?
			'
			if strHour <> "" then
				if cint(strHour) > 12 or cint(strHour) < 1 then
					' Bad hour
					Response.Write "<FONT SIZE=+1 COLOR=red> Bad Hour: " & SCREENS.Fields(fld) & "</FONT>"
					FixShowtimes = false
				else
					if cint(strMin) > 59 or cint(strMin) < 0 then
						' Bad min
						Response.Write "<FONT SIZE=+1 COLOR=red> Bad Min: " & SCREENS.Fields(fld) & "</FONT>"
						FixShowtimes = false
					else
						' Fine. I think. Reconstitute it.
						strHour = right("00" + strHour, 2)
						SCREENS.Fields(fld) = strHour + ":" + strMin
						SCREENS.Update
						
						' Also, if they specified an AM or PM, force it
						flda = "MER" & cstr(i)
						if strMer = "AM" then						
							SCREENS.Fields(flda) = true
							SCREENS.Update
						else
							if strMer = "PM" then						
								SCREENS.Fields(flda) = false
								SCREENS.Update
							end if						
						end if
						
					end if
				end if
			end if
		else
			' 0 len time		
		end if
		
	next 
	 
end function

'
' DisplayTable - Given a SQL query, display the results in a standard table
'
function DisplayTable(strSQL)
dim rsData

strOne = "#FFFFFF"
strTwo = "#EEEEEE"
DisplayTable = "0"

	set rsData = cnnData.Execute(strSQL)
	
	' Any data at all?
	if rsData.state = 0 then
		Response.Write "No data..."
		exit function
	end if
	
	' Some data. Maybe 0 records.
	Response.Write("<TABLE BORDER=0>")
	Response.Write("<TR>")
	for i = 0 to rsData.Fields.count-1
		Response.Write("<TD BGCOLOR=" + gblBg + "><B><I><FONT COLOR=" + gblFg +">" + rsData.Fields(i).name + "</B></I></TD>")
	next 
	Response.Write("</TR>")
	
	do while not rsData.eof
	
		if strBg <> strOne then
			strBg = strOne
		else
			strBg = strTwo
		end if
		Response.Write("<TR BGCOLOR=" + strBg + ">")

		for i = 0 to rsData.Fields.count-1
			Response.Write("<TD>&nbsp;")
			Response.write(rsData.Fields(i).Value)
			Response.Write ("</TD>")
		next 
		DisplayTable = ntrim(rsData.Fields(0))
				
		' Next
		Response.Write("</TR>")
		rsData.MoveNext
	loop
	Response.Write ("</TABLE>")
	
	' Done
	rsData.close
	set rsData = nothing

end function
	
'
' DisplayTableRow - Given a record set, display the header or the rows
'
sub DisplayTableRow(rsData, bHeader)

strOne = "#FFFFFF"
strTwo = "#EEEEEE"
	
	' Any data at all?
	if rsData.state = 0 then
		Response.Write "No data..."
		exit sub
	end if
	
	' Some data. Maybe 0 records.
	if bHeader then
		Response.Write("<TABLE BORDER=0>")
		Response.Write("<TR>")
		for i = 0 to rsData.Fields.count-1
			Response.Write("<TD BGCOLOR=" + gblBg + "><B><I>" + rsData.Fields(i).name + "</B></I></TD>")
		next 
		Response.Write("</TR>")	
	else		
		if not rsData.eof then
	
			if strBg <> strOne then
				strBg = strOne
			else
				strBg = strTwo
			end if
			Response.Write("<TR BGCOLOR=" + strBg + ">")

			for i = 0 to rsData.Fields.count-1
				Response.Write("<TD>&nbsp;")
				Response.write(rsData.Fields(i).Value)
				Response.Write ("</TD>")
			next 
			
			' Next
			Response.Write("</TR>")
			rsData.MoveNext
		end if
	end if
end sub ' DisplayTableRow
	
'
' DisplayRecord - Given a SQL query, display the details for each record
'
sub DisplayRecord(strSQL)
dim rsData

	set rsData = cnnData.Execute(strSQL)

	' Any data?
	if rsData.eof then
		Response.Write "<H2>No Current Record</H2>"
	else
		' Once for each record return (usually one)
		do while not rsData.eof
		
			' Start display
			Response.Write("<TABLE BORDER=1>")
		
			' Display a row for each data field
			for i = 0 to rsData.Fields.count-1
				Response.Write("<TR>")
				Response.Write("<TD>" + rsData.Fields(i).name + "</TD>")
				Response.Write("<TD>&nbsp;")
				Response.Write("<INPUT type=text name=$" & rsData.Fields(i).name & " id=$" & rsData.Fields(i).name & " value=" & Quote(ntrim(rsData.Fields(i).Value)) & ">" )
				Response.Write ("</TD>")
				Response.Write("</TR>")
			next 
	
			Response.Write ("</TABLE>")

			' Next result record
			rsData.MoveNext
		loop
		
	end if
					
end sub	

'
' GatherRecord - load recordset with data from the form
'
sub GatherRecord(rsLocal)

		for each fld in Request.Form
			'Response.Write "<H1>" + fld + "</H1><BR>"
			if left(fld,1) = "$" then
				'Response.Write "<H2>" + fld + " is " + Request.Form(fld) + "</H2><BR>"
				'Response.Flush
				fldname = replace(fld, "$", "")
				if instr(1, Request.Form(fld),  " ") then
					strData = Quote(Request.Form(fld))
					strData = Request.Form(fld)
				else
					strData = Request.Form(fld)
				end if

				on error resume next
				'Response.Write "<H2>" + fldname + " was " + rsLocal.Fields(fldname).Value + "</H2><BR>"
				'Response.Flush
				'Response.Write "<H2>" + fldname + " was " + cstr(rsLocal.Fields(fldname).Value) + "</H2><BR>"
				'Response.Flush
				on error goto 0

				rsLocal.Fields(fldname).Value = strData
				rsLocal.Update
			end if				
		next
	
end sub

'
' AppendOneTime
'
Function AppendOneTime(rsScreens, i)
dim strTime

		strI =  cstr(i)
		strTime = ntrim(rsScreens.Fields("TIME" + strI))
		if rsScreens.Fields("MER" + strI) then
			strTime = strTime + " AM"
		end if
		if rsScreens.Fields("BARGAIN" + strI) then
			strTime = "(" + strTime + ")"
		end if

	AppendOneTime = strTime	
end Function

'
' AppendTimes
' Display all the showtimes in a record formatted as human-readable
'
Function AppendTimes(rsScreens, strState)

	strOutput = " "
	
	' For each time... 
	for i = 1 to MAXTIMES
		strI =  cstr(i)
		strTime = ntrim(rsScreens.Fields("TIME" + strI))
		if rsScreens.Fields("MER" + strI) then
			strTime = strTime + " AM"
		end if
		if rsScreens.Fields("BARGAIN" + strI) then
			strTime = "(" + strTime + ")"
		end if
		
		' If there is a time there...
		if strTime <> "" then
		
			' Blank between times
			if strOutput <> "" then
				strOutput = strOutput + " &nbsp; "
			end if
		
			' Add time
			strOutput = strOutput + strTime
		end if

	next 
	
	if ntrim(strState) = "UK" then
		strOutput = replace(strOutput, ":", ".")
		strOutput = replace(strOutput, " 0", " ")
	end if
	
	AppendTimes = strOutput

End Function


'
' AppendEndTimes
' Display all the showtimes in a record formatted as human-readable with start AND end times
' Also, check for overlapping times
Function AppendEndTimes(rsScreens, strRuntime)

	strOutput = ""
	strOldEndTime =  ""
	
	' For each time... 
	for i = 1 to MAXTIMES
		strI =  cstr(i)
		strTime = ntrim(rsScreens.Fields("TIME" + strI))
		if rsScreens.Fields("MER" + strI) then
			strTime = strTime + "AM"
		else
			if strTime <> "" then
				strTime = strTime + "PM"
			end if
		end if
		
		'
		' Append the end time
		'
		strEndtime = strTime
		if strRuntime <> "" and strTime <> "" then
			dtStart = cdate(strTime)
			dtEnd = dtStart
			on error resume next
			iHours = cint(  left(strRuntime, len(strRuntime)-3)  )
			dtEnd = DateAdd("h", iHours, dtEnd)
			iMin = cint(right(strRuntime, 2))
			dtEnd = DateAdd("n", iMin, dtEnd)
			on error goto 0
			strEndtime = FormatDateTime(dtEnd, vbLongTime)
			strEndTime = replace(strEndtime, ":00 ", "")
			'strEndTime = replace(strEndtime, "PM", " PM")
			'strEndTime = replace(strEndtime, "AM", " AM")
			
		end if
		if strTime <> "" and strEndtime <> "" then
			'
			' Append the end time to the start time
			'
			strStart = strTime
			strTime = strTime + "-" + strEndtime
			
			'
			' Check for overlap
			'
			if strOldEndtime <> "" then
				' Add 15 minutes 
				if DateAdd("n", 15, cdate(strOldEndtime)) > cdate(strStart) then
					strTime = "<FONT COLOR=red>" + strTime + "</FONT>"
				end if
			end if
			
			' Save this time for next iteration
		end if
		
		strOldEndtime = strEndtime
		if rsScreens.Fields("BARGAIN" + strI) then
			strTime = "(" + strTime + ")"
		end if
		
		' If there is a time there...
		if strTime <> "" then
			
			' Blank between times
			if strOutput <> "" then
				strOutput = strOutput + ", "
			end if
		
			' Add time
			strOutput = strOutput + strTime
		end if

	next 
	
	AppendEndTimes = strOutput

End Function



'
' WebTimes
' Display all the showtimes in a record formatted as readable in a browser.
'
Function WebTimes(rsScreens, strTicketDate, strExid, strAfid, strEdata, strEvenodd)
dim strOutput
dim iTimes 



	' Nothin yet
	strOutput = ""
	iTimes = 0
	if Request.QueryString("rts") = "yes" then
		bRts = true
	else
		bRts = false
	end if
		
	' For each time... 
	if strEvenodd = "" then
		iStart = 1
		iStep = 1
	elseif strEvenodd = "ODD" then
		iStart = 1
		iStep = 2
	else ' EVEN
		iStart = 2
		iStep = 2
	end if
	
	for i = iStart to MAXTIMES step iStep	
		' Get Time string, and add AM
		strI =  cstr(i)
    	strTime = ntrim(rsScreens.Fields("TIME" + strI))
		if rsScreens.Fields("MER" + strI) then
			strTime = strTime + " AM"
		else
			' PM
			if strTime <> "" then
				strTime = strTime + " P.M." ' unique string to translate
			end if
		end if

		'Remove leading zero
		if left(strTime,1) = "0" then
			strTime = mid(strTime,2)
		end if
		
		' UKize it
		if ntrim(rsScreens.Fields("state")) = "UK" then
			strTime = replace(strTime, ":", ".")
		end if
		
		' Add bargain parens
		if rsScreens.Fields("BARGAIN" + strI) then
			strTime = "(" + strTime + ")"
		end if		
				
		' If there is a time there...
		if strTime <> "" then
			iTimes = iTimes + 1
				
			' Comma, Blank between times
			if strOutput <> "" then
				strOutput = strOutput + ",&nbsp;"
			end if
		
			' Ticketing link implied by ticket date
			if strTicketDate <> "" then
				strEntry = Twelveto24(ntrim(rsScreens.Fields("TIME" + strI)), rsScreens.Fields("mer" + strI) )
	
				'if not bRts then
				'	' Add the link to movietickets.com if requested
				'	strTimeUrl = _
				'			"<A target=_blank HREF=http://www.movietickets.com/purchase.asp?house_id=" + ntrim(rsScreens.Fields("house_id")) + _
				'			"&movie_id=" + ntrim(rsScreens.Fields("movie_id")) + _
				'			"&perfd=" + strTicketDate + _
				'			"&perft=" + strEntry 
				'	if strExid <> "" then	
				'		strTimeUrl = strTimeUrl + "&exid=" + strExid
				'	end if
				'	if strAfid <> "" then	
				'		strTimeUrl = strTimeUrl + "&afid=" + strAfid
				'	end if
				'	if strEdata <> "" then	
				'		strTimeUrl = strTimeUrl + "&edata=" + strEdata
				'	end if
				'else
				'	'
				'	' RTS Link
				'	'
				'	set rsLink = cnnData.Execute("select showtext from perfs where house_id=" + ntrim(rsScreens.Fields("house_id")) + " and " + _
				'				" movie_id=" + ntrim(rsScreens.Fields("movie_id")) + " and showdate="  + Quote(strTicketDate) + " and " + _
				'				" showtime=" + Quote(strEntry) )
				'	if not rsLink.eof then
				'		strTimeUrl = "<A HREF=" + ntrim(rsLink.Fields("showtext")) 
				'	end if
				'	rsLink.Close
				'	set rsLink = nothing
				'end if				
				' Finish with times
				'strTime = strTimeUrl + _
				'">" + _
				'		strTime + "</A>"
			end if
		
			' Add time
			strOutput = strOutput + strTime
		end if

	next 
	
	' Combine bargains
	strOutput = replace(strOutput, "), )", ", ")	
	
	' Leave only single PM showtime
	if iTimes = 1 then
		strOutput = replace(strOutput, " P.M.", " PM")
	else
		strOutput = replace(strOutput, " P.M.", "")
	end if
	WebTimes = strOutput

End Function


'
' AppendMil
' Fill in the showtimes in 26 hour format
'
Function AppendMil(rsScreens)

	' 
	for i = 1 to MAXTIMES
		strI =  cstr(i)
		strTime = Trim(rsScreens.Fields("TIME" + strI))
		if strTime <> "" and strTime <> ":" then
			iHour = cint(left(strTime,2))
	    			
			if rsScreens.Fields("MER" + strI) = True then
				' AM time
				if iHour = 12 then
					iHour = 0
				end if
			else
				' PM time
				if iHour <> 12 then
					iHour = iHour + 12
				end if
			end if

			' Trick for 12 AM Midnight, 1 AM and 2 AM
			if rsScreens.Fields("MER" + strI) = True and (iHour=0 or iHour=1 or iHour=2) then
				iHour = iHour + 24
			end if

			' Put the hours and minutes together
			' strTime = cstr(iHour) + ":" + right(strTime,2)
			strTime = cstr(iHour) + right(strTime,2) ' Skip the colon now, and check for 3 chars below
		
			' Leading 0
			if len(strTime) = 3 then
				strTime = "0" + strTime
			end if
			
			' Add bargain parens if specified in record
			if rsScreens.Fields("BARGAIN" + strI) then
				strTime = "(" + strTime + ")"
			end if
		
			' Next time!
			strOutput = strOutput + "|" + strTime
		end if
	next 
	
	AppendMil = strOutput

End Function

'
' HouseHeader
' Given a recordset called HOUSES, display a table of the unmodifiable theater info
'
Function HouseHeader

	' New Style
%>
	<BR>
	<TABLE border=0 cellpadding=0 cellspacing=0>
	<TR>
		<TD rowspan=2>
			<A HREF=http://www.movietickets.com/house_detail.asp?house_id=<%=HOUSES("HOUSE_ID")%>  target=_mt title=Movietickets.com>
			<span style="font-family:verdana;font-size:16px;"><B><%=HOUSES("NAME")%></B></span>
			</A>
		</TD>
		<TD rowspan=2>&nbsp;&nbsp;|&nbsp;&nbsp;</TD>
		<TD>House ID: <B><%=HOUSES("HOUSE_ID")%> </B>in <B><%=HOUSES("COUNTY")%> </B>County. Movieline: <B><%=HOUSES("MOVIELINE")%></B></TD>
	</TR>
		<TD><B><%=HOUSES("CITY")%>,&nbsp;<%=HOUSES("STATE")%>&nbsp;<%=HOUSES("ZIP")%></B></TD>
	</TABLE>
<%
	exit function

%>
<TABLE border=0 cellPadding=1 cellSpacing=1 width="75%">
  
  <TR>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("NAME")%></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("HOUSE_ID")%></TD>
    <TD nowrap>in</TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("CITY")%></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("COUNTY")%></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("ZIP")%></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("MOVIELINE")%></TD></TR>
  <TR>
    <TD nowrap></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("CITY")%></TD>
    <TD nowrap></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("CONTACT1")%></TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("PHONE1")%></TD>
    <TD nowrap>&nbsp;Bargain thru:</TD>
    <TD nowrap bgColor=<%=gblBg%>><%=HOUSES("BARGAINOF")%></TD></TR>
</TABLE>
  
  

<%
End Function

'
' GetParam
' Return the value for a named parameter. Order of precedence, highest to lowest:
'	QueryString - if it's in the URL, it overrides all
'	Form - Passed in form param
'	Session Data - Take default from whatever may have been set for session
'	If nothing set at all, return blank
'
Function GetParam(strField)

	' Query has the most power to override
	strData = Request.QueryString(strField)
	if strData = ""  then 
		' If nothing then try next level, the submitting form
		strData = Request.Form(strField)
		if strData = "" then
			' If nothing, then last resort is the base level, the Session variable
			strData = Session(strField)
		else
			' Override in Form. Set default to same.
			Session(strField) = strData
		end if
	else
		' Override in Query URL. Set default to same.
		Session(strField) = strData
	end if

	' Response.Write("<H1>" + strField + "=" + strData + "</H1>") ' DEBUG
	GetParam = strData

End Function

'
' Quote
' Return data with single quotes around it. Escape single quotes.
'
Function Quote(strIn)

	strOut = replace(strIn, "'", "''")
	strOut = "'" + strOut + "'"
	Quote = strOut

end function

'
' LoginInitial
' Given a passed in username and password, look up username and login_level
'
function LoginInitial

	strUser = GetParam("username")
	strPassword = GetParam("password")
	Session("password") = ""
	set rsData = cnnData.Execute ("select * from usernames where upper(username)=" & Quote(ucase(strUser)) & " and upper(password)=" & Quote(ucase(strPassword)) )
	if rsData.eof then	
		LogMsg "Incorrect login: " + strUser + " with " + strPassword

		LoginClear
		
		'Session("login_level") = ""
		'Session("house_id") = ""
		'Session("user_id") = ""
		'Session("chain_id") = ""
	else
		if ucase(strPassword) <> ucase(ntrim(rsData.Fields("password"))) then
			LogMsg "Incorrect login: " + strUser + " with " + strPassword
		
			LoginClear
			
			'Session("login_level") = ""
			'Session("house_id") = ""
			'Session("user_id") = ""
			'Session("chain_id") = ""
			'Session("username") = ""
			'Session("user_list") = ""
		else
			Session("login_level") = rsData.Fields("login_level")
			Session("house_id") = rsData.Fields("house_id")
			Session("user_id") = rsData.Fields("user_id")
			Session("chain_id") = rsData.Fields("chain_id")
			Session("user_list") = ntrim(rsData.Fields("user_list"))
			Session("fullname") = ntrim(rsData.Fields("fullname"))
			Session("username") = strUser
			Session("user_email") = ntrim(rsData.Fields("user_email"))
			if Session("login_level") = LVL_SUPER then
				Session.Timeout = 90 ' Long timeout for superuser
			end if
		end if
	end if
	
	' Done
	rsData.close
	set rsData = nothing
	
end function

'
' LoginClear
'
function LoginClear
			Session("login_level") = ""
			Session("house_id") = ""
			Session("user_id") = ""
			Session("chain_id") = ""
			Session("user_list") = ""
			Session("fullname") = ""
			Session("username") = ""
			Session("user_email") = ""
end function


'
' LoginLevel
' Return security level of current session. If not logged in, link to login page
'
function LoginLevel

	if gblSiteType = "LITE" then
		strRetdef = "a1default.asp"
	else
		if bLive then
			strRetDef = "default.asp"
		else
			strRetDef = "local.asp"
		end if
	end if
	
	strLevel = GetParam("login_level")	
	LoginLevel = ""
	if strLevel = "" then
		Response.Write "<BR><BR>Incorrect username/password, or not logged in.<BR><A HREF=" + strRetDef + ">Please login first.</A><BR><BR>"
		Response.End
	else
		LoginLevel= strLevel
	end if
	
	
end function

'
' GetSkedVars
'
sub GetSkedVars(strSked, strTable, strMainid, strSearchid)

	strTable = "sked" + strSked + "s"			' skedhouses, skedareas, skedchains
	strMainId = "sked" + strSked + "_id"		' skedhouse_id, skedarea_id, skedchain_id
	strSearchId = strSked + "_id"				' house_id, area_id, chain_id

end sub

'
' IIF - 
'
function iif(bCond, strVtrue, strVfalse)

	if bCond then
		iif = strVtrue
	else
		iif = strVfalse
	end if
end function

'
' ShowDatesList
'
Sub ShowDatesList(strDateVar, strForm)
dim strShowdate
dim strSub
dim iPrevious 
Dim iFuture
dim strStyle
dim i

	' Autosubmit?
	if strForm <> "" then
		strSub = " onchange=""JavaScript:" + strForm + ".submit();"" "
	else
		strSub = ""
	end if
	
	' Set number of days in the past and future
	strStyle = ""
	iStep = 1
	if strForm = "website" then ' csPremier or a1website = 1 day at a time
		iPrevious = 0 '' was -7
		iFuture = 120 ' 21 '' was 7
		strStyle = " class=""a1pulldown"" "
	else 
		if left(strDateVar,4) = "week" then ' Any weekly display on csPremier, csXpress, a1website
			iPrevious = -7
			iFuture = 120 ' 42
			iStep = 7
			
			if gblSiteType = "LITE" and strForm <> "" then ' Change styles for csXpress
				strStyle = " style=""font-size:12pt; font-weight:bold; font-family:Verdana"" "
			else ' or for a1website
				strStyle = " class=""a1pulldown"" "
			end if
		else ' Otherwise...not sure which this might be...1 day at a day
			iPrevious = -7
			iFuture = 120 ' 42
		end if
	end if
	
%>
		<SELECT <%=strStyle%> id=<%=strDateVar%> name=<%=strDateVar%> <%=strSub%> >
				<%
				'				
				' Start date, passed in or cookie, otherwise today
				'
				strShowdate = GetParam(strDateVar)
				if strShowdate = "" then
					strShowdate = FormatDateTime(date(), vbShortdate)
				end if
				
				'
				' Let's not let them go backwards if we're already too far in the past	
				'
				if cdate(strShowdate) <= date() - 7 then
					iPrevious = 0
				else
					'
					' On the other hand, if we are far out in the future, let them at least come back to today
					'
					if cdate(strShowdate) + iPrevious > date() then
						' Have to calculate in increments of iStep
						do while cdate(strShowdate) + iPrevious > date()
							iPrevious = iPrevious - iStep
						loop
					end if
				end if
				
				'
				' From days past to days future...
				'
				for i = iPrevious to iFuture step iStep
					
					datCur = cdate(strShowDate) + i ' date() + i CAN'T BE DATE() BECAUSE SOMETIMES NEEDS TO BE FRIDAY
					strShortdate = FormatDateTime(datCur, vbShortdate)
					strLongdate = FormLongDate(datCur)
					if strShortdate = strShowdate then
						strSelected = " selected "
					else
						strSelected = ""
					end if
					
					Response.Write "<OPTION " & strStyle & strSelected & " value=" & strShortdate & ">" & strLongdate & "</OPTION>"
				next
				%>
		</SELECT>
<%
end sub


'
' ShowWebDays
'
Sub ShowWebDays(strDateVar, strForm)
dim strShowdate
dim strSub
dim iPrevious 
Dim iFuture
dim i

	' Autosubmit?
	if strForm <> "" then
		strSub = " onchange=""JavaScript:" + strForm + ".submit();"" "
	else
		strSub = ""
	end if
	
	' Set number of days in the past and future
	strStyle = ""
	iStep = 1
	if strForm = "website" then
		iPrevious = 0
		iFuture = 7
	else 
		if strDateVar = "weekstart" then
			iPrevious = -7
			iFuture = 21
			iStep = 7
			strStyle = " style=""font-size:12pt; font-weight:bold; font-family:Verdana"" "
		else
			iPrevious = -7
			iFuture = 21
		end if
	end if
%>
		<SELECT <%=strStyle%>  id=select2<%=strDateVar%>  name=select2<%=strDateVar%> <%=strSub%> >
				<%
				strShowdate = GetParam(strDateVar)
				if strShowdate = "" then
					strShowdate = FormatDateTime(date(), vbShortdate)
				end if
				
				for i = iPrevious to iFuture step iStep
					
					datCur = cdate(strShowDate) + i ' date() + i
					strShortdate = FormatDateTime(datCur, vbShortdate)
					'strLongdate = FormatDateTime(datCur, vbLongdate)
					strLongdate = FormatLongDate(datCur)
					if strShortdate = strShowdate then
						strSelected = " selected "
					else
						strSelected = ""
					end if
					
					Response.Write "<OPTION " & strStyle & strSelected & " value=" & strShortdate & ">" & strLongdate & "</OPTION>"
				next
				%>
		</SELECT>
<%
end sub


'
' ShowFriList
'
Sub ShowFriList(strDateVar, strForm)
dim strShowdate
dim strSub
dim iPrevious 
Dim iFuture
dim i

	' Autosubmit?
	if strForm <> "" then
		strSub = " onchange=""JavaScript:" + strForm + ".submit();"" "
	else
		strSub = ""
	end if
	
	' Set number of days in the past and future
	iStep = 1
	if strForm = "website" then
		iPrevious = 0
		iFuture = 7
	else 
		if strDateVar = "weekstart" then
			iPrevious = -7
			iFuture = 21
			iStep = 7
		else
			iPrevious = -7
			iFuture = 21
		end if
	end if
%>
		<SELECT  id=select1<%=strDateVar%>  name=select1<%=strDateVar%> <%=strSub%> >
				<%
				strShowdate = GetParam(strDateVar)
				if strShowdate = "" then
					strShowdate = FormatDateTime(date(), vbShortdate)
				end if
				
				for i = iPrevious to iFuture step iStep
					
					datCur = cdate(strShowDate) + i
					strShortdate = FormatDateTime(datCur, vbShortdate)
					'strLongdate = FormatDateTime(datCur, vbLongdate)
					strLongdate = FormatLongDate(datCur)
					if strShortdate = strShowdate then
						strSelected = " selected "
					else
						strSelected = ""
					end if
					
					Response.Write "<OPTION " & strSelected & " value=" & strShortdate & ">" & strLongdate & "</OPTION>"
				next
				%>
		</SELECT>
<%
end sub


'
' HousesList
' Display a list of theaters that this user is enabled to see
'
Sub HousesList

		
			'
			' Get a list of all the houses this user can modify
			' All or one"
			if GetParam("login_level") <= LVL_CENTRAL then
				strSQL = "select	houses.name, houses.state, houses.house_id " & _
						" from		houses, usernames " & _
						" where		houses.chain_id = usernames.chain_id " & _
						" and		usernames.user_id = " & Session("user_id") & _
						" and		houses.house_id > 0 "
			else
				strSQL = "select	houses.name, houses.state, houses.house_id " & _
						" from		houses, usernames " & _
						" where		houses.chain_id = usernames.chain_id " & _
						" and		houses.house_id > 0 " & _
						" and		usernames.user_id = " & Session("user_id") 
						
				if Session("user_list") = "" then
					strSQL = strSQL +  " and houses.house_id = usernames.house_id  "
				else
					strSQL = strSQL + " and houses.house_id in (" + Session("user_list") + ")"
				end if
			end if
			
			' Sort order, then execute SQL
			if GetParam("bystate") = "yes" then
				strSQL = strSQL + " order by	houses.state, houses.name "
			else
				strSQL = strSQL + " order by	houses.name,houses.state "
			end if
			set HOUSES = cnnData.Execute(strSQL)

			%><SELECT id=house_id name=house_id > <%
			
			' For each house...
			do while not HOUSES.eof
			
				' Is this the current house?
				if cstr(HOUSES.Fields("house_id")) = strHouseid then
					strSelected = "selected"
				else
					strSelected = ""
				end if
				
				' Write a choice for it in the list
				if GetParam("bystate") = "yes" then
					Response.Write "<OPTION " & strSelected & " value=" & cstr(HOUSES.Fields("house_id")) & ">" & HOUSES.Fields("state") & "-" & HOUSES.Fields("name") & "</OPTION>"
				else
					Response.Write "<OPTION " & strSelected & " value=" & cstr(HOUSES.Fields("house_id")) & ">" & HOUSES.Fields("name") & "-" & HOUSES.Fields("state") & "</OPTION>"
				end if
				
				' Next
				HOUSES.MoveNext
			loop		
			
			' Done
			HOUSES.close
			set HOUSES = nothing
		%>		
		</SELECT>
		<%
end sub


'
' MarketList
' Display a list of markets
'
Sub MarketList
dim rsLocal
		
	set rsLocal = cnnData.Execute("select distinct market from houses order by market")
				
			%><SELECT id=market name=market > <%
			
			' For each house...
			do while not rsLocal.eof
			
				' Is this the current house?
				if ntrim(rsLocal.Fields("market")) = trim(strMarket) then
					strSelected = "selected"
				else
					strSelected = ""
				end if
				
				' Write a choice for it in the list
				Response.Write "<OPTION " & strSelected & " value=""" & ntrim(rsLocal.Fields("market")) & """>" & ntrim(rsLocal.Fields("market")) & "</OPTION>"
				
				' Next
				rsLocal.MoveNext
			loop		
			
			' Done
			rsLocal.close
			set rsLocal = nothing
		%>		
		</SELECT>
		<%
end sub ' MarketList


		
'
' DynamicAdo
'
function DynamicADO(strSQL)

		set rsNew = Server.CreateObject("ADODB.Recordset")
		rsNew.ActiveConnection = cnnData
		rsNew.CursorType = 1 ' adOpenKeyset = 1,  adOpenDynamic = 2,  adOpenStatic = 3
		rsNew.CursorLocation = 3  ' adUseServer = 2, adUseClient = 3
		rsNew.LockType = adLockOptimistic
		rsNew.Source = strSQL
		rsNew.Open

		Response.Write "<!-- Dynamic ADO Cursor Type: " + cstr(rsNew.CursorType) + ", CursorLocation:" + cstr(rsNew.CursorLocation) + "-->" + chr(13) + chr(10)
		set DynamicADO = rsNew
		
end function

'
' StaticAdo
'
function StaticADO(strSQL)

		set rsNew = Server.CreateObject("ADODB.Recordset")
		rsNew.ActiveConnection = cnnData
		rsNew.CursorType = 3
		rsNew.CursorLocation = 3  ' adUseServer = 2, adUseClient = 3
		'rsNew.LockType = adLockOptimistic
		rsNew.Source = strSQL
		rsNew.Open

		Response.Write "<!-- Static ADO Cursor Type: " + cstr(rsNew.CursorType) + ", CursorLocation:" + cstr(rsNew.CursorLocation) + "-->" + chr(13) + chr(10)
		set StaticADO = rsNew
		
end function

function TextIn(rsAdo, strFname)

	if rsAdo(strFname).DefinedSize > 80 then
		TextIn = "<TEXTAREA id=$" + strFname + " name=$" + strFname + " rows=2 cols=70>" + ntrim(rsAdo(strFname).Value) + "</TEXTAREA>"
	else
		TextIn = "<INPUT id=$" + strFname + " name=$" + strFname + " size=" + cstr(rsAdo(strFname).DefinedSize) + " value=""" + ntrim(rsAdo(strFname).Value) + """>"
	end if
	
end function

function BoolIn(rsAdo, strFname)

	' True part
	BoolIn = "Yes: <INPUT id=$" + strFname + " name=$" + strFname + " type=radio value=True " 
	if rsAdo(strFname).value = "True" then 
		BoolIn = BoolIn +  " checked"
	end if
	BoolIn = BoolIn + ">&nbsp;&nbsp;"
	
	' False part
	BoolIn = BoolIn + _
			"No: <INPUT id=$" + strFname + " name=$" + strFname + " type=radio value=False " 
	if rsAdo(strFname).value = "False" then 
		BoolIn = BoolIn +  " checked"
	end if
	BoolIn = BoolIn + ">&nbsp;&nbsp;"
		
end function

'
' SendMailQ
'
function SendMailQ(strDest, strSubj, strText)

	strUser = Session("username")
	strFrom =  Session("user_email")
	if strFrom = "" then
		strFrom = "adsource@cinema-source.com"
	end if
	strHouseid = cstr(GetParam("house_id"))
	strBody = strText + chr(13)+chr(10)+ "...from " + strUser + " <" + strFrom + "> " + " (house id " + strHouseid + ")"
  
	'
	' Fake on Local
	'
	if Request.ServerVariables("SERVER_NAME") = "localhost" then
		Response.Write "Sending " + strSubj + " to " + strDest + "<BR>"
		Response.Write strText
		exit function
	end if

	'
	' Send via aspQmail
	'
	if  Request.ServerVariables("SERVER_NAME") = "central" then ' Request.ServerVariables("SERVER_NAME") = "www.cinema-source.com" or Request.ServerVariables("SERVER_NAME") = "cinema-source.com" or
		set mailer = Server.CreateObject("SMTPsvg.Mailer")
			Mailer.RemoteHost= "mail.cinema-source.com" ' "jfk3-relay.mail.digex.net" ' was: "mailhost.campusrelease.com"
		Mailer.FromName = "Site"
		Mailer.FromAddress = strFrom
		Mailer.AddRecipient strDest, strDest
		Mailer.Subject = strSubj
			Mailer.BodyText = strBody
		if not Mailer.SendMail then
			SendMailQ = Mailer.Response
		else
			SendMailQ = ""
		end if
		set Mailer = nothing
	else
		'
		' Send via CDONT
		'
		set objMail = Server.CreateObject("CDONTS.NewMail")
		
		' Format?
		if instr(1, strBody, "<HTML>") > 0 or instr(1, strBody, "<html>") > 0 then
			objMail.BodyFormat = 0 'HTML
			objMail.MailFormat = 0	'HTML	
		end if
		
		' Header
		objMail.From = strFrom
		objMail.Subject = strSubj
		objMail.To = strDest
		objMail.Body = strBody
		objMail.Send
		set objMail = nothing
	
	end if	
	
end function
	
	
function cdow(datDay)
	select case weekday(datDay)
		case 1: cdow = "Sunday"
		case 2: cdow = "Monday"
		case 3: cdow = "Tuesday"
		case 4: cdow = "Wednesday"
		case 5: cdow = "Thursday"
		case 6: cdow = "Friday"
		case 7: cdow = "Saturday"
	end select
end function

'
' LogMsg - Add a msg to the audit log
'
sub LogMsg(strAction)
dim strUserid
dim strUser

	strUserid = cstr(Session("user_id"))
	if strUserid = "" then
		strUserid = "0"
	end if
	strUser = GetParam("username")

	gblCommand.CommandText = _
			"insert Audit(user_id, username, audit_url, audit_action) values (" & _
			strUserid + "," +  Quote(strUser) + "," + Quote(Request.ServerVariables("URL")) + "," + Quote(strAction) + ")"
	gblCommand.Execute
	
end sub

'
' PrintLevel - Show info about the logged in user
'
sub PrintLevel(strLevel, strChainname, strHousename)
%>
<% if strLevel = LVL_SUPER then %>
		You have full <B>Super User</B> rights (level <%=strLevel%>)<BR><BR>
		Your default exhibitor chain is: <B><%=strChainname%></B> but you can change chains.<BR><BR>
	
	<%elseif strLevel = LVL_ADMIN then %>
		You are an <B>Exhibitor Administrator</B> (level <%=strLevel%>)<BR><BR>
		Your exhibitor chain is: <B><%=strChainname%></B><BR><BR>
	
	<% elseif strLevel = LVL_CENTRAL then %>
		You are a <B>Multi-Theater Manager</B> (level <%=strLevel%>)<BR><BR>
		Your exhibitor chain is: <B><%=strChainname%></B><BR><BR>
		Your current theater is:<B> <%=strHousename%></B><BR><BR>
		
<% elseif strLevel = LVL_DISTRICT then %>
		You are a <B>District/Regional Manager</B> (level <%=strLevel%>)<BR><BR>
		Your exhibitor chain is: <B><%=strChainname%></B><BR><BR>
		Your current theater is:<B> <%=strHousename%></B><BR><BR>		
		
	<% elseif strLevel = LVL_ADMGR or strLevel = LVL_CSMGR then %>
		You are a <B>Theater Manager</B> (level <%=strLevel%>)<BR><BR>
		Your exhibitor chain is: <B><%=strChainname%></B>.<BR><BR>
		Your current theater is:<B> <%=strHousename%></B>.<BR><BR>
	
<% elseif strLevel = LVL_PAPER then %>
		You are a <B>Newspaper or Agent</B> (level <%=strLevel%>)<BR>
		You may view newspaper ad layouts and showtime information. <BR><BR>
	
<% else %>
		You are unknown level <%=strLevel%>.
		
	<% end if %>
	
<%
end sub

'
' PrintWelcome - Show info about the logged in user
'
sub PrintWelcome()
dim strUser

	strUser = Session("username")
	if Session("fullname") <> "" then
		strUser = strUser + " - " + StripAttrs(Session("fullname"))
	end if	

%>

	
	Welcome <B><%=strUser%></B>!<BR>
	<FONT SIZE=-1>(If this is not you, click <A HREF=a1default.asp?function=logout>here</A> to log in again.)</FONT>
	<BR><BR>
	<% exit sub %>
	
<% if strLevel = LVL_SUPER then %>
	You have full <B>Super User</B> rights<BR>
	Your default exhibitor chain is: <B><%=strChainname%></B> but you can change chains.<BR>
	<% end if %>

	<% if strLevel = LVL_ADMIN then %>
	You have full <B>Administrator</B> rights<BR>
	Your exhibitor chain is: <B><%=strChainname%></B><BR>
	<% end if %>
	
	<% if strLevel = LVL_CENTRAL then %>
	You are a <B>Multi-Theater Manager</B><BR>
	Your exhibitor chain is: <B><%=strChainname%></B><BR>
	Your current theater is:<B> <%=strHousename%></B><BR>
	<% end if %>
		
	<% if strLevel = LVL_CSMGR or strLevel = LVL_ADMGR then %>
	You are a <B>Theater Manager</B><BR>
	Your exhibitor chain is: <B><%=strChainname%></B><BR>
	Your current theater is:<B> <%=strHousename%></B><BR>
	<% end if %>
	
<% if strLevel = LVL_PAPER then %>
	You are a <B>Newspaper</B><BR>
	You may view newspaper ad layouts <BR><BR>
	<% end if %>
	
	<%
end sub

'
' FillBargains
'
sub FillBargains(rsScreens, bClearall)
dim rsBargains 
dim i 
dim iHouseid
dim iDayofweek


'Response.Write "Checking bargains" + "<BR>"
bClearAll = True ' FOR NOW, ASSUME WE ALWAYS CLEAR FIRST
bClearAll = False

	' Are there any bargains marked already? If so, then quit, the data entry person marked them
	for i = 1 to 24
		if bClearall then
			rsScreens.Fields("bargain" + cstr(i)) = False
			rsScreens.update
		else
			if rsScreens.Fields("bargain" + cstr(i)) = True then
				exit sub
			end if
		end if
	next
	
	' House id and day of week
	iHouseid = rsScreens.Fields("house_id")
	iDayofweek = WeekDay(rsScreens.Fields("showdate"))

	' No bargains after 8/30/2002
	' OK, allow them again, 2/24/04
	if rsScreens.Fields("showdate") >= cdate("8/30/2002") then
		exit sub
	end if

	'Response.Write "House " + cstr(iHouseid) + "Day " + cstr(iDayofweek) + "<BR>"
	
	' Get the bargain record for this theater	
	set rsBargains = cnnData.Execute("select top 1 * from Bargains where house_id=" + cstr(iHouseid))
	if not rsBargains.eof then

		' Assume only ONE holiday for now. See if that is the current showdate
		strHoliday = ntrim(rsBargains.Fields("holidays"))
		if strHoliday <> "" then
			if rsScreens.Fields("showdate") = cdate(strHoliday) then
				exit sub
			end if
		end if

		' Get bargain times
		strBS = ntrim(rsBargains("btime" + CStr(iDayofweek) + "s").Value)
		strBE = ntrim(rsBargains("btime" + CStr(iDayofweek) + "e").Value)
		If strBE <> "" And strBS = "" Then
		    strBS = "09:00" ' 9 AM
		End If
		

        '
        ' IF we have bargain times to check against...
        '
        If strBS <> "" And strBE <> "" Then 
        
			' Once for each time
			for i = 1 to 24
				
				' Get time value
				strEntry = ntrim(rsScreens.Fields("time" + cstr(i)))
				
				' Anything there?
				if strEntry <> "" and strEntry <> ":" then
				
					' Translate to 24 hr time
					strEntry = Twelveto24(strEntry, rsScreens.Fields("mer" + cstr(i)) )
				
					' Between bargains?
					'Response.Write "Is " + CStr(DayMin(strEntry)) + " between " + CStr(DayMin(strBS)) + " and " + CStr(DayMin(strBE)) + "<BR>"
					If DayMin(strEntry) >= DayMin(strBS) And DayMin(strEntry) <= DayMin(strBE) Then
						' Yes. Update record
					    'Response.Write "  -->YES" + "<BR>"
					    rsScreens.Fields("bargain" + cstr(i)) = true
					    rsScreens.Update
					else
						' Nope. Leave showtime alone.
						'Response.Write "  -->NO" + "<BR>"
					End If
				
				End if
				
            next ' i
            
        End If
				
	end if 

	' Done with bargain record
	rsBargains.close
	set rsBargains = nothing
	
end sub

'
' DayMin - Minutes into day for a 24 hour time
'
Function DayMin(strTime) ' As Integer
Dim iHour ' As Integer
Dim iMin ' As Integer

    iHour = CInt(Left(strTime, 2))
    iMin = CInt(Right(strTime, 2))
    DayMin = iHour * 60 + iMin
    
End Function

'
' Twelveto24 - Turn 12 hour time to 24
'
Function Twelveto24(strTime, bAm) ' As String
Dim iHour ' As Integer
    
    Twelveto24 = ""
    If strTime = "" Then
        Exit Function
    End If
    iHour = CInt(Left(strTime, 2))
    If bAm And iHour = 12 Then
        iHour = 0
    Else
        If Not bAm And iHour < 12 Then
            iHour = iHour + 12
        End If
    End If
    
    Twelveto24 = cstr(iHour) + ":" + Right(strTime, 2)
    if len(Twelveto24) = 4 then
		Twelveto24 = "0" +Twelveto24 
	end if
    if len(Twelveto24) = 3 then
		Twelveto24 = "00" +Twelveto24 
	end if
	
End Function

'
' Passes - return N (no passes) if this is a changed SCREENS record and we are within
'          10 days of the first release date for this movie
'
Function Passes(datRelease, strAllowpass, iMovieid, SCREENS, datShow) ' As string

	
	' Assume it is whatever they passed in or Y
	if trim(strAllowpass) = ""  then
		Passes = "Y"
	else
		Passes = strAllowpass
	end if

	' If there is no movie id or release date, we're done
	if datRelease = "" then
		Passes = "Y"
		exit function
	end if
	if clng(iMovieid) = 0 then
		exit function
	end if
	
	' If the movie id is the same as the movie id in the record already, assume it has been set
	Response.Write "SCREENS.movie_id=" + cstr(SCREENS.Fields("movie_id")) + "<BR>"
	Response.Write "imovieid=" + cstr(iMovieid) + "<BR>"
	if clng(SCREENS.Fields("movie_id")) = clng(iMovieid) then
		exit function
	end if
	
	' OK. Now are we within 10 days of release
	if cdate(datRelease) < cdate(datShow) and cdate(datShow)-cdate(datRelease) <= 10 then
		Passes = "N"
	end if
	
end function

'
' RemoveArticle - Remove leading word
'
function RemoveArticle(strData, strArticle)
dim strOutput

	strOutput = trim(strData)	
	if ucase(left(strOutput, len(strArticle)+1)) = ucase(strArticle) + " " then
		strOutput = mid(strOutput, len(strArticle)+1)
	end if
	
	RemoveArticle = strOutput
end function
	
'
' MoveArticle - Move leading word
'
function MoveArticle(strData, strArticle)
dim strOutput

	strOutput = trim(strData)	
	if left(strOutput, len(strArticle)+1) = strArticle + " " then
		strOutput = mid(strOutput, len(strArticle)+1) + ", " + strArticle
	end if
	
	MoveArticle = strOutput
end function
	
'
' FlipArticle - Move trailing word
'
function FlipArticle(strData, strArticle)
dim strOutput

	strOutput = trim(strData)	
	if right(strOutput, len(strArticle)+2) = ", " + strArticle then
		strOutput = strArticle + " " + left(strOutput, len(strOutput) - (len(strArticle)+2) )
	end if
	
	FlipArticle = strOutput
end function
	
	
'
' RemoveAllArticles
'
function RemoveAllArticles(strData)
dim strOutput

	strOutput = strData
	strOutput = RemoveArticle(strOutput, "The")
	strOutput = RemoveArticle(strOutput, "An")
	strOutput = RemoveArticle(strOutput, "A")
	
	RemoveAllArticles = strOutput
end function
	
'
' MovieTitle
'
function MovieTitle(strData)
dim strOutput

	strOutput = strData
	strOutput = FlipArticle(strOutput, "The")
	strOutput = FlipArticle(strOutput, "An")
	strOutput = FlipArticle(strOutput, "A")
	
	MovieTitle = strOutput
end function
	
'
' MoveAllArticles
'
function MoveAllArticles(strData)
dim strOutput

	strOutput = strData
	strOutput = MoveArticle(strOutput, "The")
	strOutput = MoveArticle(strOutput, "An")
	strOutput = MoveArticle(strOutput, "A")
	
	MoveAllArticles = strOutput
end function

'*****************************************************************	
'*
'* TestAM - Test one record to see if the AM might be missing
'*	
'*****************************************************************
function TestAM(rsData)
dim outbuf, iPrevious, i, amer, value, outfield, hour, timer


	'*
	'* Fill this buffer with times
	'*
	outbuf = ""
	iPrevious = 0
	TestAM = true
	
	'*
	'* Once for every field
	'*
	for i = 1 to MAXTIMES
			value = "TIME" + cstr(i)
			timer = ntrim(rsData.Fields(value))
			
			' Now get am pm designator. Field is, i.e. MER12 for TIME12
			value = "MER" + mid(value, 5)
			
			' Put it all together 
			if timer <> "" then
				amer = rsData.Fields(value)
				
				'*
				'* Case 1. 12 AM through 12:59 AM
				'*				
				if left(timer,2) = "12" and amer then
					outfield = "00" + mid(timer,3)
					hour = 0
				else
					'*
					'* Case 2. 12 PM through 12:59 pm
					'*
					if left(timer,2) = "12" and not amer then
						outfield = trim(timer)
						hour = cint(left(timer,2))
					else
						'*
						'* General case. All PM times have 12 added to hour
						'*						
						hour = cint(left(timer,2))
						if not amer then
							hour = hour + 12
						end if					
						outfield = right("00" + cstr(hour),2) + mid(timer,3)
					end if ' General
					
				end if ' not case 1

				'* Make to 26 hour time				
				if hour >= 0 and hour <= 2 then
					hour = 24 + hour
				end if
				outbuf = outbuf + outfield + ", "

				'* Test
				if hour < iPrevious then
					TestAM = false
					exit function
				else
					iPrevious = hour
				end if
				
			end if '&& not empty timer
							
	next ' i, next field
		
end function  ' end TestAM

'
' FormatPhone - return (xxx)yyy-zzzz
'
function FormatPhone(strPhone)
dim i
dim strNewphone 
dim c 

	' Uppercase and trim
	strPhone = ucase(trim(strPhone))
	strNewphone = ""
	
	' Strip any non alphanumeric
	for i = 1 to len(strPhone)
		c = mid(strPhone, i, 1)
		' Response.Write c + "(" + cstr(asc(c)) + ")"
		if (asc(c) >= asc("0") and asc(c) <= asc("9")) or (asc(c) >= asc("A") and asc(c) <= asc("Z")) then
			strNewphone = strNewphone + c
		end if
	next	
	
	' Response.Write "NEW:" + strNewphone
	
	' Put in proper punctuation
	if len(strNewphone) = 10 then
		strNewphone = "(" + left(strNewphone,3) + ")" + mid(strNewphone,4,3) + "-" + mid(strNewphone,7,3)
	else
		strNewphone = "ERROR" ' ERROR
	end if
	
	' Return
	FormatPhone = strNewphone
	
end function ' FormatPhone

'
' ExportTimes
'
sub ExportTimes(strHouseid, strStartdate, strEnddate)

	'
	' Connecticut Production - write file to a directory where it can be loaded into CinemaSource
	'
	if Request.ServerVariables("SERVER_NAME") = "www.exhibitorads.com" or Request.ServerVariables("SERVER_NAME") = "exhibitorads.com" then ' Session("username") = "daves" then

		' Get showtimes
		strShowtimes = FormatTimes(strHouseid, "", "")
		
		' Create the filesystem object and write out data
		set filesys = CreateObject("Scripting.FileSystemObject")
		strFileTemp = gblShowtimeDir + "\" + strHouseid + ".tmp" 
		strFilename = gblShowtimeDir + "\" + strHouseid + ".txt" 

		' Output the data
		Response.Write "Sending data to file"  + strFileTemp + "..."
		Response.Flush	
		set fp = filesys.CreateTextFile(strFileTemp, True, False)
		fp.write strShowtimes
		fp.close
		set fp = nothing
		Response.Write "Done.<BR>"
		Response.Flush	

		' Delete any previous final files
		if filesys.FileExists(strFileName) then
			filesys.DeleteFile strFileName
		end if
	
		' Rename temp file to real file
		Response.Write "Renaming "  + strFileTemp + " to " + strFilename + "...."
		Response.Flush	
		filesys.MoveFile strFileTemp, strFilename
		set filesys = nothing
		Response.Write "Done.<BR>"
		Response.Flush	
		
	'
	' Florida Old Production: we're not going to write a file to the directory.
	' Instead we trigger the CT cinema-source.com site to pull the data from 
	' exhibitor-ads.com/Florida
	'
	elseif Request.ServerVariables("SERVER_NAME") = "CINEWEB1" then 
		
		strUrl = "www.cinema-source.com/csweb/kickoffas.asp?house_id=" + strHouseid
		Response.Write "<BR>" + "Triggering " + strUrl + "<BR>"

		' Trigger the response, no real data returned
		set inetx = CreateObject("ObjInet.ClassInet")
		inetx.URL = strUrl
		strData = inetx.OpenURL ("")
		set inetx = nothing

		Response.Write "Received:<BR> " +  strData + "<BR>============<BR>"
	
	'
	' Development: Post to test trigger
	'
	elseif  Request.ServerVariables("SERVER_NAME") = "central" then

		' We are running on the test system. Try new post method
		strUrl = "http://central/csweb/postdata.asp?house_id=" + strHouseid
		Response.Write "<BR>" + "Posting to " + strUrl + "<BR>"

		strShowtimes = FormatTimes(strHouseid, "", "")
		Response.Write strShowtimes
		
		' Trigger the response, no real data returned
		set inetx = CreateObject("ObjInet.ClassInet")
		inetx.URL = strUrl
		inetx.Data = strShowtimes
		inetx.PostUrl
		set inetx = nothing
		
	else
		'
		' Ridgefield Alternate Production: just write the file out.
		' The automater will pick it up soon.
		'
		
		'
		' But for now, just skip it. cinema-source.com is a TEST system
		'
		exit sub
		
		' Create the filesystem object
		set filesys = CreateObject("Scripting.FileSystemObject")

		' Directory that CinemaSource will scan
		strDir1 = "S:\Incoming\AdSource\" 
		 		
		' Create the output file for this house		
		Response.Write "Exporting house: " & strHouseid & "..."
		strFileTemp = strDir1 & strHouseid & ".tmp"
		strFileName = strDir1 & strHouseid & ".txt"
		set fp = filesys.CreateTextFile(strFileTemp, True, False)
			
		' Create the internet control and open the URL with the house data
		set inetx = CreateObject("ObjInet.ClassInet")
		strUrl = Request.ServerVariables("SERVER_NAME") + Request.ServerVariables("URL")
		strUrl = replace(strUrl, "approve.asp", "") ' Better be the script
		strUrl = replace(strUrl, "posload.asp", "") ' Better be the script	
		strUrl = strUrl + "cs_exporter.asp?house_id=" & strHouseid
		if strStartdate <> "" and strEnddate <> "" then
			strUrl = strUrl + "&startdate=" + strStartdate + "&enddate=" + strEnddate
		end if
		inetx.URL = strUrl
				
		Response.Write "<BR>" + "URL is " + strUrl + "<BR>"
		' Get the data, and write it to the file
		strData = inetx.OpenURL ("")
		strData = replace(strData, chr(10), chr(13)+chr(10) )
		fp.write strData

		' Done with the output file and with the internet control
		fp.close

		' Close internet
		set inetx = nothing


		' Did we get any REAL data?
		if len(strData) > 0 then
			' Delete any previous final files
			if filesys.FileExists(strFileName) then
				filesys.DeleteFile strFileName
			end if
	
			' Rename temp file to real file
			filesys.MoveFile strFileTemp, strFilename
			Response.Write "Done writing file.<BR>"				
		else
			' Nope. Blow away temp file.
			filesys.DeleteFile strFileTemp
			Response.Write "<BR><B>Warning:</B>No valid data received for this house.<BR><BR>"	
			Response.Write "<BR><FONT SIZE=+1>Please contact your POS help desk.</FONT><BR><BR>"	
		end if		
					
		' Close the filesystem object
		set filesys = nothing

	end if
	
end sub ' ExportTimes

'
' FillLinks - Create a multicolumn set of choices based on a SQL statement
'			  First column is value, second column is display, third is count
Sub FillLinks(strUrl, strSQL, iCols)
dim strCurvalue
dim strSub
dim rsData
dim iCnt
dim iRecord 

strOne = "#FFFFFF"
strTwo = "#EEEEEE"

	' Get the data
	set rsData = DynamicAdo(strSQL)	
	if rsData.eof then
		exit sub
	end if
		
	iCnt = 0
	do while not rsData.eof
		iCnt = iCnt + 1
		rsData.MoveNext
	loop
	rsData.MoveFirst
	'Response.Write "<BR>" + "Count = " + cstr(iCnt) + "<BR>"
	
	Response.Write "<TABLE>"
	
	' Once for each...
	iRecord = 0
	do while not rsData.eof				

		if iRecord mod iCols = 0 then

			if strBg <> strOne then
				strBg = strOne
			else
				strBg = strTwo
			end if
			Response.Write("<TR BGCOLOR=" + strBg + ">")

		end if
									
		' Output
		Response.Write "<TD>"
		if strUrl <> "" then
			Response.Write "<A HREF=" & strUrl & Server.URLEncode(ntrim(rsData.Fields(0))) & ">"
		end if
		Response.Write ntrim(rsData.Fields(1))
		if strUrl <> "" then
			Response.write "</A>"
		end if
		Response.Write "</TD>"
		iRecord = iRecord + 1
		
		' New row?
		if iRecord mod iCols = 0 then
			Response.Write("</TR>")
		end if
		
		' Next
		rsData.movenext
	loop
			
	' Done
	rsData.close
	set rsData = nothing

	Response.Write "</TABLE>"
	
end sub

'
' FormatTimes
' Get all the data for a house's showtimes into a BIG text string
'
function FormatTimes(strHouseid, strFrom, strTo)
Dim strOutput
Dim strSQL
Dim rsData
dim strTimes
	
	DELIM = "~"
		
	' Get the data for this house (no provisional movies 6/13/05)
	strSQL = "select * from screens where house_id=" + strHouseid + " and movie_id > 0 " 
	if strFrom <> "" then
		strSQL = strSQL + " and showdate >= " + Quote(strFrom)
	else
		strSQL = strSQL + " and showdate >= " + Quote(date())
	end if
	if strTo <> "" then
		strSQL = strSQL + " and showdate <= " + Quote(strTo)
	end if
	strSQL = strSQL + " order by house_id, showdate, movie_id "
	set rsData = cnnData.execute (strSQL)
	
	strOutput = ""
	' Spit it out
	do while not rsData.eof

		' Get some field data
		strTimes = AppendMil(rsData)
		if left(ntrim(rsData.Fields("allowpass")),1) = "N" then
			strPass = "No"
		else
			strPass = "Yes"
		end if
		if left(ntrim(rsData.Fields("sneak")),1) = "Y" then
			strSneak = "Yes"
		else
			strSneak = "No"
		end if
		
		' House id	
		strOutput = strOutput + strHouseid + DELIM
		
		' Movie id
		strOutput = strOutput + cstr(rsData.Fields("movie_id")) + DELIM
		
		' Screen id
		strOutput = strOutput + cstr(rsData.Fields("screen_id")) + DELIM 
		
		' Allow pass
		strOutput = strOutput + strPass + DELIM 

		' Sound
		strOutput = strOutput + ntrim(rsData.Fields("sound")) + DELIM 
		
		' From date
		strOutput = strOutput + ntrim(rsData.Fields("showdate")) + DELIM 

		' To date
		strOutput = strOutput + ntrim(rsData.Fields("showdate")) + DELIM 
		
		' Times
		strOutput = strOutput + strTimes + DELIM
		
		' Comments (and seating for now)
		strComments = ntrim(rsData.Fields("comment"))
		strComments = replace(strComments, chr(13)+chr(10), " ")
		strComments = replace(strComments, chr(13), "")
		strComments = replace(strComments, chr(10), "")
		if instr(1, ucase(ntrim(rsData.Fields("seatstyle"))), "STADIUM") then
			if strComments <> "" then
				strComments = strComments + "; "
			end if
			strComments = strComments + "Stadium Seating"
		end if
		strOutput = strOutput + trim(strComments) + DELIM 

		' With
		strOutput = strOutput + cstr(rsData.Fields("super_id")) + DELIM 

		' Lang
		strOutput = strOutput + ntrim(rsData.Fields("caption")) + DELIM 

		' Sneak
		strOutput = strOutput + strSneak + DELIM 

		' Caption
		strOutput = strOutput + ntrim(rsData.Fields("closedcap")) + DELIM 

		' EOL
		strOutput = strOutput + chr(13) + chr(10)
			
		' Next
		rsData.movenext
	loop
	
	' Done
	rsData.close
	
	FormatTimes = strOutput
end function

'
' BinaryToString
'
Function BinaryToString(Binary)
  'Antonin Foller, http://www.pstruh.cz
  'Optimized version of a simple BinaryToString algorithm.
  
  Dim cl1, cl2, cl3, pl1, pl2, pl3
  Dim L
  cl1 = 1
  cl2 = 1
  cl3 = 1
  L = LenB(Binary)
  
  Do While cl1<=L
    pl3 = pl3 & Chr(AscB(MidB(Binary,cl1,1)))
    cl1 = cl1 + 1
    cl3 = cl3 + 1
    If cl3>300 Then
      pl2 = pl2 & pl3
      pl3 = ""
      cl3 = 1
      cl2 = cl2 + 1
      If cl2>200 Then
        pl1 = pl1 & pl2
        pl2 = ""
        cl2 = 1
      End If
    End If
  Loop
  BinaryToString = pl1 & pl2 & pl3
End Function

'***************************
'*
'* vbAddComment
'* comment - add attr to this comment
'* attr - attr to add
'*
'***************************
function vbAddComment(strComment, strAttr)
dim strOut

	' First, remove it!
	strOut  = vbStripComment(strComment, strAttr)
	
	' Now, add it in
	strOut = strOut + "; " + strAttr
	
	' Remove any leading semis and dup semis
	if left(strOut,1) = ";" then
		strOut = mid(strOut,2)
	end if
	strOut = replace(strOut, ";;", ";")
	vbAddComment = trim(strOut)
	
end function

'***************************
'*
'* vbStripComment
'* comment - remove attribute from comment
'* attr - attribute to remove
'*
'***************************
function vbStripComment(strComment, strAttr)
dim strOut

	strOut = strComment
	strOut = replace(strOut, "; " + strAttr, "") ' In middle
	strOut = replace(strOut, strAttr, "") ' Or at beginning

	' Remove any leading semis and dup semis
	if left(strOut,1) = ";" then
		strOut = mid(strOut,2)
	end if
	strOut = replace(strOut, ";;", ";")
	vbStripComment = trim(strOut)
	
end function

'
' ActorNames - List N actors. Probably should be a parameter
'
function ActorNames(rsData)
dim strNames

	if ntrim(rsData.Fields("actor1")) <> "" then
		strNames = ntrim(rsData.Fields("actor1") )
	end if
	if ntrim(rsData.Fields("actor2")) <> "" then
		strNames = strNames + ", " + ntrim(rsData.Fields("actor2") )
	end if
	
	if ntrim(rsData.Fields("actor3")) <> "" then
		strNames = strNames + "," + ntrim(rsData.Fields("actor3") )
	end if
	if ntrim(rsData.Fields("actor4")) <> "" then
		strNames = strNames + "," + ntrim(rsData.Fields("actor4") )
	end if
	if ntrim(rsData.Fields("actor5")) <> "" then
		strNames = strNames + "," + ntrim(rsData.Fields("actor5") )
	end if
	
	ActorNames = strNames
end function



'
' RunMinutes
'
Function RunMinutes(rsData)
dim strTime
dim strRun 
	
	' Get from db
	strRun = ntrim(rsData.Fields("runtime"))
		
	' Does it have a :
	pos = instr(1, strRun, ":")
					
	' No, we're done
	if pos = 0 or strRun = "" then
		strTime = ""
	else
		' Yes? Get the chars to the left times 60
		if pos = 1 then
			hrs = 0
		else
			hrs = cint(left(strRun, pos-1)) * 60
		end if
						
		' Get chars to right, and add in
		if pos = len(strRun) then
			mins = 0
		else
			mins = cint(mid(strRun, pos+1))
		end if
			
		' Add them up
		strTime = cstr(hrs + mins)
	end if

	' Return
	RunMinutes = strTime
end function

'
' MakePhoto - return name of photo file
'
function MakePhoto(rsLocal)

	if rsLocal.Fields("photos") = true then
		' This SHOULD be on exhibitorads.com
		MakePhoto = "http://www.movienewsletters.net/photos/" + right("000000" + ntrim(rsLocal.Fields("movie_id")),6) + "01.jpg"
	else
		MakePhoto = ""
	end if
		
end function



'
' NotifyTheaterManager - Find the manager of a particular theater (i.e. normal user with house_id)
'                 and email them that their showtimes have been altered by the district manager
'
function NotifyTheaterManager(strHouseid, strBody, strTopic)
dim rsLocal	
dim strSQL
dim strText
dim strDest
dim strSubject

	' Find the normal user for this house
	strSQL = "select top 1 * from usernames where house_id=" + strHouseid + " and login_level >= " + cstr(LVL_MGR)
	set rsLocal = cnnData.Execute(strSQL)
	if not rsLocal.eof then
		' Found one
		strDest = rsLocal.Fields("user_email")

		' Message text		
		if strBody = "" then
			strText = "Dear Theater Manager, <BR><BR>" + _
					 " This is to inform you that your showtimes have been altered by a district manager<BR>" + _
					 " in your theater chain. No action is necessary at this time.<BR><BR>" + _
					 " The CinemaSource/ExhibitorAds Web Site"
		else
			strText = strBody
		end if
		
		' And subject
		strSubject = strTopic
		if strSubject = "" then
			strSubject = "Your showtimes have been modified"
		end if
		
		' And send email
		SendMailQ strDest, strSubject, strText
	end if
	
	' Done
	rsLocal.close
	set rsLocal = nothing
end function


'
' NotifyDistrictManager - Find the district manager of a particular theater (i.e. privileged user with house_id)
'                 and email them with passed in subject and text
'
function NotifyDistictManager(strHouseid, strBody, strTopic)
dim rsLocal	
dim strSQL
dim strText
dim strDest
dim strSubject

	' Find the privileged multi-theater user for this house
	strSQL = "select * from usernames where user_list like '%" + strHouseid + "%' and login_level < " + cstr(LVL_MGR) + " and chain_id = " + cstr(GetParam("chain_id"))
	set rsLocal = cnnData.Execute(strSQL)
	do while not rsLocal.eof 
		' Found one
		strDest = rsLocal.Fields("user_email")

		' Message text		
		strText = strBody
		
		' And subject
		strSubject = strTopic
		
		' And send email
		SendMailQ strDest, strSubject, strText
		
		' Next address
		rsLocal.MoveNext
	loop
	
	' Done
	rsLocal.close
	set rsLocal = nothing
end function

'
'
'
function ToBeApproved
	' Retrieve the current record number from the database
	strHouseid = cstr(GetParam("house_id"))
	strUserid = cstr(Session("user_id"))
	strChainid = cstr(Session("chain_id"))
	strUserlist = trim(Session("user_list"))

	if strUserlist = "" then
		Response.Write "<P>Sorry. You do not have approval authority for any theaters."
	else
		'Response.Write "<P>"+strUserlist 

		strSQL = "select	houses.name, houses.state, houses.house_id, houses.number " + _
				" from		theater houses " + _
				" where		houses.house_id in ( " + strUserlist + ")" + _
				" and		houses.pickup = 0 " + _
				" order by  houses.name " 
		'Response.Write strSQL
		'Response.End
		set rsHouses = cnnData.Execute(strSQL)
		
%>

<br><br>
<B>Theaters Still to be Approved</B><br><br>
<TABLE>
<TR>
<TH>Approve or Reject</TH>
<TH>Unit #</TH>
<TH>State</TH>
<TH>House ID</TH>		
</TR>

<%
	
	if rsHouses.eof then
		Response.Write "<TR><TD>None found</TD></TR>"
	end if
	
	do while not rsHouses.eof
		
		strUrl = "sndreport.asp?function=weekapprove&house_id=" + ntrim(rsHouses.Fields("house_id"))
		
		Response.Write "<TR>"
		Response.Write "<TD>" + "<A HREF=" + strUrl + ">" + "<IMG border=0 SRC=""images/checkmark.gif"">" +  ntrim(rsHouses.Fields("name")) + "</A>" + "</TD>"
		Response.Write "<TD>" + ntrim(rsHouses.Fields("number")) + "</TD>"
		Response.Write "<TD>" + ntrim(rsHouses.Fields("state")) + "</TD>"
		Response.Write "<TD>" + cstr(rsHouses.Fields("house_id")) + "</TD>"
		Response.Write "</TR>"
		
		' Next
		rsHouses.movenext
	loop
	
	' Done
	Response.Write "</TABLE>"
	rsHouses.close
	set rsHouses = nothing

end if

end function

'
' AOLattributes - This will be a common subroutine
'
Function AOLattributes(strComment)
dim strTotal

	' Start with blank total list
	strTotal = ""
	
	' DVS
	strTotal = AddAttr("DVS", strComment, strTotal, "DVS")
	strTotal = AddAttr("DLP", strComment, strTotal, "DLP")
	strTotal = AddAttr("RWC", strComment, strTotal, "CC") ' Example
	
end function

Function AddAttr(strAttribute, strComment, strList, strCode)
	if instr(strAttribute, strComment) > 0 then
		strList = vbAddComment(strList, strCode)
	end if
	
	AddAttr = strList
end function


'*
'* GetNextFri - Return the date of the Friday after the date
'*			   passed in. If a Friday was passed in, return that day.
'*
function GetNextFri(datCur)
dim cd
dim diff

	cd = weekday(date())   ' && 1=Sun 2=Mon 3=Tue 4=Wed 5=Thu 6=Fri 7=Sat
	
	'* Only thing is, diff-5=Sun 4=Mon 3=Tue 2=Wed 1=Thu 0=Fri 6=Sat
	diff = 6 - cd
	if diff = -1 then
		diff = 6
	end if
	

	GetNextFri = (date() + diff)
end function

'
' DisplayTimes - Display a formatted schedule
'
function DisplayTimes(strHouseid, strFrom, strTo)
dim rsData
dim strOutput
	
	' Get the data for this house
	strSQL = "select	houses.state, houses.country, movies.name, movies.mpaa, screens.*, isnull(isnull(movies.release3,movies.release2),movies.release) as r4 " + _
			" from		movies, screens, houses " + _
			" where		movies.movie_id =* screens.movie_id " + _
			" and		screens.movie_id <> 0 " + _
			" and		screens.house_id = " + strHouseid  + _
			" and		houses.house_id = " + strHouseid

	if strFrom <> "" then
		strSQL = strSQL + " and showdate >= " + Quote(strFrom)
	else
		strSQL = strSQL + " and showdate >= " + Quote(date())
	end if
	if strTo <> "" then
		strSQL = strSQL + " and showdate <= " + Quote(strTo)
	end if
	
	'
	' Check users default sort order
	'
	if Session("sortorder") = "auditorium" then
		strSQL = strSQL + " order by screens.house_id, screens.screen_id, movies.name, screens.super_id, comment, showdate "
	else
		strSQL = strSQL + " order by screens.house_id, r4 desc, movies.name, screens.super_id, comment, showdate "
	end if
	set rsData = DynamicAdo(strSQL)
	
	' Spit it out
	iOldMovie = 0
	iOldSuper = 0
	strTimes = ""
	strOldComment = ""
	do while not rsData.eof
		iMovieId = clng(rsData.Fields("movie_id"))
		iSuperId = clng(rsData.Fields("super_id"))
		strState = ntrim(rsData.Fields("state"))
		
		' Get current comment
		strComment = ntrim(rsData.Fields("comment")) 
		if left(rsData.Fields("allowpass"),1) = "N" then
			'Response.Write "Add no passses"
			strComment = vbAddComment(strComment,"No Passes Allowed")
		end if
		
		' New movie? Or new comment?
		if iOldMovie <> iMovieId or strOldComment <> strComment or iOldSuper <> iSuperId then
			
			' End old movie if there was one.
			if strTimes <> "" then
				strDateline = FormatDates(datFrom, datTo, strState)
				strOutput = strOutput + strDateLine + ": " + strTimes + "<BR>"
				strTimes = ""
			end if
			strOutput = strOutput +  "<BR>"
			
			if iOldMovie <> iMovieId then
				strOldComment = ""
			end if
			
			' Start new one
			iOldMovie = clng(rsData.Fields("movie_id"))
			iOldSuper = clng(rsData.Fields("super_id"))
			strOldTimes = ""			
			
			' Default title/rating
			if iMovieId > 0 then
				strMovieName = MovieTitle(ntrim(rsData.Fields("name")))
				strMpaa = ntrim(rsData.Fields("mpaa"))
			end if
			
			' Where to get rating?			
			set MOVIES = cnnData.Execute("select * from movies where movie_id=" & ntrim(rsData.Fields("movie_id")))	
			strMpaa = ""
			on error goto 0 'resume next
			if ntrim(rsData.Fields("country")) = "CAN" then
				if strState = "QC" then
					strField = "PQ" + "mpa"
				else
					strField = strState + "mpa"
				end if
			else
				if strState = "UK" then
					strField = "UKMPA"
				else
					strField = "MPAA"
					strState = ""
				end if
			end if
			strMpaa = ntrim(MOVIES.Fields(strField))
			on error goto 0
				
			'
			' Country Specific title?
			'
			if strState = "UK" and ntrim(MOVIES.Fields("uktitle")) <> "" then
				strMovieName = left(ntrim(MOVIES.Fields("uktitle")),30)
			end if			
			
			' Provisional title			
			if iMovieid < 0 then
				' Get provisional movie name
				set MOVIES = cnnData.Execute("select * from MovieP where movie_id = " + cstr(iMovieId))
				if not MOVIES.eof then
					strMovieName = MovieTitle(MOVIES.Fields("name"))				
					strMpaa = ntrim(MOVIES.Fields("mpaa"))
				else
					strMovieName = "--Unknown Provisional Movie--"			
					strMpaa = "NR"
				end if
				MOVIES.Close
				set MOVIES = nothing
			end if
			
			' Output name and rating and comment
			strOutput = strOutput +  "<B>" + strMovieName + "</B>" + "&nbsp;(" + strMpaa + ")" + "&nbsp;<I>" + strComment + "</I>" + "<BR>"

			' DF
			strSuperName = ""
			strSuperMpaa = ""
			if iSuperId > 0 then
				set MOVIES = cnnData.Execute("select * from Movies where movie_id = " + cstr(iSuperId))
				if not MOVIES.eof then
					strSuperName = MovieTitle(MOVIES.Fields("name"))				
					strSuperMpaa = ntrim(MOVIES.Fields("mpaa"))
				else
					strSuperName = "--Unknown Provisional Movie--"			
					strSuperMpaa = "NR"
				end if
				MOVIES.Close
				set MOVIES = nothing
			elseif iSuperId < 0 then
				' Get provisional movie name
				set MOVIES = cnnData.Execute("select * from MovieP where movie_id = " + cstr(iSuperId))
				if not MOVIES.eof then
					strSuperName = MovieTitle(MOVIES.Fields("name"))				
					strSuperMpaa = ntrim(MOVIES.Fields("mpaa"))
				else
					strSuperName = "--Unknown Provisional Movie--"			
					strSuperMpaa = "NR"
				end if
				MOVIES.Close
				set MOVIES = nothing
			end if
			if iSuperId <> 0 then
				strOutput = strOutput +  "with <B>" + strSuperName + "</B>" + "&nbsp;(" + strSuperMpaa + ")" + "<BR>"
			end if
			
			' Save comment
			strOldcomment = strComment
			
			' Get the start date in the range	
			datFrom = rsData.Fields("showdate")
			datTo = rsData.Fields("showdate")
			
			' Get the showtimes
			'strTimes = AppendTimes(rsData)
			strTimes = WebTimes(rsData, "", "", "", "", "")
		else
			' Same movie! Are the showtimes the same?
			'strNewTimes = AppendTimes(rsData)
			strNewTimes = WebTimes(rsData, "", "", "", "", "")
			
			if strNewTimes = strTimes and rsData.Fields("showdate") = datTo + 1 then
				' Yes, the times were the same. Simply extend the end date
				datTo = rsData.Fields("showdate")
			else
				' No, Different times. We better output the old ones.
				strDateline = FormatDates(datFrom, datTo, strState)
				strOutput = strOutput +  strDateLine + ": " + strTimes + "<BR>"
				
				' And save the new ones for output during the next iteration
				strTimes = strNewTimes
				datFrom = rsData.Fields("showdate")
				datTo = rsData.Fields("showdate")
			end if
		end if
				
		' Next
		rsData.MoveNext
	loop
	
	' We might have one line left.
	if strTimes <> "" then
		strDateline = FormatDates(datFrom, datTo, strState)
		strOutput = strOutput +  strDateLine + ": " + strTimes + "<BR>"
		strTimes = ""
	end if
	strOutput = strOutput +  "<BR>"

	DisplayTimes = strOutput	
end function

'
' FormatDates
'
Function FormatDates(datFrom, datTo, strState)
dim strDates

	'strDates = left(cdow(datFrom),3) + " " + FormatDateTime(datFrom, vbShortDate)
	strDates = left(cdow(datFrom),3) 
	
	if datTo <> datFrom then
	
		' One or more days?
		if datTo-datFrom = 1 then
			strAnd = " &amp; " 
		else
			strAnd = " - "
		end if
		
		' Combine
		'strDates = strDates + strAnd + left(cdow(datTo),3) + " " + FormatDateTime(datTo, vbShortDate)
		strDates = strDates + strAnd + left(cdow(datTo),3) 

	end if
		
	' Return
	FormatDates = strDates
end function

'
' FormatDates - Create a string like "Sun-Thu"
'
'Function FormatDates(datFrom, datTo)
'dim strDates
'
'	strDates = left(cdow(datFrom),3) ' + " " + FormatDateTime(datFrom, vbShortDate)
'	if datTo <> datFrom then
'	
'		' One or more days?
'		if datTo-datFrom = 1 then
'			strAnd = " &amp; " 
'		else
'			strAnd = " - "
'		end if
'		
'		' Combine
'		strDates = strDates + strAnd + left(cdow(datTo),3)' + " " + FormatDateTime(datTo, vbShortDate)
'	end if
'		
'	' Return
'	FormatDates = strDates
'end function

'
' FormLongDate(datFrom)
'
Function FormLongDate(d)

	if Session("state") = "UK" then
		' Euro
		FormLongDate = cdow(d) + " " + cstr(day(d)) + " " + MonthName(Month(d)) + " " + cstr(year(d))
	else
		' USA
		FormLongDate = FormatDateTime(d, vbLongDate)
	end if

end function

'
' StripAttrs - Remove stuff in parens
'
Function StripAttrs(strInput)
dim strOutput
dim pos
dim pos2
	StripAttrs = strInput
	pos = instr(1, strInput, "(")
	pos2 = instr (1, strInput, ")")
	if pos > 0 and pos2 > pos then
		StripAttrs = left(strInput, pos-1)
	end if
end function	
' END OF MODULE


Function FormatMediumDate(DateValue)
    Dim strYYYY
    Dim strMM
    Dim strDD

        strYYYY = CStr(DatePart("yyyy", DateValue))

        strMM = CStr(DatePart("m", DateValue))
        If Len(strMM) = 1 Then strMM = "0" & strMM

        strDD = CStr(DatePart("d", DateValue))
        If Len(strDD) = 1 Then strDD = "0" & strDD

        FormatMediumDate = strMM & "/" & strDD & "/" & strYYYY

End Function  



function CheckSQL(strSQL)
  if instr(1, strSQL, "--") > 0 then
   Response.Write "SQL Error"
   Response.End
  end if
end function 

 sub locateFXPFile(ByVal locateFXPFile_strSiteId, ByVal locateFXPFile_strPageId)

Filepath = "http://www.filmsxpress.com/Content/" & locateFXPFile_strSiteId & "/" & locateFXPFile_strPageId & ".txt" ' file to read

Set FXPFile = server.CreateObject("MSXML2.XMLHTTP")

FXPFile.open "get", Filepath, false

FXPFile.send

'response.write FXPFile.status

if FXPFile.status = 200 then

response.write FXPFile.responseText

end if

end sub
 
%>