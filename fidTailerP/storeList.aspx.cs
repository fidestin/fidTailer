using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using fidTailerP.com.fidestin.core;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace fidTailerP
{
    public partial class storeList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Int32 userID = Convert.ToInt32(Session["userID"].ToString());

                TextBox1.Text = userID.ToString();

                //Get the stores for this user....
                Service1 wsFidestin = new Service1();

                List<Store> storeList = new List<Store>();
                fidTailerP.com.fidestin.core.Store[] arrStores = storeList.ToArray();

                arrStores = wsFidestin.StoresList(userID, 0);

                rpStores.DataSource = arrStores;
                rpStores.DataBind();
            }
            
        }

        protected void rpStores_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Int32 storeID = Convert.ToInt32(e.CommandArgument);
            Response.Redirect("businessAccounts.aspx?q="+storeID.ToString());
        }
    }
}
