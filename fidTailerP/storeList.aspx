<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="storeList.aspx.cs" Inherits="fidTailerP.storeList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
       
       <title>fidestin Stores</title>
		<link rel="stylesheet" href="themes/base/jquery.ui.all.css" type="text/css"/>
		<link rel="stylesheet" href="tableloaderstyle.css" type="text/css"/>
		<script src="jquery-1.6.2.js" type="text/javascript"></script>
		<script src="jquery.tablesorter.min.js" type="text/javascript"></script>
		<script src="ui/jquery.ui.core.js" type="text/javascript"></script>
		<script src="ui/jquery.ui.widget.js" type="text/javascript"></script>
		<link rel="stylesheet" href="demos.css" type="text/css"/>
		<script src="fidestin.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        &nbsp;<asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        <asp:Repeater ID="rpStores" runat="server" OnItemCommand="rpStores_ItemCommand">
            <HeaderTemplate>
                <table width="600px" cellpadding="2" cellspacing="1" style="border:1px solid maroon;">
                    <tr>
                        <th>Store</th>
                        <th>Address</th>
                    </tr>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# DataBinder.Eval(Container,"DataItem.Name")%></td>
                    <td><%# DataBinder.Eval(Container,"DataItem.address1")%></td>
                    <td><asp:LinkButton ID="btnDetails" runat="server" CommandName="Details" CommandArgument='<%# DataBinder.Eval(Container,"DataItem.ID") %>'>Details</asp:LinkButton></td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr bgcolor="#e8e8e8">
                    <td><%# DataBinder.Eval(Container, "DataItem.Name")%></td>
                    <td><%# DataBinder.Eval(Container,"DataItem.address1")%></td>
                    <td><asp:LinkButton ID="btnDetails" runat="server" CommandName="Details" CommandArgument='<%# DataBinder.Eval(Container,"DataItem.ID") %>'>Details</asp:LinkButton></td>
                </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </form>
</body>
</html>
