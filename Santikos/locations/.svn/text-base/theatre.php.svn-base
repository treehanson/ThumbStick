<?php
require_once '../db/db_conn.php';
	
	// Get house id or default to first house_id
	if (isset($_GET['house_id'])) {
		$house_id = $_GET['house_id'];
	} else {
		$house_id = $houses[0]['house_id'];
	}
	if ($house_id == "29811"){
	   $url = "http://santikos.cinema-source.com/locations/palladium22.php";
	   Header("Location: $url");
	}
	
	// Get date or default to today
	if (isset($_GET['date'])) {
		$date = date('Y-m-d', strtotime($_GET['date']));
	} else {
		$date = date('Y-m-d', strtotime('today'));
	}
	
	$name = $movies = $maxDate = $photoURL2 = $row_web= $query_web = $db_web = "";
	
	// Select house details from database
	$query = $db->prepare("SELECT * FROM Houses WITH(NOLOCK) WHERE house_id = :house_id");
	$query->execute(array(":house_id" => $house_id));
	$house = $query->fetch();
	
	$name = $house['name'];
	
	// Create address and Google Maps URL
	$address = trim($house['address1']) . "<br />" . trim($house['city']) . ", " . trim($house['state']) . " " . trim($house['zip']);
	$g_maps = "http://maps.google.com?q=" . trim($house['name']) . ", " . trim($house['address1']) . ", " . trim($house['city']) . ", " . trim($house['state']) . ", " . trim($house['zip']);
	
	// Select maximum date for datepicker
	$query = $db->prepare('SELECT TOP 1 showdate FROM Screens WITH(NOLOCK) WHERE house_id = :house_id ORDER BY showdate DESC');
	$query->execute(array('house_id' => $house_id));
	$row = $query->fetch();
	$maxDate = date('m/d/Y', strtotime($row['showdate']));
	
	//get photoURL2
	try {
		$db_web = new PDO("sqlsrv:Server=kraken;Database=websites", "readonly", "readonly");
	}
	catch(PDOException $e) {
		die("Error Connecting to Database.");
		//echo "error";
	}
	$query = $db_web->prepare('SELECT * FROM websites..sitehouses WHERE house_id= :house_id');
	$query->execute(array('house_id' => $house_id));
	$row = $query->fetch();
	$photoURL2 = $row['PhotoUrl2'];
	if ($photoURL2 == '') {
		$photoURL2 = "http://placehold.it/230x230";
	}else{
		$photoURL2 = "http://www.filmsxpress.com/images/theatres/161/" . $photoURL2 ;	
	}
	
	// Select showtimes for this theatre for the database
	$query = $db->prepare("
		SELECT distinct Screens.movie_id, name, mpaa, release, runtime, showdate, time1, time2, time3, time4, time5, time6, 
		time7, time8,time9, time10, time11, time12, time13, time14, time15, 
		time16, time17, time18, time19, time20, time21, time22, time23, time24,
		mer1, mer2, mer3, mer4, mer5, mer6, mer7, mer8, mer9, mer10, mer11, mer12, 
		mer13, mer14, mer15, mer16, mer17, mer18, mer19, mer20, mer21, mer22, mer23, mer24, comment
		FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK) WHERE house_id = :house_id AND showdate = :date AND Screens.movie_id = Movies.movie_id 
		ORDER BY release DESC
	");
	$query->execute(array(':house_id' => $house_id, ':date' => $date));
	$rows = $query->fetchAll();
	
	// Loop through each movie, format it and add it to the html
	foreach($rows as $row) {
		
		$times = "";
		$movie_id = trimDecimals($row['movie_id']);
		
		//echo "test: " . $movie_id;
		
		$url_date = date("mdY", strtotime($date));
		
		// Create linked showtimes to movietickets.com
		for ($i = 1; $i < 25; $i++) {
			if (strlen(trim($row["time$i"])) > 0) {
				$url_time = get24HourTime($row["time$i"], $row["mer$i"]);
				$url = "http://www.movietickets.com/purchase.asp?house_id=$house_id&movie_id=$movie_id&perfd=$url_date&perft=$url_time";
				if ($i == 1)
					$times .= "<a href='$url' target='_blank'>" . trimTime($row["time$i"]) . "</a>";
				else 
					$times .= ", <a href='$url' target='_blank'>" . trimTime($row["time$i"]) . "</a>";
			}
		}	
		
		
		// Format movie and showtime data for output
		$movies .= "
			<div class='showtime round'>
				<a href='../movie_details.php?movie_id=$movie_id' alt='" . htmlentities(getName($row['name']), ENT_QUOTES) . "' title='" . htmlentities(getName($row['name']), ENT_QUOTES) . "'>
					<img src='" . getPoster($movie_id) . "' />
				</a>
				<a href='../movie_details.php?movie_id=$movie_id'><h2>" . getName($row['name']) . "</h2></a>
				<p><i>" . $row['mpaa'] . "</i> " . getRuntime($row['runtime']) . "</p>
				<!--<p><b>Reserved Seating:</b></p>-->
				<p><strong>" . date('D', strtotime($date)) . ":</strong> $times</p>
				<p>" . $row['comment'] . "</p>
				<div class='clearfix'></div>
			</div>
		";
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
		<title><?php echo $name; ?></title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
		<link rel="stylesheet" href="../css/blitzer/jquery-ui-1.8.21.custom.css">
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
				<div id="left">
					<div class="small-box round">
						<div id="t-side">
							<a href="../locations/theatre.php?house_id=<?php echo $house_id; ?>&theatre_information=true" class="round <?php if (!isset($_GET['menu_amenities']) && !isset($_GET['prices_policies'])) echo "selected-day"; ?>">THEATRE INFORMATION</a>
							<a href="../locations/theatre.php?house_id=<?php echo $house_id; ?>&menu_amenities=true" class="round <?php if (isset($_GET['menu_amenities'])) echo "selected-day"; ?>">MENU/AMENITIES</a>
							<a href="../locations/theatre.php?house_id=<?php echo $house_id; ?>&prices_policies=true" class="round <?php if (isset($_GET['prices_policies'])) echo "selected-day"; ?>">PRICES/POLICIES</a>
							<img src="<?php echo $photoURL2; ?>" />
                        </div>
                        <?php
							if (isset($_GET['menu_amenities']) && $_GET['menu_amenities'] == "true") {
								require_once '../include/amenities_'. $house_id .'.php';
								//echo "
								//	<div>
								//		<a href='#' class='round selected-day'>Restaurant</a>
								//	</div>
								//";
								
								foreach ($amenities as $amenity ) {
										if ($amenity["USED"]=="yes"){
									  	echo "<div>";
											if ($amenity["URL"] == ""){
												echo "<img src='../img/amenities/" . str_replace('/','',str_replace(' ','',$amenity["title"])) . ".png' border='0'  style='margin-bottom:6px;'>";
											}
											else{
												echo "<a href='" . $amenity["URL"] . "' class='various' data-fancybox-type='iframe' style='text-decoration:none'><img src='../img/amenities/" . str_replace('/','',str_replace(' ','',$amenity["title"])) . ".png' border='0'  style='margin-bottom:6px;'></a>";
											}
										echo "</div>";}
								  
								  
								}

								
							} else if (isset($_GET['prices_policies']) && $_GET['prices_policies'] == "true") {
								require_once '../include/pricing/pricing_' . $house_id . '.php';
								require_once '../include/pricing/policies.php';
							} else {
								echo "
								<div>
									<h4>$name</h4>
									<p>$address</p>
									<a href='$g_maps' class='round' target='_blank'>CLICK FOR DIRECTIONS</a>
								</div>
								<div>
									<p><b>For Showtimes: </b>" . $house['movieline'] . "</p>
									<p><b>Guest Services: </b>" . $house['phone1'] . "</p>
								</div>
								";
							}
							?>
                            
                          
					</div>
				</div>
				<div id="right">
					<div class="big-box round">
						<div id="t-location">
							<h1><?php echo $name; ?></h1>
							<a href="../locations.php" class="round">SELECT ANOTHER LOCATION</a>
							<div class="clearfix"></div>
						</div>
						<div id="t-dates">
							<div id="t-selected-date">TIMES FOR: <b><?php echo date("l, F jS", strtotime($date)) ?></b></div>
							<a href="../print.php?house_id=<?php echo $house_id . "&date=" . $date; ?>" target="_blank" id="printer-friendly" class="round"><img src="file:///Macintosh HD/Users/rfonseca/Sites/img/printer.png" />PRINTER FRIENDLY SHOWTIMES</a>
							<div class="clearfix"></div>
						</div>
						<div id="date-select">
							<?php
								$day = date("Y-m-d", strtotime("today"));
								$target = date("Y-m-d", strtotime("today +6 days"));
								while ($day <= $target) {
									if ($day == date("Y-m-d", strtotime("today"))) {
										echo "<a class='day ";
										if ($day == $date) {
											echo "selected-day";
										}
										echo " round' href='../locations/theatre.php?house_id=$house_id&date=$day'>TODAY</a>";
									} else {
										echo "<a class='day ";
										if ($day == $date) {
											echo "selected-day";
										}
										echo " round' href='../locations/theatre.php?house_id=$house_id&date=$day'>", strtoupper(date("D", strtotime($day))), "</a>";
									}
									$day = date("Y-m-d", strtotime($day . " +1 day"));
								}
								echo "
									<form id='form' action='' method='get'>
										<input type='hidden' name='house_id' value='$house_id' />
										<input id='datepicker' class='day round' style='padding: 1px 0;' type='text' name='date' value='MORE' />
									</form>
								";
							?>
							<div class="clearfix"></div>
						</div>
						<div id="showtimes">
							<?php echo $movies; ?>
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
		<script src="../js/jquery-ui-1.8.21.custom.min.js"></script>
		<script>
			$('#datepicker').datepicker({
				maxDate: '<?php echo $maxDate; ?>',
				minDate: new Date(),
				onSelect: function(dateText, inst) {
					$('#form').submit();
				}
			});
		</script>
	</body>
</html>