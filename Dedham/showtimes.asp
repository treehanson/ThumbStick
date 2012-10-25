<!--#include file="includes/cs_subs.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Dedham Community Theatre</title>
    <link href="css/main.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/jquery.jwbox.js"></script>
    <script type='text/javascript' src='jwplayer59/swfobject.js'></script>
    <link rel="stylesheet" type="text/css" href="css/jwbox2.css" />
    <script type="text/javascript" src="jwplayer59/jwplayer.js"></script>

    <link rel="stylesheet" href="css/prettyPhoto.css" type="text/css" media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
	<script src="js/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	    $(document).ready(function () {
	        $("a[rel^='prettyPhoto']").prettyPhoto({ show_title: false, autoplay_slideshow: false, opacity: 0, theme: 'dark_square', social_tools: false });
	    });
    </script>
</head>
<body style="background-color:#000000;">
<% 
'
' Connect to the database for the entire page
'
ConnDB
strHouseID = 1624
'strHouseID = 6074
strSiteId = 109
' now playing small start
'response.write DateAdd("d", -Weekday(date())+1, date())
strDate = Request.Querystring("date")
if strDate = "" then
    strStartDate = DateAdd("d", -Weekday(date())+1, date())
    strEndDate = DateAdd("d", -Weekday(date())+7, date())
else
    strStartDate = DateAdd("d", -Weekday(strDate)+1, strDate)
    strEndDate = DateAdd("d", -Weekday(strDate)+7, strDate)
end if
%>
<div class="showtimes">
<div class="showtimes_left">

<div class="showtimes_week">Showtimes for the week of <%=strStartDate %> - <%=strEndDate %></div><div class="change_week"><%if strStartDate >  DateAdd("d", -Weekday(date())+1, date()) then%><a href="showtimes.asp?date=<%=DateAdd("d", -7,strStartDate) %>"><img src="images/leftchangeweek.gif" border="0" alt=""/></a><%else%><img src="images/placeholder.gif" border="0"><%end if %><img src="images/changeweek.gif" border="0" alt=""/><a href="showtimes.asp?date=<%=DateAdd("d", 7,strStartDate) %>"><img src="images/rightchangeweek.gif" id="rightchangeweek" border="0" alt=""/></a></div>
<img src="images/underline.gif" alt="" border="0" />
<% 

