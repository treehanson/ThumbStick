<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
	<script type='text/javascript' src='jwplayer59/swfobject.js'></script>
    <script type="text/javascript" src="jwplayer59/jwplayer.js"></script>
</head>

<body>

		<form id="form1" runat="server">
		<div id="mediaspace" style="margin:0;padding:0;height:400px; width:600px;z-index:4000;">
        </div>
        <script type="text/javascript">
			//alert(str_pad($_GET['M'], 6, "0", STR_PAD_LEFT));
			
			jwplayer('mediaspace').setup({
				'autostart': true,
				'flashplayer': 'jwplayer59/player.swf',
				'file': 'http://media.westworldmedia.com/mp4/<?php echo $_GET['m']; ?>_high.mp4',
				'controlbar': 'none',
				'image': 'http://www.movienewsletters.net/photos/<?php echo str_pad($_GET['m'], 6, "0", STR_PAD_LEFT); ?>H2.jpg',
				'width': '620',
				'height': '420',
				'logo.hide': 'true',
				'stretching':'exactfit'
			  });
        </script>
    	</form>
</body>
</html>