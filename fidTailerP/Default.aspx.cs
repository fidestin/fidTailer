using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using fidTailerP.com.fidestin.core;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //first page load
        }
        else
        {
            //handle the logon here...


            //wsFidestin.CheckLogon

        }
    }

    protected void submit(object sender, EventArgs e)
    {
        //com.fidestin.core.Service1 wsFidestin = new com.fidestin.core.Service1();
        Service1 wsFidestin = new Service1();

        int userID = wsFidestin.CheckLogon(this.emailB.Text, passwordB.Text);

        if (userID > 0)
        {
            Session["userID"] = userID;

            Response.Redirect("storelist.aspx");
        }

    }
}