Function DisplayTimes(strmovieid)
    strOutput = ""
    k = 0 
    ReDim strTimes(7) 
    ReDim strDays(7) 

    for i = 1 to 7 
    strCurrentDate = DateAdd("d", -Weekday(strStartDate)+i,strStartDate)
    dayQuery = " select moviename=movies.name,movies.movie_id, screens.*,houses.state,houses.bargain " & _
             " from movies, screens, reviews, houses  " & _
             " where movies.movie_id = screens.movie_id and screens.house_id =  " & strHouseID & _
             " and screens.showdate=  '" & strCurrentDate & "'" & _
             " and movies.movie_id = " & strMovieID & _ 
             " and movies.movie_id *= reviews.movie_id  " & _
             " and screens.house_id = houses.house_id  " & _
             " and reviews.sid = 'HOME'  " & _
             " order by movies.movie_id "
             'Response.Write dayQuery
    iDay = DatePart("w", strCurrentDate)

    SELECT CASE iDay
    Case "1" strDayName = "Sun"
    Case "2" strDayName = "Mon"
    Case "3" strDayName = "Tues"
    Case "4" strDayName = "Wed"
    Case "5" strDayName = "Thurs"
    Case "6" strDayName = "Fri"
    Case "7" strDayName = "Sat"
    END SELECT

    'k = k + 1   
    'strDays(k) = strDayName
    set rsDays = cnnData.Execute(dayQuery)
        if not rsDays.eof then 
          k = k + 1         
          'response.write k 
          strDays(k) = strDayName
          for j = 1 to 24 
              if trim(rsDays.Fields("time"& j)) <> "" then 
                if j > 1 then
                    strTimes(k) = strTimes(k) & ", "                     
                end if    
                strTimes(k) = strTimes(k) & rsDays.Fields("time"&j)
              end if 
          next
          'strOutput = strOutput & "<div class='showtimes_nowplaying_text_bold'>" & strDays(k) & "</div>:&nbsp;" & strTimes(k) & "<br/>"
        end if         
    set rsDays = nothing  
    next

    'response.write k
    'go through days of week
    for m = 1 to 7
    if strTimes(m) <> "" Then 
        if m <= 6 then
        if strTimes(m) = strTimes(m+1) Then        
        'response.write strDays(m)
        'start A
            if m <= 5 then
            if strTimes(m) = strTimes(m+2) Then
            'start B
                if m <= 4 then
                if strTimes(m) = strTimes(m+3) Then
                'start C
                    if m <= 3 then
                    if strTimes(m) = strTimes(m+4) Then
                    'start D
                        if m <= 2 then
                        if strTimes(m) = strTimes(m+5) Then
                        'start E
                            if m <= 1 then
                            if strTimes(m) = strTimes(m+6) Then
                            'Start F
                            strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+6) & "</b>:&nbsp;" & strTimes(m) & "<br/>"
                            else
                            'Only Sunday - Friday Match  
                            strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+5) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                            'print Saturday
                            strOutput = strOutput & "<b>" & strDays(m+6) & "</b>:&nbsp;" & strTimes(m+6) & "<br/>"
                            'end F
                            end if 
                            else
                            'Only Sunday - Friday Match  
                            strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+5) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                            'print Saturday
                            strOutput = strOutput & "<b>" & strDays(m+6) & "</b>:&nbsp;" & strTimes(m+6) & "<br/>"
                            'end F
                            end if
                        else
                        'Only Sunday - Thursday Match
                        strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m + 4) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                        m = m + 4
                        'end E
                        end if
                        else
                        'Only Sunday - Thursday Match
                        strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m + 4) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                        m = m + 4
                        'end E
                        end if 
                    else
                    'Only Sunday - Wed. match
                    strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+3) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                    m = m + 3
                    'end D
                    end if
                    else
                    'Only Sunday - Wed. match
                    strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+3) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                    m = m + 3
                    'end D
                    end if
                else
                'Only Sunday - Tues. Match
                strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+2) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                'end C
                m = m + 2
                end if
                else
                'Only Sunday - Tues. Match
                strOutput = strOutput & "<b>" & strDays(m) & "-" & strDays(m+2) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
                'end C
                m = m + 2
                end if
            else
            'Only Sunday & Monday Match    
            strOutput = strOutput & "<b>" & strDays(m) & "&" & strDays(m+1) & "</b>:&nbsp;" & strTimes(m) & "<br/>"  
            m = m + 1
            'end B
            end if
            else
            'Only Sunday & Monday Match 
             strOutput = strOutput & "<b>" & strDays(m) & "&" & strDays(m+1) & "</b>:&nbsp;" & strTimes(m) & "<br/>" 
             m = m + 1
            end if 
        else
        'Only Sunday
        strOutput = strOutput & "<b>" & strDays(m) & "</b>:&nbsp;" & strTimes(m) & "<br/>"
        'End A
        end if
        else
        'Only Sunday
        strOutput = strOutput & "<b>" & strDays(m) & "</b>:&nbsp;" & strTimes(m) & "<br/>"
        'End A
        end if
    end if
    next
    strOutput = strOutput  & "<br/>"
    DisplayTimes = strOutput
End Function 
'check for next week showtimes
movieQuery = "select distinct moviename=movies.name,houses.state,movies.genre, houses.bargain, runtime, convert(int,movies.movie_id) as movie_id, movies.mpaa, isnull(movies.uktitle, '') as uktitle, isnull(movies.ukmpa, '') " & _
           " as ukmpa,  movies.photos, movies.hiphotos, movies.videos, reviews.capsule, " & _
           " actor1,actor2,actor3,actor4,actor5 " & _
           " from movies, screens, reviews, houses " & _
           " where movies.movie_id = screens.movie_id" & _
           " and screens.house_id = " & strHouseID  & _
           " and screens.showdate>=  '" & DateAdd("d",  7, strStartDate)  & "'" & _
           " and screens.showdate<=  '" & DateAdd("d",  7, strEndDate)  & "'" & _
           " and movies.movie_id *= reviews.movie_id " & _
           " and screens.house_id = houses.house_id " & _
           " and reviews.sid = 'HOME' " & _
           " order by movie_id"
           'Response.Write movieQuery
           
