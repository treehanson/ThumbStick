<?php
require_once '../db/db_conn.php';
	
	$count = 0;
	$col1 = "<div class='locations-col'>";
	$col2 = "<div class='locations-col'>";
	$col3 = "<div class='locations-col'>";
	
	$house_id = $movieShowtimes = $guestServices = $address = "";

	foreach ($houses as $house) {
		$count++;
		
		$house_id = $house['house_id'];
		
		$query = $db->prepare("SELECT * FROM Houses WITH(NOLOCK) WHERE house_id = :house_id");
		$query->execute(array(':house_id' => $house_id));
		$row = $query->fetch();
		
		$name = htmlentities(check($house['name']), ENT_QUOTES);
		if (check($row['movieline'])) {
			$movieShowtimes = "<p>Movie Showtimes: " . check($row['movieline']) . "</p>";
		}
		if (check($row['phone1'])) {
			$guestServices = "<p>Guest Services: " . check($row['phone1']) . "</p>";
		}
		if (check($row['numscreens'])) {
			$screens = "<p>Screens: " . check($row['numscreens']) . "</p>";
		}
		$address = trim($row['address1']) . "<br />" . trim($row['city']) . ", " . trim($row['state']) . " " . trim($row['zip']);
		$g_address = "http://maps.google.com?q=" . $name . ", " . trim($row['address1']) . ", " . trim($row['city']) . ", " . trim($row['state']) . ", " . trim($row['zip']);
		
		
		if ($count === 1) {
			$col1 .= "
				<div class='full-box location round'>
					<a href='../menu/menu.php?house_id=$house_id'>
						<img src='../img/theaters/$house_id.jpg' alt='$name' />
						<h1>$name</h1>
					</a>
					<p>$address</p>
					$movieShowtimes
					$guestServices
					$screens
					<a href='../menu/menuphp?house_id=$house_id'>View Menu</a>
					<a href='$g_address' target='_blank'>Map &amp; Directions</a>
				</div>
			";
		} else if ($count === 2) {
			$col2 .= "
				<div class='full-box location round'>
					<a href='../menu/menu.php?house_id=$house_id'>
						<img src='../img/theaters/$house_id.jpg' alt='$name' />
						<h1>$name</h1>
					</a>
					<p>$address</p>
					$movieShowtimes
					$guestServices
					$screens
					<a href='../menu/menu.php?house_id=$house_id'>View Menu</a>
					<a href='$g_address' target='_blank'>Map &amp; Directions</a>
				</div>
			";
		} else {
			$col3 .= "
				<div class='full-box location round'>
					<a href='../menu/menu.php?house_id=$house_id'>
						<img src='../img/theaters/$house_id.jpg' alt='$name' />
						<h1>$name</h1>
					</a>
					<p>$address</p>
					$movieShowtimes
					$guestServices
					$screens
					<a href='../menu/menu.php?house_id=$house_id'>View Menu</a>
					<a href='$g_address' target='_blank'>Map &amp; Directions</a>
				</div>
			";
			$count = 0;
		}
	}
	
	$col1 .= "</div>";
	$col2 .= "</div>";
	$col3 .= "</div>";
	
	$locations = $col1 . $col2 . $col3;

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
		<title></title>
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
				<?php echo $locations; ?>
				<div class="clearfix"></div>
			</div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<footer>
		</footer>
	</body>
</html>