<?php
require_once "../db/db_conn.php";

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
		<title>Santikos Theatres: D-BOX</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
	<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
        
    <style type="text/css">
    a               {
	text-decoration: none;
}
    </style>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
            <div id="left">
					<div id="imax-is" class="small-box round center-img">
						<img src="../img/dboxlogo.png" alt="IMAX Is Believing" />
						<p>
                        D-BOX adds a new dimension to your movie experience.  It allows moviegoers to Live the Action on screen with unmatched realism.  The D-BOX Motion Code&trade; system creates movements: pitch, roll, heave and intelligent vibrations-perfectly synchronized with the onscreen action.

                        </p>
					</div>
					<div id="dbox-ns" class="small-box round">
						<h2>NOW SHOWING</h2>
						<a href="<?php echo $dbox['url']; ?>" class="now-playing">
							<img src="<?php echo $dbox['poster'] ?>" />
							<p><b><?php echo  $dbox['name']; ?></b> (<?php echo $dbox['mpaa']; ?>)</p>
						</a>
					</div>
                    <div class="small-box round center">
						<p>Look for</p>
						<h1>D-BOX</h1>
						<p>Next to the film title on our showtimes page</p>
					</div>
				</div>
				<div id="right">
					<div id="imax-big" class="big-box round center-img">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" class="stdtable" style="background-image: url(../img/background_DBOX2.jpg);font-size:10px;color:white;">
          <tr>
            <td><img src="images/spacer.gif" width="1" height="14" /></td>
          </tr>
          <tr>
            <td class="pageheading"><br><img src="../img/logo_DBOX.png" width="280"/></td>
          </tr>
          <tr width="587">
            <td class="textmedium">
         
				<table width="585" border="0" align="center" cellpadding="0" cellspacing="0" class="stdtable" id="table1">
                <tr>
                	<td width="376"><object width="365" height="200" style="height:200px; width: 365px"><param name="movie" value="http://www.youtube.com/v/KAwdsb9i5ng?version=3&amp;feature=player_embedded"><param name="allowFullScreen" value="true"><param name="allowScriptAccess" value="always">
                	  <param name="autoplay" value="true" />
                	  <embed src="http://www.youtube.com/v/KAwdsb9i5ng?version=3&feature=player_embedded" width="350" type="application/x-shockwave-flash" style="padding-left:8px; padding-right:8px; padding-bottom:8px" height="200" allowfullscreen="true" allowScriptAccess="always" autoplay="1" movie="http://www.youtube.com/v/KAwdsb9i5ng?version=3&amp;feature=player_embedded"></object></td>
                    <td width="209" style="vertical-align:text-top" ><img src="../img/logo_DBOX_MFX.png" width="201" height="93" />
                    <br /><br />After sound and image, D-BOX adds<br />magic to movies with MFX.
                    <br /><br />Moviegoers will be immersed in an<br />unmatched, realistic experience, right in <br />their seats.</td>
                </tr>
                
                <tr>
                	<td colspan="2">
                        <table width="587" cellpadding="8">
                        <tr>
                            <td align="left" width="50%">NOW<br /><span style="font-size:28px">SHOWING</span></td>
                            <td align="left" width="50%">COMING<br /><span style="font-size:28px">SOON</span></td>
                        </tr>
                        <tr>
                            <td width="50%" ><iframe width="275" height="155" src="http://www.youtube.com/embed/JqqgrUna28w" frameborder="0" allowfullscreen></iframe></td>
                            <td width="50%"><iframe width="275" height="155" src="http://www.youtube.com/embed/H1yR-gEldC4" frameborder="0" allowfullscreen></iframe></td>
                        </tr>
                        <tr>
                            <td align="left" width="50%" style="font-size:14px"><em>Dredd 3D</em></td>
                            <td align="left" width="50%" style="font-size:14px"><em>Frankenweenie</em></td>
                        </tr>
                        
                        <!-- IF THERE ARE NO COMING SOONS, COMMENT OUT THIS ENTIRE SECTION -->                        <!-- END COMING SOON -->
                        
                        </table>
                    </td>
                </tr>
                <tr>
                  	<td colspan="2" align="center">
                        <table width="575" style="border-width:3px; border-color:#999999; border-style:solid;color:white;font-size:10px;" cellpadding="2">
                        <tr>
                        	<td colspan="4" style="padding-left:30px; padding-top:15px"><img src="../img/dbox_Reserve.png" width="396" height="31" /><br /><br /></td>
                        </tr>
                        <?php
						// Select house details from database
						
						foreach ($houses as $house) {
						$house_id = $house["house_id"];
						$query = $db->prepare("SELECT * FROM Houses WITH(NOLOCK) WHERE house_id = :house_id");
						$query->execute(array(":house_id" => $house_id));
						$house = $query->fetch();
						$name = $house['name'];
						
						if (($house_id !== "20455") & ($house_id !== "20453") & ($house_id !== "9826") & ($house_id !== "20454") & ($house_id !== "29811")) {
						// Create address and Google Maps URL
						//$address = trim($house['address1']) . "<br />" . trim($house['city']) . ", " . trim($house['state']) . " " . trim($house['zip']);
						$address = trim($house['city']) . ", " . trim($house['state']);
						$g_maps = "http://maps.google.com?q=" . trim($house['name']) . ", " . trim($house['address1']) . ", " . trim($house['city']) . ", " . trim($house['state']) . ", " . trim($house['zip']);
						?>
						
                        <tr>
                            <td width="50%" height="21" style="padding-left:30px; font-size:13px; font-weight:bold; vertical-align:text-top" align="left"><a href="../locations/theatre.php?house_id=<?php echo $house_id ?>"><span style="color:#C60; text-decoration:none"><?php echo $name?></span></a></td>
                            <td width="22%" class="text"><?php echo $address ?></td>
                            <td width="18%"><em class="text"><?php echo trim($house['movieline']) ?></em></td>
                            <td width="10%" style="font-size:11px; font-weight:bold; vertical-align:text-top"><a href="<?php echo $g_maps ?>" target="_new"><span style="color:#C60;">Map ></span></a></td>
                        </tr>
                       <?php }
					   
					   } ?>
                        </table>
                   	</td>
                </tr>
                <tr>
                    <td colspan="2"><img src="../img/dbox_MoreInfo.png" name="dbox" width="231" height="39" border="0" align="right" usemap="#sociallinks" id="dbox" style="padding-right:10px; padding-top:8px; padding-bottom:8px"/></td>
                </tr>
                <tr>
                    <td colspan="2" cellpadding="0"><img src="../img/dbox_Pilot2.png" border="0" align="left" width="600" /></td>
                </tr>
                
              </table>
             </td>
          </tr>
          <tr>
            <td></td>
          </tr>
          
        </table>

						<!--<h1>COMING SOON TO SANTIKOS D-BOX LOCATIONS</h1>-->
                        
                       <!-- //?php
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
								if (checkDBOX($row['name'])) {
									//echo $row['name'];
									if (strpos($movie_id_list,$movie_id) !== false){
									//skip
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
						?>-->
                        <?php //echo $ns; ?>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
			</div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<footer>
		</footer>
	</body>
</html>