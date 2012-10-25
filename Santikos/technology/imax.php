<?php
	require_once '../db/db_conn.php';
	
	$ns = $movie_id = $house_id = "";
	
	// Cycle through each house and check for IMAX movies playing today
	foreach ($houses as $house) {
		$house_id = $house['house_id'];
		
		$query = $db->prepare("
			DECLARE @country varchar(50), @houseid int, @showdate datetime 
			SET @country = ''
			SET @houseid = :house_id
			SET @showdate = :date
			EXEC yhl_showtimes @country, @houseid, @showdate
		");
		$query->execute(array(':house_id' => $house_id, ':date' => date('Y-m-d', strtotime('today'))));
		$rows = $query->fetchAll();
		
		foreach($rows as $row) {
			// Check names for "IMAX"
			if (checkIMAX($row['name'])) {
				
				$movie_id = trimDecimals($row['movie_id']);
				
				$ns .= "
					<a href='../movie_details.php?movie_id=$movie_id'>
						<img src=' " . getPoster($movie_id) . "' />
						<p><b> " . getName($row['name']) . "</b> (" . trim($row['mpaa']) .  ")</p>
					</a>
				";
				break;
			}
		}
		
		// Break out of loop after a movie has been added
		if (strlen($ns) > 0) {
			break;
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
		<title>Santikos Theatres: IMAX</title>
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
					<div id="imax-is" class="small-box round center-img">
						<img src="../img/imaxIs.png" alt="IMAX Is Believing" />
						<p>
							The World's Most Immersive Movie Experience
						</p>
						<p>
							IMAX's state-of-the-art technology and architecture combine to create 
							experiences so real you'll forget you're in a theatre
						</p>
						<p>
							Experience it in IMAX
						</p>
                        
					</div>
					<div id="imax-ns" class="small-box round">
						<h2>NOW SHOWING</h2>
						<?php echo $ns; ?>
					</div>
				</div>
				<div id="right">
					<div id="imax-big" class="big-box round center-img">
						<img src="../img/imax3D.jpg" alt="IMAX 3D" />
                    </div>
                  
                        <table align="center">
                         <tr>
                            <td width="50%" class="small-box round" style="width:275px"><iframe width="275" height="155" src="http://www.youtube.com/embed/Kg6uVT1ewlA" frameborder="0" allowfullscreen></iframe></td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td width="50%" class="small-box round" style="width:275px;"><iframe width="275" height="155" src="http://www.youtube.com/embed/xXwzq9Hdb04" frameborder="0" allowfullscreen></iframe></td>
                        </tr>
                        </table>
                    
                    <div id="imax-big" class="big-box round center-img">    
						<h1>COMING SOON TO SANTIKOS IMAX LOCATIONS</h1>
                        
                        <?php
						// Cycle through each house and check for IMAX movies playing today
						$ns = "";
						foreach ($houses as $house) {
							$house_id = $house['house_id'];
							
							//echo $house_id;
							
							$query = $db->prepare("
								DECLARE @country varchar(50), @houseid int, @showdate datetime 
								SET @country = ''
								SET @houseid = :house_id
								SET @showdate = :date
								EXEC yhl_showtimes_future '', @houseid,  @showdate
							");
							$query->execute(array(':house_id' => $house_id, ':date' => date('m/d/Y', strtotime('today'))));
							$rows = $query->fetchAll();
							//echo " EXEC yhl_showtimes_future '', " . $house_id . ",  '" . date('m/d/Y', strtotime('today')) ."'";
							foreach($rows as $row) {
								// Check names for "IMAX"
								//echo $row['name'];
								if (checkIMAX($row['name'])) {
									//echo $row['name'];
									if (strpos($movie_id_list,$movie_id) !== false){
									//skip if movie in array already 
									}else
									{
									$movie_id = trimDecimals($row['movie_id']);									
									$ns .= "
										<a href='../movie_details.php?movie_id=$movie_id'>
											<img src=' " . getPoster($movie_id) . "' />
											<br/><b> " . getName($row['name']) . "</b> (" . trim($row['mpaa']) .  ")
										</a>
									";
									$movie_id_list .= $movie_id_array . " " . $movie_id;
									}
								}
							}
							
						}
						?>
                        <?php echo $ns; ?>
					</div>
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