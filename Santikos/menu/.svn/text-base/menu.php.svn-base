<?php
require_once "../db/db_conn.php";
	
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
		<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
        
		<link rel="stylesheet" href="../js/nivo-slider/nivo-slider.css">
		<link rel="stylesheet" href="../js/nivo-slider/themes/default/default.css">
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script>
			function information(type){
				if (type == "gelato")	{
					document.getElementById('information').innerHTML = '<b>Gelato</b>- We make all of our gelato fresh at the theatre and proudly serve a wide variety of flavors.  Sampling is encouraged.  Gelato is available at the Palladium IMAX and Silverado IMAX and is coming soon to the new Palladium in Houston.  ';
				}
				if (type == "coke")	{
					document.getElementById('information').innerHTML = '<b>Coca Cola Freestyle</b>- Choose from over 100+ different combinations of Coca Cola products and flavors that you can customize just the way you want it.  Coca Cola Freestyle is available at Palladium IMAX, Silverado IMAX, Mayan Palace and coming soon to the new Palladium in Houston and others.  Learn more at <a href=http://www.coca-colafreestyle.com/ target=_blank>http://www.coca-colafreestyle.com/</a> ';
				}
				if (type == "catering")	{
					document.getElementById('information').innerHTML = '<b>Catering</b>-Make your next group event memorable.  From a buffet to boxed lunches or cocktails, we offer numerous food and beverage options that can accommodate large and small gatherings.  Learn more at our Private Events page.  ';
				}
				if (type == "starbucks")	{
					document.getElementById('information').innerHTML = '<b>Starbucks</b>- We proudly serve Starbucks coffee and feature a wide variety of coffee based drinks.  Starbucks is available at Palladium IMAX, Silverado IMAX, Silverado 16, Rialto, Embassy 14 and the Bijou.';
				}
				if (type == "restaurant")	{
					document.getElementById('information').innerHTML = '<b>Caf&eacute;/Restaurant</b>- We offer several different menus that feature burgers, sandwiches, pizza, salads and even sushi.   The food is available to eat in the dining area or you can take it with you into the theatre and enjoy it while you watch your film. Caf&eacute; and restaurant dining is available at Palladium IMAX, Silverado IMAX, Silverado 16 and is coming soon to the new Palladium in Houston.';
				}
				if (type == "expanded")	{
					document.getElementById('information').innerHTML = '<b>Expanded Concessions</b>- We proudly serve everyone’s favorite concession items including fresh popped popcorn and Coca Cola products.  We also offer additional items such as pizza, nachos, hot dogs, funnel cakes, chicken fingers and more.  Selections do vary by theatre.  Expanded concessions are available at the Mayan Palace and Embassy 14.';
				}
				if (type == "bar")	{
					document.getElementById('information').innerHTML = '<b>At the Bar</b>- For our guests over 21 years of age, we offer a wide assortment of bottled and draft beers featuring both domestic and imported varieties.  We also offer a selection of wines that are available by the glass or bottle. Wine and beer are offered at all theatres (coming soon to the Northwest.)  Several of our theatres also feature a full assortment of mixed drinks and even specialty drinks created just for a film. Cocktails are available at Palladium IMAX, Silverado IMAX and Rialto.';
				}
				if (type == "theatre")	{
					document.getElementById('information').innerHTML = '<b>In Theatre Dining</b>- Pick up your tickets and head into the theatre.  Our servers will stop by and collect your drink and food order and bring it to your table so that you can enjoy your meal while watching a film.  In theatre dining is featured at the Rialto, the Bijou and is coming soon to the new Palladium in Houston. ';
				}
			}
			function informationDelete(){
				document.getElementById('information').innerHTML = '';
			}
		</script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
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
                    <div id="information" class="small-box round" style='background-color:#acacac'>
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
                     <br /><br />
                     <div class="big-box round" style="padding-bottom:15px;background-color:#acacac">                       
						<a href="#" onMouseOver="information('gelato')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/gelato.jpg"/>
								<img src="../img/gelato_H.jpg"/>
							</div>  
						</a>
						<a href="http://www.coca-colafreestyle.com/" target="_new" onMouseOver="information('coke')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/coke.jpg" />
								<img src="../img/coke_H.jpg" />
							</div>  
						</a>
						<a href="#" onMouseOver="information('catering')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/catering.jpg" />
								<img src="../img/catering_H.jpg" />
							</div>  
						</a>
						<a href="#" onMouseOver="information('starbucks')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/starbucks.jpg" />
								<img src="../img/starbucks_H.jpg" />
							</div>  
						</a>
						<a href="#" onMouseOver="information('expanded')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/expandedconcessions.jpg" />
								<img src="../img/expandedconcessions_H.jpg" />
							</div>  
						</a>
						<a href="#"  onMouseOver="information('restaurant')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/restaurant.jpg" />
								<img src="../img/restaurant_H.jpg" />
							</div>  
						</a>
						<a href="#"  onMouseOver="information('bar')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/at the bar.jpg" />
								<img src="../img/at the bar_H.jpg" />
							</div>  
						</a>
                        <a href="#"  onMouseOver="information('theatre')" onMouseOut="informationDelete()">
							<div class="button2 round">
								<img src="../img/intheatredining.jpg" />
								<img src="../img/intheatredining_H.jpg" />
							</div>  
						</a>
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