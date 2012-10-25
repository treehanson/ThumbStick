<!--#include file="includes/cs_subs.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Dedham Community Theatre</title>
    <link href="css/main.css" rel="stylesheet" type="text/css" /> 
</head>
<body style="background-color:#000000;color:White;text-align:left;">
<% 
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

locateFXPFile "138","443"

%>
</body>
</html>