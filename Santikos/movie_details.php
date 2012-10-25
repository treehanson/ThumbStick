<?php
	require_once 'db/db_conn.php';
	
	// Check if date is selected, else defaults to today's date
	if (isset($_GET['date'])) {
		$date = date("Y-m-d", strtotime($_GET['date']));
	} else {
		$date = date("Y-m-d", strtotime("today"));
	}
			
	
	$movie_id = $name = $mpaa = $advisory = $genre = $actors = $director = $release = $runtime = $url = $poster = $trailer = $description = "";
	$ns_movies = array();
	$ns_thumbs = $maxDate = "";
	
	// Get the movie id
	if (isset($_GET['movie_id'])) {
		$movie_id = $_GET['movie_id'];
		
		//see if movie is playing on given date 
		$query = $db->prepare("select top(1) showdate as showdate from screens where ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) and showdate >= :date and movie_id = :movie_id order by showdate");
		$query->execute(array(':movie_id' => $movie_id, ':date' => $date));
		$row =  $query->fetch();
		
		$isPlaying = trim($row['showdate']);		
		$isPlaying =  date('Y-m-d', strtotime($isPlaying));
		//echo "isPlaying: " . $isPlaying . "<br />";
		
		//if there isn't a showdate
		if (($isPlaying == "") || ($isPlaying == "1969-12-31") || ($isPlaying == date('Y-m-d', strtotime(""))))
		{		
			//if not playing on given date fast foward to first show date
			$query = $db->prepare("select top(1) showdate from screens where ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) and showdate >= :date and movie_id = :movie_id order by showdate");
			$query->execute(array(':movie_id' => $movie_id, ':date' => date('Y-m-d', strtotime('today'))));
			
			//echo "date: " . date('Y-m-d', strtotime('today')) . "<br />";
			//echo "movie_id: " . $movie_id . "<br />";
			//echo "select top(1) showdate from screens where ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) and showdate >= :date and movie_id = :movie_id order by showdate" . "<br />";
			
			$row =  $query->fetch();			
			$getEarliest = trim($row['showdate']);			
			$getEarliest =  date('Y-m-d', strtotime($getEarliest));
			
			//if there is a showdate
			if (($date != $getEarliest) && ($getEarliest <> "") && ($getEarliest <> "1969-12-31") && ($getEarliest <> date('Y-m-d', strtotime(""))))
			{
				echo "date: " . $date . "<br />";
				echo "get Earliest: " . $getEarliest . "<br />";
				echo "header: " . "movie_details.php?movie_id=" . $movie_id . "&date=" . $getEarliest;
				//header("Location: movie_details.php?movie_id=" . $_GET['movie_id'] . "&date=" . $getEarliest);	
			}
		}
	}
	
	try {
		
		// Go through each house and get current movies
		foreach ($houses as $house) {
			$house_id = $house['house_id'];
			
			$query = $db->prepare("
				SELECT Screens.movie_id, name, mpaa, comment, release, showdate, movies.videos
				FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK) WHERE house_id = :house_id AND showdate = :date AND Screens.movie_id = Movies.movie_id  and Movies.parent_id = 0 ORDER BY release DESC 
			");
	
			$query->execute(array(':house_id' => $house_id, ':date' => date('Y-m-d', strtotime('today'))));
			$rows =  $query->fetchAll();
			
			// Fill Now Showing movies array with unique movies
			foreach($rows as $row) {
				$ns_movies[trim($row['movie_id'])] = $row;
			}
		}
		
		// Add movies to Now Showing thumbnail scroller
		foreach ($ns_movies as $key => $value) {
			$ns_thumbs .= "<a href='../movie_details.php?movie_id=$key'><img src='" . getPoster($key) . "' alt='" . htmlentities(getName($value['name']), ENT_QUOTES) . "' title='" . htmlentities(getName($value['name']), ENT_QUOTES) . "' /></a>";
		}
		
		// Choose first movie as default to display on page.
		foreach ($ns_movies as $key => $value) {
			if ($movie_id == "") {
				$movie_id = $key;
			}
			break;
		}
		
		// Get movie details from the database to display
		$query = $db->prepare("
			SELECT movie_id, name, mpaa, advisory, 
			genre, genre2, genre3, 
			actor1, actor2, actor3, actor4, actor5, actor6, actor7, actor8, actor9, actor10, 
			director, release, runtime, photos, videos, flv_high, url 
			FROM Movies WITH(NOLOCK) 
			WHERE movie_id = :movie_id
		");
		$query->execute(array(":movie_id" => $movie_id));
		$row = $query->fetch();
		
		// Grab all details into variables for display
		$name = getName($row['name']);
		$mpaa = getMPAA(trim($row['mpaa']));
		$advisory = $row['advisory'];
		$director = $row['director'];
		$release = date("F j, Y", strtotime($row['release']));
		$runtime = getRuntime($row['runtime']);
		$url = $row['url'];
		$poster = getPoster($movie_id);
		$trailer = getTrailer($movie_id);
		$thumb = getThumb($movie_id);
		
		$videos = $row['videos'];
		if (!$videos){
			$videos = "no";
		}else {
			$videos = "yes";
		}
		
		// Combine genres
		for ($i = 0; $i < 3; $i++) {
			if ($i == 0) {
				$genre = trim($row['genre']);
			} else if (strlen(trim($row['genre' . ($i + 1)])) > 0) {
				$genre .= ", " . trim($row['genre' . ($i + 1)]);
			}
		}
		
		// Combine actors
		for ($i = 0; $i < 10; $i++) {
			if ($i == 0) {
				$actors = trim($row['actor' . ($i + 1)]);
			} else if (strlen(trim($row['actor' . ($i + 1)])) > 0) {
				$actors .= ", " . trim($row['actor' . ($i + 1)]);
			}
		}
		
		// Get the movie description
		$query = $db->prepare("SELECT capsule FROM Reviews WITH(NOLOCK) WHERE movie_id = :movie_id AND sid = :sid");
		$query->execute(array(':movie_id' => $movie_id, ':sid' => "HOME"));
		$row = $query->fetch();
		$description = $row[0];
		
		for ($i = 0; $i < count($houses); $i++) {
			if ($i === 0) {
				$append = " house_id = '" . $houses[$i]['house_id'] . "' ";
			} else if (strlen($houses[$i]['house_id']) > 0) {
				$append .= " OR house_id = '" . $houses[$i]['house_id'] . "' ";
			}
		}
		
		$query = $db->prepare("SELECT TOP 1 showdate FROM Screens WITH(NOLOCK) WHERE movie_id = :movie_id AND $append ORDER BY showdate DESC");
		$query->execute(array(':movie_id' => $movie_id));
		$row = $query->fetch();
		
		$maxDate = date('m/d/Y', strtotime($row['showdate']));
		
		function checkIfPlaying($db, $house_id, $movie_id, $date) {
			$query = $db->prepare("SELECT * FROM Screens WHERE house_id = :house_id AND movie_id = :movie_id AND showdate = :date");
			$query->execute(array(":house_id" => $house_id, ":movie_id" => $movie_id, ":date" => $date));
			$rows = $query->fetchAll();
			
			if (count($rows) > 0) {
				return "";
			} else {
				return "class='not-playing'";
			}
		}
		
	} catch (PDOException $e) {
		
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
		<title>Santikos Theatres: <?php echo $name; ?></title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
        
		<link rel="stylesheet" href="css/blitzer/jquery-ui-1.8.21.custom.css">
		<script src="js/libs/modernizr-2.5.3.min.js"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
		<script src="js/jwplayer/player.swf"></script>
		<script src="js/jwplayer/jwplayer.js"></script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once 'include/header.php'; ?>
			<!-- main -->
			<div role="main">
				<div id="left">
					<div id="movies-side" class="small-box round">
						<img src="<?php echo $poster; ?>" alt="<?php echo htmlentities($name, ENT_QUOTES); ?>" />
						<div>
							<h4>Release Date:</h4>
							<p><?php echo $release; ?></p>
						</div>
						<div>
							<h4>Cast:</h4>
							<p><?php echo $actors; ?></p>
						</div>
						<div>
							<h4>Director:</h4>
							<p><?php echo $director; ?></p>
						</div>
						<div>
							<h4>Genre:</h4>
							<p><?php echo $genre; ?></p>
						</div>
						<div>
							<h4>Run Time:</h4>
							<p><?php echo $runtime; ?></p>
						</div>
						<div>
							<h4>MPAA Rating:</h4>
							<p><?php echo $mpaa, " <i>", $advisory; ?></i></p>
						</div>
						<div>
							<h4>Synopsis:</h4>
							<p><?php echo $description; ?></p>
						</div>
					</div>
				</div>
				<div id="right">
					<div id="movies-main" class="big-box round">
						<div>
							<h1><?php echo $name, "<i> ($mpaa)</i>"; ?></h1>
							<form id="form" method="get" action="">
								<input type="hidden" name="movie_id" value="<?php echo $movie_id; ?>" />
								<input id="datepicker" name="date" value="select another day" class="round" style="width: 170px;" />
							</form>
							<div class="clearfix"></div>
						</div>
						<div>
							<h2>PLAYING <?php echo strtoupper(date("F j", strtotime($date))); ?> AT: </h2>
							<div id="movies-theatres">
								<div id="movies-theatres-left" class="round">
									<h3>SAN ANTONIO AREA</h3>
									<?php
										foreach ($houses as $house) {
											if ($house['area'] == 'San Antonio') {
												
												$times = ""; 
												// Select showtimes for this theatre for the database
												$query = $db->prepare("SELECT * FROM Screens WHERE house_id = :house_id AND movie_id = :movie_id AND showdate = :date");
												$query->execute(array(":house_id" => $house['house_id'], ":movie_id" => $movie_id, ":date" => $date));
												$timesLists = $query->fetchAll();
												// Create linked showtimes to movietickets.com
												foreach ($timesLists as $timesList) {
													//add breaks between movie times
													if ($times <> "") {
														$times .= "\n";	
													}
													//add comment
													if (trim($timesList["comment"]) <> ""){
														$times .=  trim($timesList["comment"]) . ": "; 
													}
													for ($i = 1; $i < 25; $i++) {
														if (strlen(trim($timesList["time$i"])) > 0) {
															if ($i == 1)
																$times .=  ltrim($timesList["time$i"],"0");
															else 
																$times .= ", " . ltrim($timesList["time$i"],"0");	
															//add am/pm
															if ($timesList["mer$i"] == "1") 
																$times .= "am";
															else
																$times .= "pm";
														}
													}														
												}
												echo "<a title='" . $times . "' href='../locations/theatre.php?house_id=", $house['house_id'], "'", checkIfPlaying($db, $house['house_id'], $movie_id, $date), ">", $house['name'], "</a>";
											}
										}
									?>
								</div>
								<div id="movies-theatres-right" class="round">
									<h3>HOUSTON AREA</h3>
									<?php
										foreach ($houses as $house) {
											if ($house['area'] == 'Houston') {
												$times = ""; 
												// Select showtimes for this theatre for the database
												$query = $db->prepare("SELECT * FROM Screens WHERE house_id = :house_id AND movie_id = :movie_id AND showdate = :date");
												$query->execute(array(":house_id" => $house['house_id'], ":movie_id" => $movie_id, ":date" => $date));
												$timesLists = $query->fetchAll();
												// Create linked showtimes to movietickets.com
												foreach ($timesLists as $timesList) {
													//add breaks between movie times
													if ($times <> "") {
														$times .= "\n";	
													}
													//add comment
													if (trim($timesList["comment"]) <> ""){
														$times .=  trim($timesList["comment"]) . ": "; 
													}
													for ($i = 1; $i < 25; $i++) {
														if (strlen(trim($timesList["time$i"])) > 0) {
															if ($i == 1)
																$times .=  ltrim($timesList["time$i"],"0");
															else 
																$times .= ", " . ltrim($timesList["time$i"],"0");		
															//add am/pm
															if ($timesList["mer$i"] == "1") 
																$times .= "am";
															else
																$times .= "pm";
																
														}
													}														
												}
												echo "<a title='" . $times . "' href='../locations/theatre.php?house_id=", $house['house_id'], "'", checkIfPlaying($db, $house['house_id'], $movie_id, $date), ">", $house['name'], "</a>";
											}
										}
									?>
								</div>
							</div>
							<div class="clearfix"></div>
						</div>
                        <?php if ($videos == "yes"){ ?>
						<div id="trailer">
							
						</div>
                        <?php } ?>
						<div id="scroller">
							<?php echo $ns_thumbs; ?>
						</div>
						<div class="clearfix"></div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<!-- footer -->
		<?php require_once 'include/footer.php'; ?>
		<footer>
		</footer>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="../js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="js/jquery-ui-1.8.21.custom.min.js"></script>
		<script>
			$('#datepicker').datepicker({
				maxDate: '<?php echo $maxDate; ?>',
				minDate: new Date(),
				onSelect: function(dateText, inst) {
					$('#form').submit();
				}
			});
		
			jwplayer('trailer').setup({
				'flashplayer' : '../js/jwplayer/player.swf',
				'width' : '100%',
				'height' : '475',
				'stretching' : 'fill',
				'file' : '<?php echo $trailer; ?>',
				'image' : '<?php echo $thumb; ?>'
			});
		</script>
	</body>
</html>