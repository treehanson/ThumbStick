<?php
	require_once 'db/db_conn.php';
	
	// Get the house_id and date, else default to first house in array and today
	if (isset($_GET['house_id']) && isset($_GET['date'])) {
		$house_id = $_GET['house_id'];
		$date = date('Y-m-d', strtotime($_GET['date']));
	} else {
		$house_id = $houses[0]['house_id'];
		$date = date('Y-m-d', strtotime('today'));
	}
	
	try {
		
		$name = $address = $movies = "";
		
		// Get theatre details for address
		$query = $db->prepare("SELECT * FROM Houses WHERE house_id = :house_id");
		$query->execute(array(':house_id' => $house_id));
		$row = $query->fetch();
		
		$name = trim($row['name']);
		$address = trim($row['address1']) . "<br />" . trim($row['city']) . ", " . trim($row['state']) . " " . trim($row['zip']);
		
		// Get showtimes for this theatre and date
		$query = $db->prepare("
			SELECT Screens.movie_id, name, mpaa, comment, release, runtime, showdate, time1, time2, time3, time4, time5, time6, 
			time7, time8,time9, time10, time11, time12, time13, time14, time15, 
			time16, time17, time18, time19, time20, time21, time22, time23, time24,
			mer1, mer2, mer3, mer4, mer5, mer6, mer7, mer8, mer9, mer10, mer11, mer12, 
			mer13, mer14, mer15, mer16, mer17, mer18, mer19, mer20, mer21, mer22, mer23, mer24
			FROM Screens, Movies WHERE house_id = :house_id AND showdate = :date AND Screens.movie_id = Movies.movie_id
			ORDER BY release DESC
		");
		$query->execute(array(':house_id' => $house_id, ':date' => $date));
		$rows = $query->fetchAll();
		
		// Format movies and add to page
		foreach($rows as $row) {
			$times = "";
			$movie_id = trimDecimals($row['movie_id']);
			
			// Combine showtimes into one string
			for ($i = 1; $i < 25; $i++) {
				if (strlen(trim($row["time$i"])) > 0) {
					if ($i == 1) {
						$times .= trimTime($row["time$i"]) . getPeriod($row["mer$i"]);
					} else {
						$times .= ", " . trimTime($row["time$i"]) . getPeriod($row["mer$i"]);
					}
				}
			}	
	
			$movies .= "
				<div>
					<h2>" . getName($row['name']) . "</h2>
					<p><i>" . $row['mpaa'] . "</i> " . getRuntime($row['runtime']) . "</p>
					<p><strong>" . date('D', strtotime($date)) . ":</strong> $times</p>
				</div>
			";
		}
		
	} catch(PDOException $e) {
		
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
		<title></title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<style>
			body {
				font-family: sans-serif;
				font-size:12px;
			}
			header {
				margin: 0 0 20px 0;
			}
			img {
				float: left;
				height: 78px;
				margin: 0 20px 0 0;
			}
			div {
				margin: 0 0 12px;
			}
			h1 {
				margin: 0 0 0 0; 
			}
			h2 {
				font-size: 1.2em;
				margin: 0;
			}
			p {
				margin: 0 0 3px 0;
			}
			#print-button {
				width: 163px;
				margin: 25px 0 0 0;
			}
		</style>
		<script>
			function printPage() {
				window.print();
			}
		</script>
	</head>
	<body>
		<header>
			<img src="../img/logo.png" alt="Santikos Theatres" />
			<h1><?php echo $name; ?></h1>
			<p><b><?php echo $address; ?></b></p>
			<input id="print-button" type="button" value="Print" onClick="printPage()" />
		</header>
		<div>
			<?php echo $movies; ?>
		</div>
		<footer>
			
		</footer>
	</body>
</html>