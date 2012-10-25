<?php
	require_once '../db/db_conn.php';
?>
<!doctype html> <!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js" lang="en">
	<!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>Santikos Theatres: AVX</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
	<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
        
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
				<div id="left">
					<div class="small-box round center">
						<img src="../img/avx_small.png" alt="AVX" />
						<p>
							Santikos is proud to offer our guests the ultimate moviegoing experience. 
							The Santikos Audio visual Experience immerses you into an unsurpassed and intense 
							cinematic presentation.
						</p>
						<p>
							Santikos AVX is our highest level of projection quality that will become the new 
							standard at Santikos Theatres.
						</p>
						<p>
							We are excited to continue our tradition of bringing our guests the latest and greatest 
							in cinema technology.
						</p>
                       
					</div>
                    
					<div class="small-box round center">
						<p>Look for</p>
						<img src="../img/avx_small.png" alt="AVX" />
						<p>next to the film title on our showtimes page</p>
					</div>
				</div>
				<div id="right">
					<div class="big-box round" style="text-align: center;">
						<img src="../img/avx_big.png" alt="AVX" />
                         <table width="587" cellpadding="8">                     
                        <tr>
                            <td width="50%" ><a href="../img/Santikos_AVX_V3.wmv" class="various" data-fancybox-type="iframe" >AVX WMV File</a></td>
                            <td width="50%"><a href="../img/Santikos_AVX_V3.mp4" class="various" data-fancybox-type="iframe" >AVX Mp4 File</a></td>
                        </tr>         
                        </table>
					</div>
				</div>
				<div style="text-align: center; margin: 7px 0; float: left; width: 100%;">
					<img src="../img/avx_experience.png" alt="Experience is Better at Santikos Theatres" />
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<footer>
		</footer>
	</body>
</html>