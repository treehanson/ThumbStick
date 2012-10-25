<!--#include file="includes/cs_subs.asp" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
	<script type='text/javascript' src='jwplayer59/swfobject.js'></script>
    <script type="text/javascript" src="jwplayer59/jwplayer.js"></script>
</head>
<body style="background-color:#000;">
<div style="font-size:1.1em;font-weight:bold;color:#FFFFFF;"><%=Request.Querystring("title") %> </div>
<form id="form1" runat="server">
		<div id="mediaspace" style=" border:1px solid white;margin:0;padding:0;height:450px; width:550px;z-index:4000;">
        </div>
        <script type="text/javascript">
			//alert('http://media.westworldmedia.com/mp4/<%=Request.Querystring("m") %>_high.mp4');
            jwplayer("mediaspace").setup({ autostart: true, file: 'http://media.westworldmedia.com/mp4/<%=Request.Querystring("m") %>_high.mp4', flashplayer: "jwplayer59/player.swf", width: 500, height: 300 });
        </script>
    </form>
</body>
</html>