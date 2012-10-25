<!doctype html> <!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js" lang="en">
	<!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>Santikos Theatres: Digital Projection & 3D</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="../css/style.css">
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
		<script src="../js/jwplayer/player.swf"></script>
		<script src="../js/jwplayer/jwplayer.js"></script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
				<div class="ds-box center-img round" style="position: relative; height: 205px;">
					<div style="position: absolute; z-index: 10; top: 0;">
						<img src="../img/digText.png" alt="" />
					</div>
					<div style="position: absolute; top: 0; z-index: 1;">
						<img class="round" src="../img/Digital_Sound_bars.gif?v=<?php echo uniqid(); // Prevents cacheing of gif animation ?>" alt="" />
					</div>
				</div>
              <div class="ds-box center-img round" style="position: relative; height: 260px;">
					<div style="position: absolute; z-index: 10; top: 0;">
					  <table width="1000" height="270" border="0" cellpadding="0" cellspacing="0" style="background-image: url(../img/DP_barco.png)"><tr>
                        <td align="center" valign="bottom" style="padding-left:40px; padding-top:40px;"><div class="ds-subbox">
                        
                        <iframe width="300" height="173" src="http://www.youtube.com/embed/OEJkp1PGAB8?showinfo=0" frameborder="0" allowfullscreen></iframe>
                        
                        
                        </div></td>
                        <td width="600">&nbsp;</td>
                        </tr>
                        </table>
			    </div>
			  </div>
                <div class="ds-box center-img round" style="position: relative; height: 260px;">
					<div style="position: absolute; z-index: 10; top: 0;">
					  <table width="1000" height="270" border="0" cellpadding="0" cellspacing="0" style="background-image: url(../img/DP_panD.png)"><tr>
                        <td align="center" valign="bottom" style="padding-left:40px; padding-top:40px;"><div class="ds-subbox"><iframe width="300" height="173" src="http://www.youtube.com/embed/BYthS3j-t-g?showinfo=0"
                       frameborder="0" allowfullscreen></iframe></div></td>
                        <td width="600">&nbsp;</td>
                        </tr>
                        </table>
			    </div>
			  </div>
                <div class="ds-box center-img round" style="position: relative; height: 260px;">
					<div style="position: absolute; z-index: 10; top: 0;">
					  <table width="1000" height="270" border="0" cellpadding="0" cellspacing="0" style="background-image: url(../img/DP_realD.png)"><tr>
                        <td align="center" valign="bottom" style="padding-left:40px; padding-top:40px;"><div class="ds-subbox"><iframe width="300" height="173" src="http://www.youtube.com/embed/wo6yy3Ns_ac?showinfo=0" frameborder="0" allowfullscreen></iframe></div></td>
                        <td width="600">&nbsp;</td>
                        </tr>
                        
                        </table>
			    </div>
			  </div>
              <tr><td align="center"><img src="file:///Macintosh HD/Users/rfonseca/Sites/img/Digital_Projection_disclaimer.png" width="664" height="30"></td></tr>
				<div class="ds-box round"></div>
				<div class="clearfix"></div>
			</div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script>
			 jwplayer('video1').setup({
			    'flashplayer': 'js/jwplayer/player.swf',
			    'id': 'video1',
			    'width': '300',
			    'height': '178',
			    'controlbar.idlehide': true,
			    'file': 'http://download.dolby.com/DolbyAtmos/Dolby-Atmos-Testimonial.f4v',
			    'image': 'http://www.dolby.com/uploadedImages/Assets/US/RIA/Dolby_Atmos/Dolby_Atmos_Testimonials_still.jpg'
			  });
			  
			  jwplayer('video2').setup({
			    'flashplayer': 'js/jwplayer/player.swf',
			    'id': 'video2',
			    'width': '300',
			    'height': '178',
			    'controlbar.idlehide': true,
			    'file': 'http://download.dolby.com/DolbyAtmos/Dolby-Atmos-Stuart-Bowling-Full.f4v',
			    'image': 'http://www.dolby.com/uploadedImages/Assets/US/RIA/Dolby_Atmos/Dolby-Atmos-Video-Stuart.jpg'
			  });
			  
			  jwplayer('video3').setup({
			    'flashplayer': 'js/jwplayer/player.swf',
			    'id': 'video3',
			    'width': '300',
			    'height': '178',
			    'controlbar.idlehide': true,
			    'file': 'http://www.youtube.com/watch?v=WhzAk-XzmYQ',
			    'image': 'img/auro-3D-thumb.jpg'
			  });
		</script>
	</body>
</html>