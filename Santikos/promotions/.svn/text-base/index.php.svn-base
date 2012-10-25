<?php
require_once "../db/db_conn.php";
$promotion = $movie_id = $capsule = $moviename = $title = $text = $query = $rows = $row = "";


if (isset($_GET['promotion'])) {	
	$promotion = $_GET['promotion'];
	if ($promotion == "kidtoons"){
		$title = "Kidtoons";
		$text = "<p><div align='center'><strong>FAMILY MOVIES AT SANTIKOS THEATRES</strong></div>";
        $text .= "  <br> Kidtoons is exclusively at the</p>";
		$text .= "<p>- Silverado San Antonio <br>";
        $text .= " - Houston Silverado IMAX<br>";
        $text .= " every <strong>Saturday</strong> and <strong>Sunday</strong> at <strong>11AM</strong><br>";
        $text .= " Tickets are <strong>$2 per show</strong></p>";
	}
	if ($promotion == "freemovie"){
		$title = "Free Movies";
	}
	if ($promotion == "mommy"){
		$title = "Mommy Matinees";
	}
	if ($promotion == "evasheroes"){
		$title = "Eva's Heroes";
	}
	if ($promotion == "mikeysplace"){
		$title = "Mikey's Place";
	}
}


$query = $db2->prepare("select movie_id from comingsoon where csid in (select csid from sitechoiceselection where choiceid in (select choiceid from sitechoices where siteId = 161 and choice= :promotion))");
$query->execute(array(':promotion' => $promotion));
$row = $query->fetch();
$movie_id = $row['movie_id'];
echo $movie_id;



$query = $db->prepare("select * from movies, reviews where reviews.movie_id = movies.movie_id and movies.movie_id = :movie_id and reviews.sid ='HOME'");
$query->execute(array(':movie_id' => $movie_id));
$rows = $query->fetch();
// Load up movies for all theatres into array, using movie_id as key so array is unique
$capsule = $rows['capsule'];
$moviename = $rows['name'];
			
echo $moviename;			
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
		<title>Santikos Theatres: Kidtoons</title>
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
           <div align="center">
            <table width="925px" border="0" align="center" cellspacing="5px" class="spread-box round">
              <tbody>
              <tr>
                <td width="369" align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="center"><h1><?php echo $title ?></h1></td>
                  </tr>
                  <tr>
                    <td>
                    <?php echo $text ?>
                 </td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table></td>
                <td width="567" align="center">
        
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="center">&nbsp;</td>
              </tr>
            </table>
        </td></tr>
        
        <tr><td>
        
        <!-- START CONTENT -->
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  
  <td width="29%" valign="top" class="postercell">
              	<a href="movie_details.asp?movie_id=<?php echo $movie_id ?>" target="_parent"><img src="http://www.movienewsletters.net/photos/<?php echo $movie_id ?>H1.jpg" width="150" /></a>
              </td>
  
  
    <td width="71%"><strong><?php echo $moviename ?></strong><br>
        <br>
        <?php echo $capsule ?><br>
        <br>
        <br>
        <br>
        <?php
        foreach ($houses as $house) {
			$house_id = $house['house_id'];
			$name = $house['name'];
			$query = $db->prepare("SELECT distinct houses.* FROM SCREENS, HOUSES WITH(NOLOCK) WHERE screens.house_id = :house_id and screens.movie_id= :movie_id and screens.house_id = houses.house_id");
			$query->execute(array(':house_id' => $house_id, ':movie_id' => $movie_id));
			$rows = $query->fetchAll();
			// Load up movies for all theatres into array, using movie_id as key so array is unique
			foreach($rows as $row) {
		?>	
			
        <p><a href="../locations/theatre.php?house_id=<?php echo $house_id ?>" target="_parent">Playing at <?php echo ucwords(strtolower($name)) ?></a><br>

		<?php 
			}
		}
		?>
                </td>
                  </tr>
                </table>   
                        
        <!-- END CONTENT -->
        
        
        </td>
      </tr>
    </table>
    
    
    
    
    </td>
  </tr>
  
  
  
  
  
    <tr>
      <td colspan="3" align="center" valign="top"><p>&nbsp;</p>
        <hr></td>
    </tr>
  </tbody>
</table>
</div>

		  </div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<footer>
		</footer>
	</body>
</html>