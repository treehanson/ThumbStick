using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebUtils;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using System.Text.RegularExpressions;
using System.Net;

namespace Dreamland
{
    public partial class dreamland : System.Web.UI.Page
    {
        public string HouseId = HttpContext.Current.Request.QueryString["HouseId"];
        DateTime ShowDateToday = DateTime.Today;
        string[] arrMovies = new string[50];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //XpressLite xs = new XpressLite();
                //HouseId = xs.HouseId;
                if (HouseId == null)
                {
                    HouseId = "1617";
                }
                lblHouseid.Text = HouseId;
                lblShowdate.Text = ShowDateToday.ToString();
                //lblTest.Text = xs.SiteId;
                lblDate.Text = ShowDateToday.ToString("dddd, M/d");
                //btnDate2a.Text = ShowDateToday.ToString("ddd");
                //btnDate3a.Text = ShowDateToday.AddDays(1).ToString("ddd");
                //btnDate4a.Text = ShowDateToday.AddDays(2).ToString("ddd");

                //btnDate2b.Text = ShowDateToday.ToString("M/d");
                //btnDate3b.Text = ShowDateToday.AddDays(1).ToString("M/d");
                //btnDate4b.Text = ShowDateToday.AddDays(2).ToString("M/d");

                csdata dbc = new csdata("CinemaConnectionString");
                //string szSQL = " select screens.house_id, convert(int,movies.movie_id) as movie_id, movies.mpaa, movies.hiphotos, movies.name from screens, movies with (nolock) where screens.movie_id = movies.movie_id and showdate >= '" + lblShowdate.Text + "' and screens.house_id= " + HouseId + " order by movies.movie_id";
                string szSQL = "select screens.house_id, convert(int,movies.movie_id) as movie_id, movies.mpaa, movies.hiphotos, movies.name  " +
                        " from screens, movies, reviews with (nolock) " +
                        " where movies.movie_id = screens.movie_id " +
                        " and screens.house_id =  " + HouseId + 
                        " and screens.showdate=  '" + lblShowdate.Text  + "' " +
                        " and movies.movie_id *= reviews.movie_id " +
                        " and reviews.sid = 'HOME' " +
                        " order by movie_id "; 

                //lblTest.Text = szSQL;
                
                //lblTest.Text = ListView1.Items.Count.ToString();
                
                SqlDataReader rsData = dbc.SqlRead(szSQL);

                if (rsData.HasRows)
                {
                    rsData.Read();
                    if (rsData["house_id"] != DBNull.Value)
                    {
                        lblTitleMovie.Text = csmovies.MovieTitle(rsData["name"].ToString()) + "(" + rsData["mpaa"].ToString().Trim() + ")";
                        hdnMovieFld.Value = rsData["movie_id"].ToString();
                        //lblTest.Text = hdnMovieFld.Value;
                        largeStill.ImageUrl = GetImage(rsData["movie_id"].ToString().PadLeft(6, '0'), "H2");
                        
                    }
                }
                rsData.Close();
                //dbc.close();

                Showdates();
                PrevNext("start");

                szSQL = " select  count(house_id) as count " +
                               " from screens, movies, reviews with (nolock)  " +
                               " where movies.movie_id = screens.movie_id  " +
                               " and screens.house_id =  " + lblHouseid.Text +
                               " and screens.showdate=  '" + lblShowdate.Text + "'  " +
                               " and movies.movie_id *= reviews.movie_id  " +
                               " and reviews.sid = 'HOME' ";


                //lblTest.Text = szSQL;
                //if there is only one record bring the details page front
                rsData = dbc.SqlRead(szSQL);
                if (rsData.HasRows)
                {

                    while (rsData.Read())
                    {
                        if (rsData["count"] != null)
                        {
                            lblTest.Text = rsData["count"].ToString();
                            if (rsData["count"].ToString() == "1")
                            {
                                 bringFront();
                                 ImageButton1.Visible = false;
                            }
                        }
                    }
                }