CheckSQL(movieQuery)
 
set rsMovie = cnnData.Execute(movieQuery)
'if no showtimes hide button
if rsMovie.eof then
%>
<script type="text/javascript">
    document.getElementById('rightchangeweek').src = "images/placeholder.gif";
</script>
<%
end if 

movieQuery = "select distinct moviename=movies.name,houses.state,movies.genre, houses.bargain, runtime, convert(int,movies.movie_id) as movie_id, movies.mpaa, isnull(movies.uktitle, '') as uktitle, isnull(movies.ukmpa, '') " & _
           " as ukmpa,  movies.photos, movies.hiphotos, movies.videos, reviews.capsule, " & _
           " actor1,actor2,actor3,actor4,actor5 " & _
           " from movies, screens, reviews, houses " & _
           " where movies.movie_id = screens.movie_id" & _
           " and screens.house_id = " & strHouseID  & _
           " and screens.showdate>=  '" & strStartDate  & "'" & _
           " and screens.showdate<=  '" & strEndDate  & "'" & _
           " and movies.movie_id *= reviews.movie_id " & _
           " and screens.house_id = houses.house_id " & _
           " and reviews.sid = 'HOME' " & _
           " order by movie_id"
           'Response.Write movieQuery
           
CheckSQL(movieQuery)
  
set rsMovie = cnnData.Execute(movieQuery)
do while not rsMovie.eof
    strRuntime = trim(rsMovie.Fields("runtime"))
%>
<div class="showtimes_nowplaying">
    <div class="showtimes_nowplaying_title">
    <%=MovieTitle(trim(rsMovie.Fields("moviename")))%> (<%=trim(rsMovie.Fields("mpaa"))%>)
    </div>
    <div class="showtimes_nowplaying_image">
        <a href="trailer.asp?title=<%=MovieTitle(trim(rsMovie.Fields("moviename")))%>&p=<%=right("000000" + ntrim(rsMovie.Fields("movie_id")),6)%>&m=<%=ntrim(rsMovie.Fields("movie_id"))%>&t=1&iframe=true&width=550&height=400" rel="prettyPhoto[iframes]"><img src="images/viewtrailer.png" class="playlarge" alt="play movie"/><img src="http://movienewsletters.net/photos/<%=right("000000" + ntrim(rsMovie.Fields("movie_id")),6)%>h3.jpg" alt="" name="" width="302" height="200" align="left" class="stilllarge" /></a>
    </div>
    <div class="showtimes_nowplaying_text">
        <%=DisplayTimes(rsMovie.Fields("movie_id")) %>
        <b><%=ucase(trim(rsMovie.Fields("genre")))%></b> - <%=trim(rsMovie.Fields("capsule"))%><br />
        <br />
        <b>STARRING</b> - <%=ActorNames(rsMovie)%>
    </div>
</div>
<% 
' now playing end

rsMovie.MoveNext
loop
set rsMovie = nothing
%>
</div>
<div class="showtimes_comingsoon">
<div style="height:35px;"><img src="images/comingsoon.gif" alt="" border="0"/></div>
<img src="images/underlineLittle.gif" alt="" border="0" />
<% 
ComingSoonQuery = " SELECT [Cinema].[dbo].[Movies].* " & _
               " FROM [Websites].[dbo].[ComingSoon], [Cinema].[dbo].[Movies] " & _
               " where [Websites].[dbo].[ComingSoon].[siteid]=  " & strSiteId & _
               " and [Cinema].[dbo].[Movies].[Movie_id] = [Websites].[dbo].[ComingSoon].[movie_id] "

CheckSQL(ComingSoonQuery)
set rsComingSoon = cnnData.Execute(ComingSoonQuery)
do while not rsComingSoon.eof
%>    
<div class="showtimes_comingsoon_block">
<img src="http://www.movienewsletters.net/photos/<%=right("000000" + ntrim(rsComingSoon.Fields("movie_id")),6)%>01.jpg" border="0" alt="<%=rsComingSoon.Fields("name") %>" class="showtimes_comingsoon_image" width="136" height="202" />
</div>
<% 
' now playing end

rsComingSoon.MoveNext
loop
set rsComingSoon = nothing
%>
</div>
</div>
<div class="showtimes_bottom">

</div>
</body>
</html>