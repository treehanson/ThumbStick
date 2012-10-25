<?php
require_once "db/db_conn.php";
	
	$nowPlaying = $comingSoon = $concertsEvents = $artIndependent = false;
	$san_antonio = $houston = "";
	
	// Check for navigation of same page options
	if (isset($_GET['comingSoon']) || isset($_GET['concertsEvents']) || isset($_GET['artIndependent'])) {
		if (isset($_GET['comingSoon'])) {
			$comingSoon = true;
		} else if (isset($_GET['concertsEvents'])) {
			$concertsEvents = true;
		} else if (isset($_GET['artIndependent'])) {
			$artIndependent = true;
		}
	} else {
		$nowPlaying = true;
	}
	
	$ns_movies = array();
	$ns = "";
	
	$imax = array();
	$dbox = array();
	
	// Loop through eac house and find the coming soon data
	foreach ($houses as $house) {
		$house_id = $house['house_id'];
		
		$query = $db->prepare("
			SELECT Screens.movie_id, name, mpaa, comment, release, showdate 
			FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK) WHERE house_id = :house_id AND showdate = :date AND Screens.movie_id = Movies.movie_id
			ORDER BY release DESC
		");
		$query->execute(array(':house_id' => $house_id, ':date' => date('Y-m-d', strtotime('today'))));
		$rows = $query->fetchAll();
		// Load up movies for all theatres into array, using movie_id as key so array is unique
		foreach($rows as $row) {
			$ns_movies[trim($row['movie_id'])] = $row;
		}
	}
	
	// Loop through each movie and add poster to Now Showing section
	foreach ($ns_movies as $key => $value) {
		$ns .= "<a href='../movie_details.php?movie_id=$key'><img src='" . getPoster($key) . "' alt='" . htmlentities(getName($value['name']), ENT_QUOTES) . "' title='" . htmlentities(getName($value['name']), ENT_QUOTES) . "' /></a>";
		// Get IMAX movies
		if (count($imax) === 0) {
			if (checkIMAX($value['name'])) {
				$imax['name'] = getName($value['name']);
				$imax['poster'] = getThumb($key);
				$imax['url'] = "../movie_details.php?movie_id=$key";
				$imax['mpaa'] = getMPAA(trim($value['mpaa']));
			}
		} 
		if (count($dbox) === 0) {
			if (checkDBOX($value['comment'])) {
				$dbox['name'] = getName($value['name']);
				$dbox['poster'] = getThumb($key);
				$dbox['url'] = "../movie_details.php?movie_id=$key";
				$dbox['mpaa'] = getMPAA(trim($value['mpaa']));
			}
		}
	}

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
		<link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
        
		<link rel="stylesheet" href="js/nivo-slider/nivo-slider.css">
		<link rel="stylesheet" href="js/nivo-slider/themes/default/default.css">
		<script src="js/libs/modernizr-2.5.3.min.js"></script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once 'include/header.php'; ?>
			<!-- main -->
			<div role="main">
				<div id="left">
					<div id="theatres" class="small-box round" style='background-color:#acacac'>
						<h2>Select a theater for <b>MENU</b></h2>
						<h3>San Antonio Area</h3>
						<?php
							foreach ($houses as $house) {
								if ($house['area'] == "San Antonio") {
									if ($_GET['house_id'] == $house['house_id']){
									echo "<a href='../menu.php?house_id=", $house['house_id'], "' style='background-color:#e7e7e7'>", $house['name'], "</a>";
									}else{
									echo "<a href='../menu.php?house_id=", $house['house_id'], "'>", $house['name'], "</a>";									
									}
								}
							}
						?>
						<h3>Houston Area</h3>
						<?php
							foreach ($houses as $house) {
								if ($house['area'] == "Houston") {
									if ($_GET['house_id'] == $house['house_id']){
									echo "<a href='../menu.php?house_id=", $house['house_id'], "' style='background-color:#e7e7e7'>", $house['name'], "</a>";
									}else{
									echo "<a href='../menu.php?house_id=", $house['house_id'], "'>", $house['name'], "</a>";									
									}
								}
 							}
						?>
					</div>
				</div>
				<div id="right">
					<div class="big-box round" style="padding-bottom: 0">
						<div class="slider-wrapper theme-default">
							<div id="slider" class="nivoSlider">
                            <?php
							$query = $db->prepare("select * from websites.dbo.carousel where SiteID = 161 and convert(datetime,[expDate]) >= :date and category like '%menu%' order by sort");
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
		<?php require_once 'include/footer.php'; ?>
		<footer>
		</footer>
		<script src="js/nivo-slider/jquery.nivo.slider.pack.js"></script>
		<script type="text/javascript">
			$(window).load(function() {
			    $('#slider').nivoSlider();
			});
		</script>
	</body>
</html>