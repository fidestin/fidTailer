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

namespace fidTailerP
{
    public partial class storeList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Int32 userID=Convert.ToInt32(Session["userID"].ToString());

            TextBox1.Text = userID.ToString();

            //Get the stores for this user....
            Service1 wsFidestin = new Service1();

            List<Store> storeList = new List<Store>();
            fidTailerP.com.fidestin.core.Store[] arrStores=storeList.ToArray();
            
            arrStores=wsFidestin.StoresList(userID, 0);

            foreach (Store thisStore in arrStores)
            {
                string storeName = thisStore.name;
            }
        }

        
    }
}
