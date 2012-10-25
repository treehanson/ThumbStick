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
					<div id="theatres" class="small-box round">
						<h2>Select a theater for <b>SHOWTIMES &amp; TICKETS</b></h2>
						<h3>San Antonio Area</h3>
						<?php
							foreach ($houses as $house) {
								if ($house['area'] == "San Antonio") {
									echo "<a href='../locations/theatre.php?house_id=", $house['house_id'], "'>", $house['name'], "</a>";
								}
							}
						?>
						<h3>Houston Area</h3>
						<?php
							foreach ($houses as $house) {
								if ($house['area'] == "Houston") {
									echo "<a href='../locations/theatre.php?house_id=", $house['house_id'], "'>", $house['name'], "</a>";
								}
 							}
						?>
					</div>
					<div class="small-box round">
						<img src="../img/imax.png" alt="Now Playing in IMAX" />
						<a href="<?php echo $imax['url'] ?>" class="now-playing">
							<img src="<?php echo $imax['poster'] ?>" />
							<p><b><?php echo $imax['name'] ?></b> (<?php echo $imax['mpaa']; ?>)</p>
						</a>
					</div>
					<div class="small-box round">
						<img src="../img/dbox.png" alt="Now Playing in D-Box" />
						<a href="<?php echo $dbox['url']; ?>" class="now-playing">
							<img src="<?php echo $dbox['poster'] ?>" />
							<p><b><?php echo  $dbox['name']; ?></b> (<?php echo $dbox['mpaa']; ?>)</p>
						</a>
					</div>
				</div>
				<div id="right">
					<div class="big-box round" style="padding-bottom: 0">
						<div class="slider-wrapper theme-default">
							<div id="slider" class="nivoSlider">
                            <?php
							$query = $db->prepare("select * from websites.dbo.carousel where SiteID = 161 and convert(datetime,[expDate]) >= :date order by sort");
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
					<div class="big-box round">
						<div id="scroller-nav">
							<a href="index.php?search=nowplaying" class="round <?php if (($_GET['search'] == 'nowplaying')||($_GET['search'] == '')) echo "selected"; ?>">NOW PLAYING</a>
							<a href="index.php?search=comingsoon" class="round <?php if ($_GET['search'] == 'comingsoon') echo "selected"; ?>">COMING SOON</a>
							<a href="index.php?search=events" class="round <?php if ($_GET['search'] == 'events') echo "selected"; ?>">CONCERTS &amp; EVENTS</a>
							<a href="index.php?search=art" class="round <?php if ($_GET['search'] == 'art') echo "selected"; ?>">ART &amp; INDEPENDENT</a>
						</div>
						<div id="scroller">
							<?php 
							if ($_GET['search'] == 'nowplaying'){
							//$query = $db->prepare("SELECT distinct Screens.movie_id, name, mpaa, comment, release
//FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) AND showdate = :date
//AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0
//ORDER BY release DESC");
						$query = $db->prepare("select distinct Mov.movie_id, mov.photos, Mov.actor1, Mov.actor2,  case when rtrim(isnull(cs.title,'')) = '' then Mov.name else cs.title end as name, Mov.mpaa, Mov.advisory, Mov.runtime, case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as rel, Mov.reltxt, Mov.release2, Mov.reltxt2, Mov.release3, Mov.reltxt3,  case when rtrim(isnull(cs.url, '')) = '' then Mov.url else cs.url end as movieurl, Rev.movie_id, Rev.capsule, Rev.sid, cs.start_date, cs.end_date, cs.release, cs.title, cs.url, cs.cs_type FROM cinema..movies Mov WITH(NOLOCK) INNER JOIN websites..comingsoon cs WITH(NOLOCK) ON Mov.movie_id = cs.movie_id INNER JOIN cinema..reviews Rev WITH(NOLOCK) ON rev.movie_id = cs.movie_id WHERE cs.siteid = 161 and rev.sid = 'HOME' and CAST(case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as DateTime) <= :date AND Mov.PARENT_ID = 0 order by rel, name");
						//echo "select distinct Mov.movie_id, mov.photos, Mov.actor1, Mov.actor2,  case when rtrim(isnull(cs.title,'')) = '' then Mov.name else cs.title end as moviename, Mov.mpaa, Mov.advisory, Mov.runtime, case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as rel, Mov.reltxt, Mov.release2, Mov.reltxt2, Mov.release3, Mov.reltxt3,  case when rtrim(isnull(cs.url, '')) = '' then Mov.url else cs.url end as movieurl, Rev.movie_id, Rev.capsule, Rev.sid, cs.start_date, cs.end_date, cs.release, cs.title, cs.url, cs.cs_type FROM cinema..movies Mov WITH(NOLOCK) INNER JOIN websites..comingsoon cs WITH(NOLOCK) ON Mov.movie_id = cs.movie_id INNER JOIN cinema..reviews Rev WITH(NOLOCK) ON rev.movie_id = cs.movie_id WHERE cs.siteid = 161 and rev.sid = 'HOME' and CAST(case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as DateTime) <= :date order by rel, moviename";
						}elseif ($_GET['search'] == 'comingsoon'){
								//$query = $db->prepare("SELECT distinct Screens.movie_id, name, mpaa, comment, release
//FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) AND showdate > :date
//AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0
//ORDER BY release DESC");
						$query = $db->prepare("select distinct Mov.movie_id, mov.photos, Mov.actor1, Mov.actor2,  case when rtrim(isnull(cs.title,'')) = '' then Mov.name else cs.title end as name, Mov.mpaa, Mov.advisory, Mov.runtime, case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as rel, Mov.reltxt, Mov.release2, Mov.reltxt2, Mov.release3, Mov.reltxt3,  case when rtrim(isnull(cs.url, '')) = '' then Mov.url else cs.url end as movieurl, Rev.movie_id, Rev.capsule, Rev.sid, cs.start_date, cs.end_date, cs.release, cs.title, cs.url, cs.cs_type FROM cinema..movies Mov WITH(NOLOCK) INNER JOIN websites..comingsoon cs WITH(NOLOCK) ON Mov.movie_id = cs.movie_id INNER JOIN cinema..reviews Rev WITH(NOLOCK) ON rev.movie_id = cs.movie_id WHERE cs.siteid = 161 and rev.sid = 'HOME' and CAST(case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as DateTime) > :date AND Mov.PARENT_ID = 0 order by rel, name");
						}elseif ($_GET['search'] == 'events'){
							$query = $db->prepare("SELECT distinct Screens.movie_id, name, mpaa, comment, release
FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) AND showdate> = :date
AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0 
and (Movies.genre ='Concert' or Movies.Genre = 'Program') 
ORDER BY release DESC");
							
							$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));		
											
						}elseif ($_GET['search'] == 'art'){
							$query = $db->prepare("SELECT distinct Screens.movie_id, name, mpaa, comment, release
FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) AND showdate >= :date
AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0 
and (Movies.genre ='%foreign%' or Movies.Genre = '%art%') 
ORDER BY release DESC");
							
						}else{
								$query = $db->prepare("select distinct Mov.movie_id, mov.photos, Mov.actor1, Mov.actor2,  case when rtrim(isnull(cs.title,'')) = '' then Mov.name else cs.title end as name, Mov.mpaa, Mov.advisory, Mov.runtime, case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as rel, Mov.reltxt, Mov.release2, Mov.reltxt2, Mov.release3, Mov.reltxt3,  case when rtrim(isnull(cs.url, '')) = '' then Mov.url else cs.url end as movieurl, Rev.movie_id, Rev.capsule, Rev.sid, cs.start_date, cs.end_date, cs.release, cs.title, cs.url, cs.cs_type FROM cinema..movies Mov WITH(NOLOCK) INNER JOIN websites..comingsoon cs WITH(NOLOCK) ON Mov.movie_id = cs.movie_id INNER JOIN cinema..reviews Rev WITH(NOLOCK) ON rev.movie_id = cs.movie_id WHERE cs.siteid = 161 and rev.sid = 'HOME' and CAST(case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as DateTime) > :date order by rel, name");
							
						}
						$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));
						$rows = $query->fetchAll();
						foreach($rows as $row) {
						
						$nsEvents .= "<a href='../movie_details.php?movie_id=" . $row['movie_id'] . "'><img src='" . getPoster($row['movie_id']) . "' alt='" . $row['name'] . "' title='" . $row['name'] . "'/></a>";
						
						}
						if ($nsEvents == ""){
							$nsEvents = "No titles available";	
						}
					    echo $nsEvents;
							
					    ?>
                      
						</div>
					</div>
					<div class="big-box round">
						<a href="../store/giftcards.php">
							<div class="button round">
								<p class="round">GIFT CARDS</p>
								<img src="../img/giftcards.jpg" />
								<img src="../img/giftcards_selected.jpg" />
							</div>
						</a>
						<a href="../movies/events.php">
							<div class="button round">
								<p class="round">EVENTS</p>
								<img src="../img/events.jpg" />
								<img src="../img/events_selected.jpg" />
							</div>
						</a>
						<a href="../technology/avx.php">
							<div class="button round">
								<p class="round">AVX</p>
								<img src="../img/avx.jpg" />
								<img src="../img/avx_selected.jpg" />
							</div>
						</a>
						<a href="../technology/dbox.php">
							<div class="button round">
								<p class="round">D-BOX</p>
								<img src="../img/dBox.jpg" />
								<img src="../img/dBox_selected.jpg" />
							</div>
						</a>
						<a href="../menu">
							<div class="button round">
								<p class="round">MENU</p>
								<img src="../img/menu.jpg" />
								<img src="../img/menu_selected.jpg" />
							</div>
						</a>
						<a href="">
							<div class="button round">
								<p class="round">Reserved Seats</p>
								<img src="../img/reservedseats.jpg" />
								<img src="../img/reservedseats_selected.jpg" />
							</div>
						</a>
						<a href="../mobile.php">
							<div class="button round">
								<p class="round">MOBILE</p>
								<img src="../img/mobile.jpg" />
								<img src="../img/mobile_selected.jpg" />
							</div>
						</a>
						<a href="../technology/imax.php">
							<div class="button round">
								<p class="round">IMAX</p>
								<img src="../img/imax.jpg" />
								<img src="../img/imax_selected.jpg" />
							</div>
						</a>
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