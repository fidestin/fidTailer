<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
        <link href="login-box.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="themes/base/jquery.ui.all.css">
		<link rel="stylesheet" href="tableloaderstyle.css">
		<script src="jquery-1.6.2.js"></script>
		<script src="fidestin.js"></script>
</head>
<script type="text/javascript">
			function submitLogon(){
				try{
						var username=$('#username').val();
						var password=$('#password').val();
						var userID=0;
						
						var params="{email:'"+username+"',password:'"+password+"'}";
						$.ajax({
							type:"POST",
							data:params,
							dataType:"json",    
							contentType: "application/json; charset=utf-8",
							url: Fidestin.WebServices.Location +"/Service1.asmx/CheckLogon",
							success:function(result) {
								window.location.href="http://www.fidestin.com/loya/storelist.html?u="+result;
							},
							error:function(){
								alert('Error ');
							}
						});      
				}
				
				catch(b){
					alert('Error in submitLogon '+b);
				}
			}
		</script>

<body>
    
    <div style="padding: 100px 0 0 250px;">
    <div><img src='fido.jpg' width="50" height="50"/></div>
        <form runat="server">
         <div id="login-box">

			    <H2><i>Fidestin</i></H2><h2>Retailer Sign In</H2>
			    <!--Retailers! Get access to your loyal customers right now. -->
			    <br />
			    (Demo username:'demo@gmail.com', password:'demo')
			    <br />
			    
			    <div id="login-box-name" style="margin-top:20px;">Email:</div>
			    <div id="login-box-field" style="margin-top:20px;">
				    <asp:TextBox ID="emailB" runat="server" CssClass="form-login" />
				    
			    </div>
			    <div id="Div1">Password:
			        <asp:TextBox Id="passwordB" runat="server" CssClass="form-login" />
			    <div id="Div2">
                    &nbsp;</div>
                    
			    <br />
			    <span class="login-box-options">
			     <asp:Button ID="btn1" Text="Sign In" runat="server" OnClick="submit" />
			    <br />
			    <br />
			   
			    <!-- 
			        <a href="#"><img src="signup.jpg" width="103" height="42" style="margin-left:90px;" onclick="submitLogon();"/></a>
			    -->
    			
	    </div>
	    
        </form>
	   
    </div>
   </body>
</html>