                rsData.Close();
                dbc.close();

               
            }
        }

        protected void PrevNext(string direction)
        {
            int i = 0;
            //if (direction == "start")
            //{
                csdata dbc = new csdata("CinemaConnectionString");
                //string szSQL = " select distinct screens.house_id, convert(int,movies.movie_id) as movie_id, movies.hiphotos, movies.name " +
                //                " from screens, movies with (nolock) " +
                //                " where screens.movie_id = movies.movie_id and showdate >= '" + lblShowdate.Text + "'" +
                //                " and screens.house_id=  " +  lblHouseid.Text +
                //                " order by movie_id ";
                string szSQL = "select screens.house_id, convert(int,movies.movie_id) as movie_id, movies.hiphotos, movies.name  " +
                            " from screens, movies, reviews with (nolock) " +
                            " where movies.movie_id = screens.movie_id " +
                            " and screens.house_id =  " + lblHouseid.Text +
                            " and screens.showdate=  '" + lblShowdate.Text + "' " +
                            " and movies.movie_id *= reviews.movie_id " +
                            " and reviews.sid = 'HOME' " +
                            " order by movie_id ";
                SqlDataReader rsData = dbc.SqlRead(szSQL);
                //lblTest.Text = szSQL;
                if (rsData.HasRows)
                {

                    while (rsData.Read())
                    {
                        if (rsData["movie_id"] != null)
                        {
                            arrMovies[i] = rsData["movie_id"].ToString();
                            //lblTest.Text = lblTest.Text + " " + arrMovies[i];
                            i++;
                        }
                    }
                } 
                rsData.Close();
                //dbc.close();
                //get count so that details will be dafaulted if only one movie
               
            if (direction == "isFirst")
            {
                for (i = 0; i < arrMovies.Length; i++)
                {
                    int iIndex = arrMovies[i].IndexOf(hdnMovieFld.Value);
                    if (iIndex >= 0)
                    {
                        if (i == 0)
                        {
                            btnPrev.Visible = false;
                        }
                        else 
                        {
                            btnPrev.Visible = true;
                        }
                        break;
                    }
                }
            }

            if (direction == "isLast")
            {
                for (i = 0; i < arrMovies.Length; i++)
                {
                    int iIndex = arrMovies[i].IndexOf(hdnMovieFld.Value);
                    if (iIndex >= 0)
                    {
                        if (arrMovies[i + 1] == null)
                        {
                            btnNext.Visible = false;
                        }
                        else 
                        {
                            btnNext.Visible = true;
                        }
                        break;
                    }
                }
            }
            
            if (direction == "prev")
            {
                for (i = 0; i < arrMovies.Length; i++)
                {
                    int iIndex = arrMovies[i].IndexOf(hdnMovieFld.Value);
                    if (iIndex >= 0)
                    {
                        if (i > 1 && arrMovies[i - 1] != null)
                        {
                            hdnMovieFld.Value = arrMovies[i - 1];
                        }
                        else
                        {
                            hdnMovieFld.Value = arrMovies[0];
                            btnPrev.Visible = false;
                        }
                        break;
                    }
                }

            }

            if (direction == "next")
            {
                for (i = 0; i < arrMovies.Length; i++)
                {
                    int iIndex = arrMovies[i].IndexOf(hdnMovieFld.Value);
                    if (iIndex >= 0)
                    {
                        if (arrMovies[i + 1] != null)
                        {
                            hdnMovieFld.Value = arrMovies[i + 1];
                        }
                        else 
                        {
                            hdnMovieFld.Value = arrMovies[i];
                            btnNext.Visible = false;
                        }
                        break;
                    }
                }

            }
        }
        protected void Showdates()
        {
            ArrayList aryDates;
            aryDates = new ArrayList();
            //XpressLite xs = new XpressLite();
            //lblTest.Text = HouseId;
            if (HouseId != "")
            {
                csdata edb = new csdata("CinemaConnectionString");
                SqlDataReader rsData = edb.SqlRead("select distinct showdate from screens where house_id=" + HouseId + " and showdate >= getdate()-1 order by showdate");
                //lblTest.Text = "select distinct showdate from screens where house_id=" + HouseId + " and showdate >= getdate()-1 order by showdate";
                if (rsData.HasRows)
                {
                    while (rsData.Read())
                    {
                        DateTime dateValue = new DateTime();
                        dateValue = DateTime.Parse(Convert.ToDateTime(rsData[0]).ToString("MM/dd/yyyy"));
                        //add items to jquery menu
                        lblDate.Text = ShowDateToday.ToString("dddd, M/d");
                        aryDates.Add("<font style=font-weight:bold>" + dateValue.ToString("dddd") + "</font>, " + Convert.ToDateTime(rsData[0]).ToString("M/dd") + "<br/>");
                    }                    
                }
                edb.close();
                rsData.Close();
            }
           
            
        }
        protected string GetImage(string imageMovieId, string imageType)
        {
            string imageURL = "";
            string imageNumber = "02";
            csdata dbc = new csdata("CinemaConnectionString");
            if (imageType == "H1")
            { 
                imageNumber = "01";
            }
            if (imageType == "H2")
            { 
                imageNumber = "02";
            }
            if (imageType == "H3")
            { 
                imageNumber = "03";
            }

            string szSQL = "SELECT * FROM PHOTOS WHERE FILENAME = '" + imageMovieId.PadLeft(6, '0') + imageNumber + ".jpg'";

            SqlDataReader rsData = dbc.SqlRead(szSQL);

            if (rsData.HasRows)
            {
                imageURL = "http://www.movienewsletters.net/photos/" + imageMovieId.PadLeft(6, '0') + imageType + ".jpg";
            }
            else 
            {
                imageURL = "http://www.movienewsletters.net/photos/000000" + imageType + ".jpg";
            }
            rsData.Close();
            dbc.close();

            return imageURL;
            
        }

        protected string FixTitle(string title)
        {
            //had to do this because of "the Lorax'" movie
            string fixedTitle = Regex.Replace(title, "\'", "\\'");
            return fixedTitle;
        }
        protected void ListView1_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            // Get data
            ListViewDataItem lv = (ListViewDataItem)e.Item;
            System.Data.DataRowView rv = (System.Data.DataRowView)lv.DataItem;

            string szTimes = "";
            szTimes = csmovies.AppendTimes(rv, lblShowdate.Text, "", "", "", "", false);
            //szTimes = csmovies.DisplayTimes(lblHouseid.Text,lblShowdate.Text, lblShowdate.Text,"","");


            Literal litTimes = (Literal)e.Item.FindControl("litShowtimes");
            szTimes = Regex.Replace(szTimes, ",", ", ");
            //szTimes = Regex.Replace(szTimes, "[(]", "");
            //szTimes = Regex.Replace(szTimes, "[)]", "am");
            litTimes.Text = Regex.Replace(szTimes.Trim(),@"<(.|\n)*?>","");

            //lblTest.Text = dsSchedule.SelectCommand;   
            //lblTest.Text = ListView1.Items.Count.ToString();
        }

        protected void changeDate(object sender, EventArgs e)
        {
            
            lblShowdate.Text = ShowDateToday.ToString();
            lblDate.Text = ShowDateToday.ToString("dddd, M/d");

        }

        protected void changeDate1(object sender, EventArgs e)
        {
            
            lblShowdate.Text = ShowDateToday.AddDays(1).ToString();
            lblDate.Text = ShowDateToday.AddDays(1).ToString("dddd, M/d");

        }

        protected void changeDate2(object sender, EventArgs e) 
        {
           
            lblShowdate.Text = ShowDateToday.AddDays(2).ToString();
            lblDate.Text = ShowDateToday.AddDays(2).ToString("dddd, M/d");

        }
    
  
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
           
            LinkButton btn = sender as LinkButton;
            String newdate = btn.Text.Replace("<font style=font-weight:bold>", "");
            newdate = newdate.Replace("</font>", "");
            newdate = newdate.Replace("<br/>", "");
            lblDate.Text = newdate;
            lblShowdate.Text = Convert.ToDateTime(newdate).ToString();
           
        }

        protected void bringBack(object sender, EventArgs e)
        {
            lorax.Visible = true;
            moviePanel.Visible = false;
            Panel_list.Visible = true;
            Panel_info.Visible = false;

            csdata dbc = new csdata("CinemaConnectionString");
            //string szSQL = " select screens.house_id, convert(int,movies.movie_id) as movie_id, movies.mpaa, movies.hiphotos, movies.name from screens, movies with (nolock) where screens.movie_id = movies.movie_id and showdate >= '" + lblShowdate.Text + "' and screens.house_id= " + HouseId + " order by movies.movie_id";
            string szSQL = "select screens.house_id, convert(int,movies.movie_id) as movie_id, movies.mpaa, movies.hiphotos, movies.name  " +
                    " from screens, movies, reviews with (nolock) " +
                    " where movies.movie_id = screens.movie_id " +
                    " and screens.house_id =  " + lblHouseid.Text +
                    " and screens.showdate=  '" + lblShowdate.Text + "' " +
                    " and movies.movie_id *= reviews.movie_id " +
                    " and reviews.sid = 'HOME' " +
                    " order by movie_id ";

            //lblTest.Text = szSQL;
            SqlDataReader rsData = dbc.SqlRead(szSQL);

            if (rsData.HasRows)
            {
                rsData.Read();
                if (rsData["house_id"] != DBNull.Value)
                {
                    lblTitleMovie.Text = csmovies.MovieTitle(rsData["name"].ToString()) + "(" + rsData["mpaa"].ToString().Trim() + ")";
                    hdnMovieFld.Value = rsData["movie_id"].ToString();
                    //lblTest.Text = hdnMovieFld.Value;
                    largeStill.ImageUrl = GetImage(rsData["movie_id"].ToString().PadLeft(6, '0'), "H2");

                }
            }
            rsData.Close();
            dbc.close();
            //lblTitleMovie.Text = "";
            //must refresh page otherwise title will default to last rollover
            //tlm not sure why!!
            //Response.Redirect(Request.Url.AbsoluteUri); 
        }

        protected void bringFront()
        {
            lorax.Visible = false;
            moviePanel.Visible = true;
            Panel_list.Visible = false;
            Panel_info.Visible = true;

            //Display title of movie
            csdata dbc = new csdata("CinemaConnectionString");
            string szSQL = " select moviename=movies.name , convert(int,movies.movie_id) as movie_id, movies.mpaa, isnull(movies.uktitle, '') as uktitle, isnull(movies.ukmpa, '') as ukmpa, screens.*, movies.photos, movies.hiphotos, movies.videos, reviews.capsule, " +
                " actor1,actor2,actor3,actor4,actor5, reviews.capsule " +
                " from movies, screens, reviews " +
                " where movies.movie_id = screens.movie_id " +
                " and screens.house_id = " + lblHouseid.Text +
                " and screens.showdate =  '" + lblShowdate.Text + "'" +
                " and movies.movie_id = " + hdnMovieFld.Value +
                " and movies.movie_id *= reviews.movie_id " +
                " and reviews.sid = 'HOME'  " +
                " order by release desc, name, comment";
            SqlDataReader rsData = dbc.SqlRead(szSQL);
            
            if (rsData.HasRows)
            {
                rsData.Read();
                lblTitleMovie.Text = csmovies.MovieTitle(rsData["moviename"].ToString()) + " (" + rsData["mpaa"].ToString().Trim() + ")";
                lblMovieTitle.Text = csmovies.MovieTitle(rsData["moviename"].ToString()) + " (" + rsData["mpaa"].ToString().Trim() + ")";
                DateTime dateValue;
                string currentDate = lblShowdate.Text;
                if (DateTime.TryParse(currentDate, out dateValue))
                {
                    lblMovieTimes.Text = dateValue.DayOfWeek + " " + csmovies.AppendTimes(rsData, dateValue.ToString(), "", "", "", "", false) + "<br/>";
                    lblMovieTimes1.Text = dateValue.AddDays(1).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(1).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes2.Text = dateValue.AddDays(2).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(2).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes3.Text = dateValue.AddDays(3).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(3).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes4.Text = dateValue.AddDays(4).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(4).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes5.Text = dateValue.AddDays(5).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(5).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes6.Text = dateValue.AddDays(6).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(6).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                }
                else
                {
                    dateValue = new DateTime();
                    lblMovieTimes.Text = dateValue.DayOfWeek + " " + csmovies.AppendTimes(rsData, dateValue.ToString(), "", "", "", "", false) + "<br/>";
                    lblMovieTimes1.Text = dateValue.AddDays(1).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(1).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes2.Text = dateValue.AddDays(2).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(2).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes3.Text = dateValue.AddDays(3).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(3).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes4.Text = dateValue.AddDays(4).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(4).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes5.Text = dateValue.AddDays(5).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(5).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                    lblMovieTimes6.Text = dateValue.AddDays(6).DayOfWeek + " " + Regex.Replace(csmovies.AppendTimes(rsData, dateValue.AddDays(6).ToString(), "", "", "", "", false), @"<(.|\n)*?>", "");
                }
                

                lblMovieTimes.Text = Regex.Replace(lblMovieTimes.Text, @"<(.|\n)*?>", "");
                lblMovieTimes.Text = Regex.Replace(lblMovieTimes.Text, ",", ", ");
                lblMovieActors.Text = csmovies.ActorNames(rsData["actor1"].ToString(), rsData["actor2"].ToString(), rsData["actor3"].ToString(), rsData["actor4"].ToString(), rsData["actor5"].ToString());
                lblMovieText.Text = rsData["capsule"].ToString();

                movieImage1.ImageUrl = GetImage(hdnMovieFld.Value.PadLeft(6, '0'),"H2");
                string movieImage = GetImage(hdnMovieFld.Value.PadLeft(6, '0'), "H3");
                if (movieImage.IndexOf("000000") <= 0)
                {
                    movieImage2.ImageUrl = movieImage;
                    movieImage2.Visible = true;
                }
                   
                
            }
            rsData.Close();
            dbc.close();

            PrevNext("isFirst");
            PrevNext("isLast");

        }
        protected void moreInfo(object sender, EventArgs e)
        {
            bringFront();
        }

        protected void Prev(object sender, EventArgs e)
        {
            PrevNext("prev");
            bringFront();
        }
        protected void Next(object sender, EventArgs e)
        {
            PrevNext("next");
            bringFront();
        }
        protected void ImageButton(object sender, CommandEventArgs e)
        {
            //lblTest.Text = e.CommandName;
            //lblTest.Text = e.CommandArgument.ToString();
            hdnMovieFld.Value = e.CommandArgument.ToString();

            bringFront();

        }
    }
}