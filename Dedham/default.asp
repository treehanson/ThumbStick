<!--#include file="includes/cs_subs.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Dedham Community Theatre</title>
    <link href="css/main.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="js/jquery.min.js"><\/script>')
    </script>
	

    <script type="text/javascript" src="js/jquery.jwbox.js"></script>
    <script type='text/javascript' src='jwplayer59/swfobject.js'></script>
    <link rel="stylesheet" type="text/css" href="css/jwbox2.css" />
    <script type="text/javascript" src="jwplayer59/jwplayer.js"></script>
    <script type="text/javascript">
        
        function changeSource(name) {
            document.getElementById('mainframe').src = name + ".asp";
        }

        //dan the man's function
        $(document).ready(function () {
            $('#navigation img').click(function () {
                $('.selected').attr('src', 'images/' + $('.selected').attr('id') + '.gif');
                $('.selected').removeAttr('class');

                $(this).attr('src', 'images/' + $(this).attr('id') + '_over.gif');
                $(this).attr('class', 'selected');

            });

            $('#navigation img').hover(
				function () {
				    $(this).attr('src', 'images/' + $(this).attr('id') + '_over.gif');
				},
				function () {
				    if ($(this).attr('class') != 'selected')
				        $(this).attr('src', 'images/' + $(this).attr('id') + '.gif');
				}
			);
        });

    </script>
    <link rel="stylesheet" href="css/prettyPhoto.css" type="text/css" media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
	<script src="js/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	    $(document).ready(function () {
	        $("a[rel^='prettyPhoto']").prettyPhoto({ show_title: false, autoplay_slideshow: false, opacity: 0, theme: 'dark_square', social_tools: false });
	    });
    </script>
</head>
<body class="default_body">
<div><img src="images/toparch.png" border="0" alt=""/></div>
<div><img src="images/leftcolumn.png" border="0" alt=""/><img src="images/dedham_community_theatre.jpg" border="0" alt=""/><img src="images/rightcolumn.png" border="0" alt=""/></div>
<div><img src="images/lights.gif" border="0" alt=""/></div>
<div id="navigation"><a href="#" onclick="changeSource('showtimes')"><img src="images/showtimes_over.gif" id="showtimes" border="0" alt=""/></a><a href="#" onclick="changeSource('specialevents')"><img src="images/events.gif" id="specialevents" border="0" alt=""/></a><a href="#" onclick="changeSource('rentalinfo')"><img src="images/rental.gif" id="rentalinfo" border="0" alt=""/></a><a href="#" onclick="changeSource('discounts')"><img src="images/discounts.gif" id="discounts" border="0" alt=""/></a><a href="#" onclick="changeSource('gallery')"><img src="images/gallery.gif" id="gallery" border="0" alt=""/></a><a href="#" onclick="changeSource('about')"><img src="images/about.gif" id="about" border="0" alt=""/></a> <br /><br /></div>
<div><img src="images/leftcolumn.png" border="0" alt=""/><iframe src="showtimes.asp" width="820" id="mainframe" height="539" frameborder="0" scrolling="auto"></iframe><img src="images/rightcolumn.png" border="0" alt=""/></div>

</body>
</html>