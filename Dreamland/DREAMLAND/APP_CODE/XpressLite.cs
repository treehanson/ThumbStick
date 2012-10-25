using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebUtils;
using System.Data.SqlClient;


public class XpressLite
{

    public string MasterPage = "notemplate";
    public string Theme = "blue";
    public string SiteId = "1";
    public string Headline = "A New Cinema";
    public string HeadImage = "";
    public string HouseId = "";
    public string CustId = "";
    public string TopBanner = "";
    public string TopBannerLink = "";
    public string Filter = "";
    public string MapKey = "ABQIAAAAKkFFOAnZINPSrhHbtcL8PhQFKOY8WIhTDo3h64KEdorXdxAvlBTbqKDI5Vgpn6ycvv779zgaLhtH7w";
    public string Analytics = "";
    public string SmartUrl = "";
    public string TextUrl = "";
    public string Exid = "";
    public string TimesType = "";
    public string Facebook = "";
    public string Twitter = "";
    public List<string> HouseIds = new List<string>();

/// <summary>
/// Information about current site
/// </summary>
public XpressLite()
{
    // Constructor. Get the site ID and then other info about the site.
    csdata edb = new csdata("WebsiteConnString");
    SqlDataReader rsData;

    // Query string is definitive
    SiteId = csutils.ntrim(HttpContext.Current.Request.QueryString["SiteId"]);

    // Not there, try URL
    if (SiteId == "")
    {
        // Otherwise use URL
        string szUrl = HttpContext.Current.Request.Url.Host;
        szUrl = szUrl.Replace("www.", "");
        rsData = edb.SqlRead("select * from Sites where SiteUrl=" + csutils.Quote(szUrl));
        if (rsData.HasRows)
        {
            rsData.Read();
            SiteId = csutils.ntrim(rsData["SiteId"]);
        }
        rsData.Close();
    }

    // Not there? Try Session. Really for debug only
    if (SiteId == "")
        SiteId = csutils.ntrim(HttpContext.Current.Session["site_id"]);

    // Save it
    if (SiteId != "")
        HttpContext.Current.Session["site_id"] = SiteId;

    // Now get the rest of the data
    if (SiteId != "")
        {
        // We have ID. Get other info from db
        rsData = edb.SqlRead("select * from Sites where SiteId=" + SiteId.ToString());
        if (rsData.HasRows)
            {
            rsData.Read();
            SiteId = csutils.ntrim(rsData["SiteId"]);
            Theme = csutils.ntrim(rsData["SiteTheme"]);
            Headline = csutils.ntrim(rsData["SiteHeadline"]);
            HeadImage = csutils.ntrim(rsData["SiteImage"]);
            MasterPage = csutils.ntrim(rsData["SiteTemplate"]);
            CustId = csutils.ntrim(rsData["cust_id"]);
            MapKey = csutils.ntrim(rsData["SiteMapKey"]);
            Filter = csutils.ntrim(rsData["SiteFilter"]);
            Analytics = csutils.ntrim(rsData["SiteAnalytics"]);
            SmartUrl = csutils.ntrim(rsData["SiteSmartUrl"]);
            TextUrl = csutils.ntrim(rsData["SiteTextUrl"]);
            Exid = csutils.ntrim(rsData["Exid"]);
            TimesType = csutils.ntrim(rsData["TimesType"]);
            Facebook = csutils.ntrim(rsData["FacebookUrl"]);
            Twitter = csutils.ntrim(rsData["TwitterUrl"]);
            if (TimesType == "")
                TimesType = "daily";
            }
        rsData.Close();
        }
        
    // Any id ?
    if (SiteId == "")
    {
        HttpContext.Current.Response.Write("<H1>No current site</H1>");
        HttpContext.Current.Response.End();
    }
    // Get default house id for this site
    SqlDataReader rsHouses = edb.SqlRead("select top 1 house_id from SiteHouses where SiteId=" + SiteId);
    if (rsHouses.HasRows)
        {
        rsHouses.Read();
        HouseId = csutils.ntrim(rsHouses["house_id"]);
        }
    rsHouses.Close();

    // Get collection of house ids for the site
    SqlDataReader rsHouseCollection = edb.SqlRead("select house_id from SiteHouses where SiteId=" + SiteId);
    if (rsHouseCollection.HasRows)
    {
        while (rsHouseCollection.Read())
            {
            HouseIds.Add(csutils.ntrim(rsHouseCollection["house_id"]));
            }
    }
    rsHouseCollection.Close();

    // Get top banner for site
    SqlDataReader rsBanner = edb.SqlRead("select top 1 imageUrl, linkUrl from SiteBanners where SiteId=" + SiteId + " and activeBanner = 1");
    if (rsBanner.HasRows)
    {
        rsBanner.Read();
        TopBanner = csutils.ntrim(rsBanner["imageUrl"]);
        TopBannerLink = csutils.ntrim(rsBanner["linkUrl"]);
    }
    rsBanner.Close();


    // Done with db
    edb.close();

    } // Xsite constructor

public string HouseList()
    {
    string Ids = "";
    foreach (string hid in HouseIds)
        {
        if (Ids != "")
            Ids += ",";
        Ids += hid;
        }
    return (Ids);
    }

} 

