<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dreamland.aspx.cs" Inherits="Dreamland.dreamland" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Styles/dreamland.css" rel="stylesheet" type="text/css" /> 
    <script type="text/javascript" src="Scripts/swfobject.js"></script>
    <script type='text/javascript' src='jwplayer59/swfobject.js'></script>
    <script type="text/javascript" src="jwplayer59/jwplayer.js"></script>
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
                <div class="showtimes">Showtimes, <asp:Label ID="lblDate" runat="server" Text="Label"></asp:Label></div><div class="buytickets"><img src="images/buytickets.png" border="0" alt="Buy Tickets" /></div>                
            </div>
            <div class="main">
                <div class="largeStill">
                <asp:Panel ID="lorax" runat="server">
                <asp:Image runat="server" ID="largeStill" ImageUrl="images/thelorax.jpg" Height="316" Width="457" />
                <!--<asp:ImageButton CssClass="moreInfoPng" OnClick="moreInfo" ImageUrl="images/moreinfo.png" ID="ImageButton3" runat="server" />-->                
                </asp:Panel >
                
                <asp:Panel ID="moviePanel" runat="server" Visible="false">
                <div id='mediaspace'></div>
                <script type="text/javascript">
                    jwplayer("mediaspace").setup({ autostart: false, image: 'http://www.movienewsletters.net/photos/' + padLeft(document.getElementById("hdnMovieFld").value) + 'H2.jpg', file: 'http://media.westworldmedia.com/mp4/' + document.getElementById("hdnMovieFld").value + '_high.mp4', flashplayer: "jwplayer59/player.swf", width: 457, height: 316 });
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
                                <div class="movieInfo"><asp:ImageButton ID="ImageButton2" ImageUrl="images/Moreinfo.png" CommandName="GetMovie" CommandArgument='<%#Eval("movie_id") %>' OnCommand="ImageButton" runat="server" /></div>
                            </asp:Panel>          
                        </div>
                        </ItemTemplate>
                    </asp:ListView>
                    <div class="rightList_bottom">
                    <br /><br /> Movie Line: 508.228.1784
                    </div>
                </asp:Panel>
                <asp:Panel ID="Panel_info" runat="server" BorderWidth="0" Visible="false">
                    <div class="rightInfo">
                        <div class="movieNavigation">
                        <div class="backto"><asp:LinkButton ID="btnBacktoShowtimes" OnClientClick="javascript:document.getElementById('lblTitleMovie').innerHTML = ''" OnClick="bringBack" runat="server">Back to Showtimes</asp:LinkButton></div>
                        <div class="previous"><asp:LinkButton ID="btnPrev" OnClick="Prev" runat="server">Previous</asp:LinkButton></div>
                        <div class="next"><asp:LinkButton ID="btnNext" OnClick="Next" runat="server">Next</asp:LinkButton></div>
                       
                        </div>
                        <div class="movieTitleInfo"><asp:Label ID="lblMovieTitle" runat="server" Text="Label"></asp:Label></div>                        
                        <div class="movieActors"><asp:Label ID="lblMovieActors" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes1" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes2" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes3" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes4" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes5" runat="server" Text="Label"></asp:Label></div>
                        <div class="movieTimes"><asp:Label ID="lblMovieTimes6" runat="server" Text="Label"></asp:Label></div>

                        <div class="movieTextInfo"><asp:Label ID="lblMovieText" runat="server" Text="Label"></asp:Label></div>
                        <!--<div class="movieImages"><asp:Image ID="movieImage1" CssClass="border" ImageUrl="images/info_lorax1.gif"  Width="118" Height="78" runat="server" />&nbsp;&nbsp;&nbsp;<asp:Image ID="movieImage2" Width="118" Height="78" CssClass="border" ImageUrl="images/info_lorax2.gif" runat="server" Visible="false" /></div>
                        <div class="backtoShowtimes"><asp:ImageButton ID="ImageButton1" ImageUrl="images/backtoshowtimes.gif" OnClientClick="javascript:document.getElementById('lblTitleMovie').innerHTML = ''" OnClick="bringBack" runat="server" /></div>
                        
                       -->
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
