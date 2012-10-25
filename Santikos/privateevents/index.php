<?php
require_once "../db/db_conn.php";
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
		<title>Santikos Theatres</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
        
		<link rel="stylesheet" href="../js/nivo-slider/nivo-slider.css">
		<link rel="stylesheet" href="../js/nivo-slider/themes/default/default.css">
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
				<div id="left">
					<div id="theatres" class="small-box round" style='background-color:#acacac'>
						Plan your next event.
                        We offer a wide variety of services.
                        
                        <a href="http://intranet.santikos.com/rentals/rental_records_maint.php?iframe=true&width=740&height=400" class="various" data-fancybox-type="iframe" style="text-decoration:none">Tell us about your event</a>
					</div>
				</div>
				<div id="right">
					<div class="big-box round" style="padding-bottom: 0">
						<div class="slider-wrapper theme-default">
							<div id="slider" class="nivoSlider">
                            <?php
							$query = $db->prepare("select * from websites.dbo.carousel where SiteID = 161 and convert(datetime,[expDate]) >= :date and category like '%private%' order by sort");
							$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));
							$rows = $query->fetchAll();
							// Load up carousel images
							foreach($rows as $row) {
								$ns_carousel[trim($row['carouselID'])] = $row;
							}
							foreach ($ns_carousel as $key => $value) {
							$nsC .= "<a href='" . htmlentities(getName($value['URL'])) ."'>";
							$nsC .= "<img src='http://www.filmsxpress.com/images/Carousel/161/" . htmlentities(getName($value['largeImage'])) . "' alt='"; 
							$nsC .= htmlentities(getName($value['imageTXT']), ENT_QUOTES) . "' title='"; 
							$nsC .= htmlentities(getName($value['imageTXT']), ENT_QUOTES) . "' /></a>";
							
							}
							echo $nsC;
							?>
							</div>
						</div>
					</div>					
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<footer>
		</footer>
		<script src="../js/nivo-slider/jquery.nivo.slider.pack.js"></script>
		<script type="text/javascript">
			$(window).load(function() {
			    $('#slider').nivoSlider();
			});
		</script>
	</body>
</html>