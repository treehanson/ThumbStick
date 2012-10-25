﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dreamland.aspx.cs" Inherits="Dreamland.dreamland" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Styles/dreamland.css" rel="stylesheet" type="text/css" /> 
    <script type="text/javascript" src="Scripts/swfobject.js"></script>
    <script language="javascript" src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="Scripts/jquery.easing.1.3.js"></script>
     <script type="text/javascript">
         function setdate(val) {
             hidediv('popdates');
             event.stop;
         }
    </script>
       <!-- styles needed by jScrollPane -->
    <link type="text/css" href="styles/jquery.jscrollpane.css" rel="stylesheet" media="all" />
    <!-- the mousewheel plugin - optional to provide mousewheel support -->
    <script type="text/javascript" src="scripts/jquery.mousewheel.js"></script>
    <!-- the jScrollPane script -->
    <script type="text/javascript" src="scripts/jquery.jscrollpane.min.js"></script>

    <script type="text/javascript">
        $(function () {
            $('.scroll-pane').jScrollPane();
            $('.scroll-pane').jScrollPane({ showArrows: true });
        });

    </script>
    <script type="text/javascript">
        function padLeft(movie) 
        {
            if (movie.length == 5) {
                return "0" + movie;
            } else {
            return movie;
            }
        }
        function changeLorax(source, movie_id, moviename) {
            document.getElementById('hdnMovieFld').value = movie_id;
            document.getElementById('largeStill').src = source;
            document.getElementById('lblTitleMovie').innerHTML = moviename;
//            oHttp = window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
//            oHttp.open("GET", source, false);
//            oHttp.send();
//            if (oHttp.status == 200)
//                document.getElementById('largeStill').src = source;
//            else
//                document.getElementById('largeStill').src = "http://www.movienewsletters.net/photos/000000H2.jpg";
            //alert(oHttp.status);
            
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:Label ID="lblHouseid" runat="server" Visible="false" Text="Label"></asp:Label>
    <asp:Label ID="lblShowdate" runat="server" Visible="false" Text="Label"></asp:Label>
    <asp:Label ID="lblMovieId" runat="server" Visible="false" Text="Label"></asp:Label>
    <asp:Label ID="lblTest" runat="server" Visible="false" Text="Label"></asp:Label>
    <asp:HiddenField ID="hdnMovieFld" runat="server" />
    <div class="background">
        <div class="header">
            <div class="header_left"><asp:Label ID="lblTitleMovie" runat="server" Width="400" Text="Label"></asp:Label></div>
            <div class="header_right">
                <div class="showtimes">Showtimes<br /><div id="date"><asp:Label ID="lblDate" runat="server" Text="Label"></asp:Label></div></div>                
                <div runat="server" id="currentdate" class="currentdate"><asp:LinkButton ID="btnDate2a" OnClick="changeDate" CssClass="nodecoration" runat="server"></asp:LinkButton><br /><div id="date1"><asp:LinkButton CssClass="nodecoration" ID="btnDate2b" OnClick="changeDate" runat="server"></asp:LinkButton></div></div>
                <div runat="server" id="day1" class="date"><asp:LinkButton ID="btnDate3a" OnClick="changeDate1" CssClass="nodecoration" runat="server"></asp:LinkButton><br /><div id="date2"><asp:LinkButton CssClass="nodecoration" ID="btnDate3b" OnClick="changeDate1" runat="server"></asp:LinkButton></div></div>
                <div runat="server" id="day2" class="date"><asp:LinkButton ID="btnDate4a" OnClick="changeDate2" CssClass="nodecoration" runat="server"></asp:LinkButton><br /><div id="date3"><asp:LinkButton CssClass="nodecoration" ID="btnDate4b" OnClick="changeDate2" runat="server"></asp:LinkButton></div></div>
                <div class="moreDates">More Dates<br /><asp:Image ID="imgDate" ImageUrl="images/dl_date_selector.gif" runat="server" />
                <div id="popdates" class="popdates" > 
                <asp:Repeater ID="rptDates" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDate" runat="server" OnClick="LinkButton1_Click" Text="<%#((Container.DataItem)).ToString()%>" /> 
                    </ItemTemplate>
                </asp:Repeater> 
                </div>                                       
                </div>
            </div>
            <div class="main">
                <div class="largeStill">
                <asp:Panel ID="lorax" runat="server">
                <asp:Image runat="server" ID="largeStill" ImageUrl="images/thelorax.jpg" Height="304" Width="457" />
                <asp:ImageButton CssClass="moreInfoPng" OnClick="moreInfo" ImageUrl="images/moreinfo.png" ID="ImageButton3" runat="server" />
                
                </asp:Panel >
                
                <asp:Panel ID="moviePanel" runat="server" Visible="false">
                <div id='mediaspace'>This content requires Adobe Flash Player.</div>
       
                <script type='text/javascript'>
                    //alert(document.getElementById("hdnMovieFld").value);
                    var s1 = new SWFObject('player-viral.swf', 'ply', '457', '304', '9', '#ffffff');
                    s1.addParam('allowfullscreen', 'true');
                    s1.addParam('allowscriptaccess', 'always');
                    s1.addParam('wmode', 'opaque');
                    s1.addParam('flashvars', '&stretching=fill&viral.onpause=false&viral.callout=none&file=http://media.westworldmedia.com/flash/' + document.getElementById("hdnMovieFld").value + '_high.flv&image=http://www.movienewsletters.net/photos/' + padLeft(document.getElementById("hdnMovieFld").value) + 'H2.JPG');
                    s1.write('mediaspace');
                </script>

                </asp:Panel>
                </div>
                
                 
                <div class="scroll-pane">
                <asp:Panel ID="Panel_list" runat="server" BorderWidth="0">      
                <asp:SqlDataSource ID="dsSchedule" runat="server" ConnectionString="<%$ ConnectionStrings:CinemaConnectionString %>" SelectCommand="select moviename=movies.name , convert(int,movies.movie_id) as movie_id, movies.mpaa, isnull(movies.uktitle, '') as uktitle, isnull(movies.ukmpa, '') as ukmpa, screens.*, movies.photos, movies.hiphotos, movies.videos, reviews.capsule,
                actor1,actor2,actor3,actor4,actor5
                from movies, screens, reviews
                where movies.movie_id = screens.movie_id
                and screens.house_id = @houseid
                and screens.showdate=  @showdate
                and movies.movie_id *= reviews.movie_id
                and reviews.sid = 'HOME'
                order by movie_id">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="lblHouseid" Name="houseid" PropertyName="Text" />
                        <asp:ControlParameter ControlID="lblShowdate" Name="showdate" PropertyName="Text" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:ListView ID="ListView1" runat="server" DataSourceID="dsSchedule" onitemdatabound="ListView1_ItemDataBound">
                        <LayoutTemplate>
                            <div ID="itemPlaceholderContainer" runat="server" style="position:relative; float:left; width:100%; border-style:none;">
                                <span ID="itemPlaceholder" runat="server" />
                            </div>
                       </LayoutTemplate>
                        <ItemTemplate>
                        <div class="rightList" onmouseout="this.className='rightList'" onmouseover="this.className='rightListSelected';changeLorax('<%#GetImage(Eval("movie_id", "{0}"),"H2") %>','<%#Eval("movie_id")%>','<%# WebUtils.csmovies.MovieTitle(FixTitle((string)Eval("moviename")))%>');">
                            <asp:Panel ID="Panel1" runat="server" BorderWidth="0">                                
                                <div class="movieLittle"><asp:ImageButton ID="imgLorax" Height="78" Width="118" OnClick="moreInfo" ImageUrl='<%#GetImage(Eval("movie_id", "{0}"),"H2") %>' runat="server" /></div>
                                <div class="movieTitle"><%# WebUtils.csmovies.MovieTitle((string)Eval("moviename"))%> (<%# WebUtils.csutils.ntrim((String)Eval("mpaa")) %>)</div>
                                <div class="movieText">               
                                <%#WebUtils.csmovies.ActorNames(Eval("actor1"), Eval("actor2"), Eval("actor3")) %> <br />
                                <asp:Literal ID="litShowtimes" runat="server"></asp:Literal>  
                                </div>
                                <div class="movieInfo"><asp:ImageButton ID="ImageButton2" ImageUrl="images/moreinfo_small.gif" CommandName="GetMovie" CommandArgument='<%#Eval("movie_id") %>' OnCommand="ImageButton" runat="server" /></div>
                            </asp:Panel>                    
                        </div>
                        </ItemTemplate>
                    </asp:ListView> 
                </asp:Panel>
                <asp:Panel ID="Panel_info" runat="server" BorderWidth="0" Visible="false">
                    <div class="rightInfo">
                        <div class="movieTitleInfo"><asp:Label ID="lblMovieTitle" runat="server" Text="Label"></asp:Label></div>                        
                        <div class="movieActors"><asp:Label ID="lblMovieActors" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTextInfo"><asp:Label ID="lblMovieText" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieImages"><asp:Image ID="movieImage1" CssClass="border" ImageUrl="images/info_lorax1.gif"  Width="118" Height="78" runat="server" />&nbsp;&nbsp;&nbsp;<asp:Image ID="movieImage2" Width="118" Height="78" CssClass="border" ImageUrl="images/info_lorax2.gif" runat="server" Visible="false" /></div>
                        <div class="backtoShowtimes"><asp:ImageButton ID="ImageButton1" ImageUrl="images/backtoshowtimes.gif" OnClick="bringBack" runat="server" /></div>
                        
                        <div class="next"><asp:LinkButton ID="btnNext" OnClick="Next" runat="server">next &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:LinkButton></div>
                        <div class="previous"><asp:LinkButton ID="btnPrev" OnClick="Prev" runat="server">previous &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</asp:LinkButton></div>
                     </div>
                </asp:Panel>
                </div>
            </div>
        </div>
       
    </div>
    </form>
<script type="text/javascript">
$(".popdatesclass").hide();
$('.moreDates').live('click', function (e) {
    $('#popdates').toggle('fast', function () {
        // Animation complete.
    });
});

$("body").click
(
    function (e) {
        // Body click should close any open popups...unless the button itself was clicked
        if (e.target.id !== "selectDate" && e.target.id !== "selectDate") {
            $(".popdatesclass").hide();
        }
    }
);
</script>
</body>
</html>