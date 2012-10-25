<?php
require_once "../db/db_conn.php";

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
		<title>Santikos Theatres: Movies</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="../css/style.css">
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="../js/libs/jquery-1.7.1.min.js"><\/script>')</script>
        <!-- Add fancyBox main JS and CSS files -->
        <script type="text/javascript" src="../fancybox/source/jquery.fancybox.js?v=2.0.6"></script>
        <link rel="stylesheet"  type="text/css" href="../fancybox/source/jquery.fancybox.css?v=2.0.6" media="screen" />
        <script>
        $(document).ready(function() {
            $(".various").fancybox({
              maxWidth	: 640,
            maxHeight	: 440,
            width		: '70%',
            height		: '70%',
            fitToView	: false,
            autoSize	: false,
            closeClick	: false,
            openEffect	: 'none',
            closeEffect	: 'none'
            });
        });
        
        </script>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
            	<div class="black-box round center">
                    <div class="center"  id="scroller-nav">
                        <a href="movies.php?search=nowplaying" class="round">NOW PLAYING</a>
                        <a href="movies.php?search=comingsoon" class="round">COMING SOON</a>
                        <a href="movies.php?search=events" class="round">CONCERTS &amp; EVENTS</a>
                        <a href="movies.php?search=art" class="round">ART &amp; INDEPENDENT</a>
                    </div>
                	<div class="separate center">
				<?php                  
				// Loop through each house and find the coming soon data
					foreach ($houses as $house) {
						$house_id = $house['house_id'];
						
						$query = $db->prepare("
							SELECT Screens.movie_id, name, mpaa, comment, release, showdate, reviews.* 
							FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE house_id = :house_id AND showdate = :date AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0
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
						$ns .= "<div class='smallPlus-box round left'>";
						$ns .= "<a href='../movie_details.php?movie_id=$key' class='redUpper left'>" . htmlentities(getName($value['name']), ENT_QUOTES) . "<br>";
						$ns .= "<a href='../movie_details.php?movie_id=$key'><img src='" . getPoster($key) . "' class='listImages separate' alt='" . htmlentities(getName($value['name']), ENT_QUOTES) . "' title='" . htmlentities(getName($value['name']), ENT_QUOTES) . "' /></a>";
						// tree: added str_replacer code to db/db_conn.php
						$ns .= "<div class='textPart separate'>" . str_replacer(htmlentities(getName($value['capsule']), ENT_QUOTES),200,$key) ;
						//$ns .= "<div class='whiteButton round center '><a href='../movie_details.php?movie_id=$key'  rel='lightbox'  class='redUpperSml'>Trailer</a></div>";
						$ns .= "<table>";
						$ns .= "<tr>";
						$ns .= "<td>";
						$ns .= "<div class='whiteButton round center'><a href=\"../trailer.php?title=" . htmlentities(getName($value['name']), ENT_QUOTES) . "&p=$key&m=$key&t=1&iframe=true&width=600&height=400\" class='various redUpperSml'  data-fancybox-type='iframe' target='_parent'>Trailer</a></div>";
						$ns .= "</td>";
						$ns .= "<td>";
						$ns .= "<div class='whiteButton round center'><a href='../movie_details.php?movie_id=$key' class='redUpperSml'>Details</a></div>";
						$ns .= "</td>";
						$ns .= "</tr>";
						//$ns .= "<tr>";
						//$ns .= "<td colspan=2>";
						//$ns .= "<div class='whiteButton whiteButtonLong round center'><a href='http://santikos.cinema-source.com/locations/' class='redUpperSml'>Choose Theatre</a></div>";
						//$ns .= "</td>";
						//$ns .= "</tr>";
						$ns .= "</table>";
						$ns .= "</div>";
						$ns .= "</div>";
					}	

                        echo $ns; 
                    
                ?>              	
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