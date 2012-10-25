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
                	<?php                  
					if (($_GET['search'] == '') or ($_GET['search'] == 'showall')){
						$style = "style='background-color: #891200;color: #eee;'";
					}else{
						$style = "";
					}
					?>
                    	<a href="movies.php?search=showall" class="round" <?php echo $style ?>>SHOW ALL</a>
                    <?php                  
					if ($_GET['search'] == 'nowplaying'){
						$style = "style='background-color: #891200;color: #eee;'";
					}else{
						$style = "";
					}
					?>
                    	<a href="movies.php?search=nowplaying" class="round" <?php echo $style ?>>NOW PLAYING</a>    
                     <?php                  
					if ($_GET['search'] == 'comingsoon'){
						$style = "style='background-color: #891200;color: #eee;'";
					}else{
						$style = "";
					}
					?> 
                        <a href="movies.php?search=comingsoon" class="round"  <?php echo $style ?>>COMING SOON</a>
                    <?php                  
					if ($_GET['search'] == 'events'){
						$style = "style='background-color: #891200;color: #eee;'";
					}else{
						$style = "";
					}
					?>    
                        <a href="movies.php?search=events" class="round" <?php echo $style ?>>CONCERTS &amp; EVENTS</a>
                        
                    <?php                  
					if ($_GET['search'] == 'art'){
						$style = "style='background-color: #891200;color: #eee;'";
					}else{
						$style = "";
					}
					?>    
                        <a href="movies.php?search=art" class="round" <?php echo $style ?>>ART &amp; INDEPENDENT</a>
                    </div>
                	<div class="separate center">
				<?php                  
				// Loop through each house and find the coming soon data
					if ($_GET['search'] == 'nowplaying'){
						$query = $db->prepare("select distinct movies.*, screens.movie_id as movie_id, reviews.capsule
from movies WITH(NOLOCK), houses WITH(NOLOCK), screens WITH(NOLOCK), reviews with(NOLOCK)
where movies.movie_id = screens.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and screens.house_id = houses.house_id and screens.showdate = :date and houses.chain_id =1058 and movies.parent_id =0 and reviews.sid='HOME' order by movies.release desc, movies.name");
						$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));
						}elseif ($_GET['search'] == 'comingsoon'){
								
						$query = $db->prepare("select distinct Mov.movie_id, mov.photos, Mov.actor1, Mov.actor2,  case when rtrim(isnull(cs.title,'')) = '' then Mov.name else cs.title end as name, Mov.mpaa, Mov.advisory, Mov.runtime, case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as rel, Mov.reltxt, Mov.release2, Mov.reltxt2, Mov.release3, Mov.reltxt3,  case when rtrim(isnull(cs.url, '')) = '' then Mov.url else cs.url end as movieurl, Rev.movie_id, Rev.capsule, Rev.sid, cs.start_date, cs.end_date, cs.release, cs.title, cs.url, cs.cs_type FROM cinema..movies Mov WITH(NOLOCK) INNER JOIN websites..comingsoon cs WITH(NOLOCK) ON Mov.movie_id = cs.movie_id INNER JOIN cinema..reviews Rev WITH(NOLOCK) ON rev.movie_id = cs.movie_id WHERE cs.siteid = 161 and rev.sid = 'HOME' and CAST(case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as DateTime) >  :date AND Mov.PARENT_ID = 0 order by rel, name");
						$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));
						}elseif ($_GET['search'] == 'events'){
							$query = $db->prepare("SELECT distinct Screens.movie_id, name, mpaa, release
FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) AND showdate> = :date
AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0 
and (Movies.genre ='Concert' or Movies.Genre = 'Program') 
ORDER BY release DESC");
							
							//$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));		
						$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));					
						}elseif ($_GET['search'] == 'art'){
							$query = $db->prepare("SELECT distinct Screens.movie_id, movies.videos,name, mpaa, release
FROM Screens WITH(NOLOCK), Movies WITH(NOLOCK), Reviews WITH(NOLOCK) WHERE ((house_id = 9826) or (house_id = 10367) or (house_id = 10792) or (house_id = 20453) or (house_id = 20454) or (house_id = 20455) or (house_id = 20456) or (house_id = 20457)) AND showdate >= :date
AND Screens.movie_id = Movies.movie_id AND MOVIES.MOVIE_ID *= REVIEWS.MOVIE_ID and REVIEWS.SID='home' AND MOVIES.PARENT_ID = 0 
and  reltxt NOT LIKE '%NATIONWIDE%' and Movies.genre <> 'Concert' and Movies.Genre <> 'Program' 
ORDER BY release DESC");
						$query->execute(array(':date' => date('Y-m-d', strtotime('today'))));	
						}else{
								$query = $db->prepare("select distinct Mov.movie_id, mov.photos, Mov.actor1, Mov.actor2,  case when rtrim(isnull(cs.title,'')) = '' then Mov.name else cs.title end as name, Mov.mpaa, Mov.advisory, Mov.runtime, case when rtrim(isnull(cs.release,'')) = '' then Mov.release else cs.release end as rel, Mov.reltxt, Mov.release2, Mov.reltxt2, Mov.release3, Mov.reltxt3,  case when rtrim(isnull(cs.url, '')) = '' then Mov.url else cs.url end as movieurl, Rev.movie_id, Rev.capsule, Rev.sid, cs.start_date, cs.end_date, cs.release, cs.title, cs.url, cs.cs_type FROM cinema..movies Mov WITH(NOLOCK) INNER JOIN websites..comingsoon cs WITH(NOLOCK) ON Mov.movie_id = cs.movie_id INNER JOIN cinema..reviews Rev WITH(NOLOCK) ON rev.movie_id = cs.movie_id WHERE cs.siteid = 161 and rev.sid = 'HOME'  order by rel DESC, name");
						$query->execute();
						}
						
						$rows = $query->fetchAll();
						// Load up movies for all theatres into array, using movie_id as key so array is unique
						foreach($rows as $row) {
						
				// Loop through each movie and add poster to Now Showing section
					
						$ns .= "<div class='smallPlus-box round left'>";
						$ns .= "<a href='../movie_details.php?movie_id= " . $row['movie_id'] . "'  class='redUpper left'>" . htmlentities(getName($row['name']), ENT_QUOTES) . "<br>";
						$ns .= "<a href='../movie_details.php?movie_id=" . $row['movie_id'] . "'><img src='" . getPoster($row['movie_id']) . "' class='listImages separate' alt='" . htmlentities(getName($row['name']), ENT_QUOTES) . "' title='" . htmlentities(getName($row['name']), ENT_QUOTES) . "'  /></a>";
						// tree: added str_replacer code to db/db_conn.php TREE TEST
						$ns .= "<div class='textPart separate'>" . str_replacer(htmlentities(getName($row['capsule']), ENT_QUOTES),200,$row['movie_id']) ;
						$ns .= "<br><br>";
						$ns .= "<table>";
						$ns .= "<tr>";
						$ns .= "<td>";
						if ($row['videos']){
						$ns .= "<div class='whiteButton round center'><a href=\"../trailer.php?title=" . htmlentities(getName($row['name']), ENT_QUOTES) . "&p=".$row['movie_id']."y&m=".$row['movie_id']."&t=1&iframe=true&width=600&height=400\" class='various redUpperSml'  data-fancybox-type='iframe' target='_parent'>Trailer</a></div>";
						}
						$ns .= "</td>";
						$ns .= "<td>";
						$ns .= "<div class='whiteButton round center'><a href='../movie_details.php?movie_id=".$row['movie_id']."' class='redUpperSml'>Details</a></div>";
						$ns .= "</td>";
						$ns .= "</tr>";
						//$ns .= "<tr>";
//						$ns .= "<td colspan=2>";
//						$ns .= "<div class='whiteButton whiteButtonLong round center'><a href='http://santikos.cinema-source.com/locations/' class='redUpperSml'>Choose Theatre</a></div>";
//						$ns .= "</td>";
//						$ns .= "</tr>";
						$ns .= "</table>";
						
						$ns .= "</div>";
						$ns .= "</div>";
					}
					if ($ns == ""){
							$ns = "<span style='color:white'>No titles available</span>";	
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