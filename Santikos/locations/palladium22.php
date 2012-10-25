<?php
require_once '../db/db_conn.php';
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
        <link rel="stylesheet" href="../js/nivo-slider/nivo-slider.css">
		<link rel="stylesheet" href="../js/nivo-slider/themes/default/default.css">
		<link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" href="../js/lightbox/source/jquery.fancybox.css?v=2.1" media="screen" />
        
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/libs/jquery-1.7.1.min.js"><\/script>')</script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
        <script type="text/javascript" src="../js/lightbox/source/jquery.fancybox.js?v=2.0.6"></script>
		<script src="../js/libs/modernizr-2.5.3.min.js"></script>
    <style type="text/css">
    .palladium22text {
	font-size: 10pt;
	padding-left:20px;
	padding-right:20px;
}
    </style>
	</head>
	<body>
		<div id="wrapper" class="round">
			<!-- header -->
			<?php require_once '../include/header.php'; ?>
			<!-- main -->
			<div role="main">
            <div align="center">
            <table width="925px" border="0" align="center" cellpadding="10" cellspacing="5px" class="spread-box round"> 
              <tr>
                <td align="center"><img src="palladium/palladiumtopper.png" width="975" height="158"></td>
                </tr>
              <tr>
              	<td><iframe width="275" height="155" src="http://www.youtube.com/embed/Cc8f1Xep8Oc" frameborder="0" allowfullscreen></iframe></td>
              </tr>
              <tr>
                <td align="center">
                <span class="spread-box round center-img">
               <p align="center"> <br />
              <strong>The Santikos Palladium entertainment complex is coming soon </strong><br />
              <strong>to Houston and Fort Bend County</strong></p>
               <p align="center">&nbsp;</p>
             <p class="palladium22text"> Santikos Theatres is excited about the upcoming opening of the Santikos Palladium on Highway 99, the Grand Parkway, at W. Bellfort Street.  The Palladium will be the premiere entertainment destination for all of Houston and Fort Bend County.  The Palladium will feature 22 luxurious stadium style theatres, several restaurants, 16 lanes of bowling, bars, gelato, frozen yogurt, a VIP seating area with in theatre dining service and more.  The theatre will feature both new Hollywood releases and limited art/independent films for its guests.  The company is also proud to announce that every auditorium will feature its own AVX projection.  AVX is the Ultimate Audio Visual Experience and boasts oversized, floor to ceiling and wall to wall screens, 4K digital projection for a bright, vibrant picture and the newest state of the art digital sound system, Dolby ATMOS. Six of the AVX auditoriums will offer massive screens that measure over 80 feet wide. These enormous screens will be among the largest movie screens in Texas and will be comparable to IMAX presentations.  These massive AVX auditoriums will certainly become a top choice for discerning moviegoers wanting to see the newest blockbuster films on some of the biggest movie screens in Houston.</p>
 <p>&nbsp;</p>
 <p class="palladium22text"> 
  There will be many different food and dining options to satisfy everyone&rsquo;s tastes.  The concession stand will offer freshly popped popcorn, candy and also feature over 100 different drink choices with the very popular Coca Cola Freestyle machines.  Guests can also choose from sushi, sandwiches, salads, pizza, gyros, tacos, shish kabobs, gelato and more at the different cafes.  All of these items can be taken into the theatre to enjoy.  In theatre dining service will be available in the reserved VIP seating areas and art theatres.  The VIP seating areas are exclusively for guests 18 years and older.  A server will take care of the guest&rsquo;s food and drink needs while they sit and enjoy a film on one of the giant screens.  The mezzanine will feature multiple bars and freshly prepared sushi and pizza, so that guests can enjoy the big game on one of the many flat screen TVs, relax in the sports lounge overlooking the bowling lanes or share a quiet moment on the front balcony. </p>
 <p>&nbsp;</p>
 <p class="palladium22text"> 
  The complex will also feature 16 lanes of bowling, allowing guests to visit for more than just a movie.  The bowling lanes will make an ideal place to meet, have a party, host a meeting or just have some fun with friends. </p>
 <p class="palladium22text">&nbsp;</p>
 <p class="palladium22text">
  The company is proud of its 101 year history of providing the magic of the movies and its legendary Santikos brand of service to South Texas. Every detail of this new theatre has been selected to deliver the greatest experience possible for all of its guests.  It will certainly be the grandest theatre that Santikos has ever built. An exact opening date has not yet been set, but the company hopes to open near the end of this year.  A massive grand opening celebration is planned and we want to welcome everyone to the premiere entertainment destination in Houston.
 <p />
    </span>
    </td>
    </tr>
    <tr>
    <td>
    	<center>
        <div class="big-box round" style="padding-bottom: 0">
            <div class="slider-wrapper theme-default">
                <div id="slider" class="nivoSlider">
                <?php
                $query = $db->prepare("select * from websites.dbo.carousel where SiteID = 161 and category like '%palladium22%' order by sort");
                $query->execute();
                $rows = $query->fetchAll();
                // Load up carousel images
                foreach($rows as $row) {
                    $ns_carousel[trim($row['carouselID'])] = $row;
					//echo $ns_carousel[trim($row['carouselID'])];
                }
                foreach ($ns_carousel as $key => $value) {
                $nsC .= "<a href='" . htmlentities(getName($value['URL'])) ."'>";
                $nsC .= "<img src='http://www.filmsxpress.com/images/Carousel/161/" . htmlentities(getName($value['largeImage'])) . "' " ; 
                if ($value['imageTXT'] != "")
                {
                $nsC .= " alt='" . htmlentities(getName($value['imageTXT']), ENT_QUOTES) . "' title='"; 
                $nsC .= htmlentities(getName($value['imageTXT']), ENT_QUOTES);
                }
                $nsC .= "' /></a>";
                
                }
                echo $nsC;
                ?>
                </div>
            </div>
        </div>
       </center> 
    </td>
    </tr>
      <!--<p><strong style="font-size:9pt;">One of the six large auditorium featuring our AVX projection, 80 foot screen and also introducing our VIP seating area in the back of the auditorium with in theatre service. </strong><strong> <br>
        <img src="palladium/mock2.png" width="600" ></strong></p>  -->
  
</table>

		  </div>
		</div>
		<!-- footer -->
		<?php require_once '../include/footer.php'; ?>
		<footer>
		</footer>
       	<script src="../js/nivo-slider/jquery.nivo.slider.pack.js"></script>
		<script type="text/javascript">
			$(window).load(function() {
			    $('#slider').nivoSlider();
			});
		</script>
	</body>
</html>