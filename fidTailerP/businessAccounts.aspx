<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="businessAccounts.aspx.cs" Inherits="fidTailerP.businessAccounts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
   <TITLE>Fidestin Store Accounts</TITLE>
        <link rel="stylesheet" href="themes/base/jquery.ui.all.css" type="text/css">
		<link rel="stylesheet" href="tableloaderstyle.css" type="text/css" />
		<script src="jquery-1.6.2.js" type="text/javascript"></script>
		<script src="jquery.tablesorter.min.js" type="text/javascript"></script>
		<script src="ui/jquery.ui.core.js" type="text/javascript"></script>
		<script src="ui/jquery.ui.widget.js" type="text/javascript"></script>
		<script src="ui/jquery.ui.tabs.js" type="text/javascript"></script>
		<script src="ui/jquery.ui.accordion.js" type="text/javascript"></script>
		
		<script src="fidestin.js" type="text/javascript"></script>
		
		<link rel="stylesheet" href="demos.css" type="text/css" />
		
		<script type="text/javascript" src="js/highcharts.js" ></script>
		<script type="text/javascript" src="js/modules/exporting.js" ></script>
		<style type="text/css">
		
		table
		{
			font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
			width:100%;
			border-collapse:collapse;
		}
		
		table tr {
		background-color: #f2f2f2;
		}
		
		table tr:hover{
			background-color: #fff;
		}
		
		table td, th 
			{
			font-size:1em;
			border:1px solid #98bf21;
			padding:3px 7px 2px 7px;
			}
			
		table th 
			{
			font-size:1.1em;
			text-align:left;
			padding-top:5px;
			padding-bottom:4px;
			background-color:#A7C942;
			color:#ffffff;
			}
		
		table tr.alt td 
			{
			color:#000000;
			background-color:#EAF2D3;
			}
		table tr.alt :hover
			{
			background-color:#fff;
			}
			
		#resizer {
			border: 1px solid silver;   
		}
		
		#inner-resizer { /* make room for the resize handle */
			padding: 10px;
		}
		</style>
		<script type="text/javascript">
			var sortredeem_set=0;
			var sortvouchers_set=0;
			var sortpoints_set=0;
			var storeID=0;
			
			$(document).ready(function()
				{
					var userID=$('#hidSess').html();
					storeID=$('#TextBox1').val();
					//alert('Store ID is ' + storeID);
					
				}
				
			);
		</script>
		
		<script type="text/javascript">
			var query;
			var map;
			var points=0;
			var vouchers=0;
			var redeem=0;
			var charts=0;
			
			$(function() {
				query=window.location.search.substring(1);
				$( "#tabs" ).tabs();
				$("#accordion").accordion({
						autoHeight: false,
						navigation:true
					});
				addChart();
				initialize();						//draw map first...
				getStoreDetail(storeID);	        //add marker
			});
		</script>
		<style type="text/css">
            html, body, #map_canvas {
            margin: 0;
            padding: 0;
            height: 100%;
        }
      </style>
       <script type="text/javascript"  src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
		<script type="text/javascript">
			  var map;
			  var marker;
			  
			  function toggleBounce(amarker) {
				  if (amarker.getAnimation() != null) {
					amarker.setAnimation(null);
				  } else {
					amarker.setAnimation(google.maps.Animation.BOUNCE);
				  }
				}

			  var galway=new google.maps.LatLng(53.27149, -9.0542);
			  function initialize() {
				var myOptions = {
					  zoom: 15,
					  center: galway,
					  mapTypeId: google.maps.MapTypeId.ROADMAP
					};
					map = new google.maps.Map(document.getElementById('map_canvas'),myOptions);
				}
		</script>
	
		<script type="text/javascript">
		var options;
		var chart;
		
		function addChart(){
			options = {
					chart: {
						renderTo: 'container',
						spacingTop: 3,
						spacingRight: 0,
						spacingBottom: 3,
						spacingLeft: 0,
						defaultSeriesType: 'line',
						marginRight: 130,
						marginBottom: 25
					},
					title: {
						text: 'Scans from Loyal Customers',
						x: -20 //center
					},
					subtitle: {
						text: 'Source: KeepM.com',
						x: -20
					},
					xAxis: {
							title: {
								text: 'Date of month'
							},
							categories: [] 
					},
					yAxis: {
						title: {
							text: 'Customer Scans'
						},
						plotLines: [{
							value: 0,
							width: 1,
							color: '#808080'
						}]
					},
					tooltip: {
						formatter: function() {
				                return '<b>'+ this.series.name +'</b><br/>'+ this.x + '<br>' + this.y;
						}
					},
					legend: {
						layout: 'vertical',
						align: 'right',
						verticalAlign: 'top',
						x: -10,
						y: 100,
						borderWidth: 0
					},
					series: [{
						//name: 'Mr Waffle',
						//data: [21.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
					}]
				};
				
				
		}
		
			function loadChartData(){
				options.series.push(xAxis);
				options.xAxis.categories=yAxis.data;
				chart=new Highcharts.Chart(options);
			}
			
			//need to specialise to include properties on the objects in the array
			Array.prototype.hasSalesDate=function(adate){
				for (i=0; i<this.length; i++){
					if (this[i].monthdate==adate) return this[i].totalSales;
				}
				return undefined;
			}
		

			//takes an incomplete array (oldArray) and fleshes it out inesrting zeros for no records
			//returns the new full newArray
			function prepareArray(oldArray,start,end){
					var newArray=Array();
					for (var i=start;i<end;i++){
						var thisArray=new Array();
						if (oldArray.hasSalesDate(i)){					//does it exist in oldArray?
							thisArray=[i,oldArray.hasSalesDate(i)]		//yes, its in in oldarray
						}
						else {
							thisArray=[i,0]						//not in oldarray
						}	
						newArray.push(thisArray);				//push it onto the newarray
					}
					return newArray;
			}			
				
			var xAxis={data:[]};	xAxis.name='MrWaffle';
			var yAxis={data:[]};	yAxis.name='yaxis';

			function getChartDateForMonth(){
			
			var $container = $('#container');
				var origChartWidth = 400, 
					origChartHeight = 300,
					chartWidth = origChartWidth,
					chartHeight = origChartHeight;
				$('<button>+</button>').insertBefore($container).click(function() {
					chart.setSize(chartWidth *= 1.1, chartHeight *= 1.1);
				});
				$('<button>-</button>').insertBefore($container).click(function() {
					chart.setSize(chartWidth *= 0.9, chartHeight *= 0.9);
				});
				$('<button>1:1</button>').insertBefore($container).click(function() {
					chartWidth = origChartWidth; 
					chartHeight = origChartHeight;
					chart.setSize(origChartWidth, origChartHeight);
				});
				
				var now=new Date();
				var thismonth=now.getMonth()+1;
				getChartDate(thismonth);
			}
			
			//get StoreID from the querystring?
			function getStoreDetail(storeID){
				try
					{
						var params="{userID:'0',storeID:'"+storeID+"'}";
						$.ajax({
							type:"POST",
							data:params,
							dataType:"json",    
							contentType: "application/json; charset=utf-8",
							url:Fidestin.WebServices.Location+"/Service1.asmx/StoresList",
							success:function(result) {
									$('#storedetails').html('<table><tr><td>'+result[0].name+', '+result[0].address1+'</td></tr><tr><td>'+result[0].town+'</td></tr></table>');
									var mrwaffle=new google.maps.LatLng(result[0].latX, result[0].latY);
									marker = new google.maps.Marker({
										position	: mrwaffle,
										map			: map,
										animation	: google.maps.Animation.DROP,
										title		: result[0].name
									});	
									google.maps.event.addListener(marker, 'click', function() {
											infowindow.open(map,marker);
									    });
									var infowindow = new google.maps.InfoWindow({
											content: result[0].name
									    });
									toggleBounce(marker);
									map.setCenter(mrwaffle);
							},
							error:function(){
								alert('Error in getStoreDetail');
							}

						});      
					}
					
				catch(b){
					alert('Error in getStoreDetail '+b); 
				}
			}
			
			function getChartDate(monthreport){
				try
					{
						var params="{monthreport:'"+monthreport+"',yearreport:'2012',storeID:'"+storeID+"'}";
						$.ajax({
							type:"POST",
							data:params,
							dataType:"json",    
							contentType: "application/json; charset=utf-8",
							url:Fidestin.WebServices.Location+"/Service1.asmx/SalesFigures",
							success:function(result) {
								$('#tabchart').html('Charts (1)');
								var fulldata=prepareArray(result,0,31);
								for (var i=0;i<fulldata.length;i++){
											xAxis.data[i]=fulldata[i][1];
											yAxis.data[i]=fulldata[i][0];
									}
									loadChartData();
							},
							error:function(){
								alert('Error in getChartDate');
							}
						});      
					}
					
				catch(b){
					alert('Error in getChartDate '+b); 
				}
			}
		
		
			function getClosedVouchers(){
				var params="{customercode:'0',redeemedstatus:'1',storeID:'"+storeID+"'}";
	            $.ajax({
	                type:"POST",
	                data:params,
	                dataType:"json",    
	                contentType: "application/json; charset=utf-8",
	                url:Fidestin.WebServices.Location+"/Service1.asmx/ListCustomerVouchers",
	                success:function(result) {
							redeem=result.length;
							$('#tabredeem').html('Redeemed ('+redeem+')');
							var htmltable='<thead>';
							var trclass='';
							htmltable+='<tr><th>Customer</th><th>Purchased Date</th><th>Redeemed Date</th><th>Store</th><th>Description</th><th>Town</th><th>Voucher Code</th></tr>';
							htmltable+='</thead><tbody>';
							for (var i=0;i<result.length;i++){
								trclass=(i%2==0)?'alt':'bla';
								htmltable+='<TR class='+trclass+'><TD><a href="#" target="_blank">'+result[i].customername+'</a></TD><td>'+result[i].datecreated+'</td><TD>'+ result[i].datecreated+'</TD><td>'+result[i].storename+'</td><td>'+result[i].description+'</td><td>'+result[i].town+'</td><td>'+result[i].id+'-'+result[i].customerID+'-'+result[i].storeID+'</a></td></TR>';
							}
							htmltable+='</tbody>';
							$('#redeemed_table').append(htmltable);
	                },
	                error:function(){
	                    alert('Error in getClosedVouchers');
	                }
	            });      
			}
			
			function getAccount(){
				
				var params="{customerID:'0',storeID:'"+ storeID+"'}";
	            $.ajax({
	                type:"POST",
	                data:params,
	                dataType:"json",    
	                contentType: "application/json; charset=utf-8",
	                url:Fidestin.WebServices.Location+"/Service1.asmx/CustomerAccounts",
	                success:function(result) {
							points=result.length;
							$('#tabpoints').html('Transaction ('+points+')');
							var htmltable='<thead>';
							var trclass='';
							htmltable+='<tr><th>Customers</th><th>Purchase Date</th><th>Store</th><th>Amount</th><th>Facebook</th></tr>';
							htmltable+='</thead><tbody>';
							for (var i=0;i<result.length;i++){
								trclass=(i%2==0)?'alt':'bla';
								htmltable+='<TR class='+trclass+'><TD><a href="#top" target="_blank">'+result[i].customername+'</a></TD><TD>'+ result[i].purchaseDate+'</TD><td>'+result[i].storename+'</td><td>'+result[i].purchaseamount+'</td><TD>'+result[i].FBComment+'</td></TR>';
							}
							if (result.length==0)
							{
								htmltable+='<TR class="alt"><TD><a href="#top" target="_blank">None</a></TD><TD>NONE</TD><td>NONE</td><td>NONE</td><TD>NONE</td></TR>';
							}
							htmltable+='</tbody>';
							$('#transactions_table').append(htmltable);
							$('#accountdetail').html(result + ' welcomes you. Please install this app.');
	                },
	                error:function(){
	                    alert('Error in getAccount');
	                }
	            });      
	      }
			
		function getVoucherLibrary(){
			Fidestin.Utils.getOpenVouchers(storeID);
		}		
		
		
		function getFBPosts(){
				var params="{storeID:'"+ storeID+"'}";
	            $.ajax({
	                type:"POST",
	                data:params,
	                dataType:"json",    
	                contentType: "application/json; charset=utf-8",
	                url:"http://www.fidestin.com/FB/Service1.asmx/LoadPosts",
	                success:function(result) {
							messages=result.length;
							$('#tabfacebook').html('Facebook - ('+messages+')');
							var htmltable='<thead>';
							var trclass='';
							htmltable+='<tr><th>Customer</th><th>Purchase Date</th><th>Message</th><th>Amount</th></tr>';
							htmltable+='</thead><tbody>';
							for (var i=0;i<result.length;i++){
								trclass=(i%2==0)?'alt':'bla';
								htmltable+='<TR class='+trclass+'><TD><a href="#" target="_blank">'+result[i].customername+'</a></TD><TD>'+ result[i].fb_posted_at+'</TD><td>'+result[i].fb_message+'</td><td>'+result[i].amount+'</td></TR>';
							}
							if (result.length==0)
							{
								htmltable+='<TR class="alt"><TD><a href="#top" target="_blank">None</a></TD><TD>NONE</TD><td>NONE</td><td>NONE</td><TD>NONE</td></TR>';
							}
							htmltable+='</tbody>';
							$('#facebook_table').append(htmltable);
							$('#accountdetail').html(result + ' welcomes you. Please install this app.');
	                },
	                error:function(){
	                    alert('Error in getFBPosts');
	                }
	            });      
	      }	
			
		</script>
</head>
<BODY onload="getAccount();getVoucherLibrary();getClosedVouchers();getChartDateForMonth();getFBPosts();">
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="TextBox1" runat="server"  BorderStyle="None" ForeColor="white" Enabled="false" BackColor="White"></asp:TextBox>
   
    <!-- Madin Fidestin Stuff -->
    
         
			<div id="accountdetails"></div>
		<P>
		<p>
		<a name="top">
			
		<div class="demo">
            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/storeList.aspx" Text="<- Stores"></asp:HyperLink>
            <BR />
            <br />
            <a href="javascript:window.print()"><img src="images/print-icon.png" width="25" height="25" /></a>
			<BR>
			<a href="javascript:window.print()">Print This Page</a>
			<br>
			<div id="Div1"> <a href="javascript:window.location.reload();">Refresh Data</a></div>
			<P>
	 </div>
    </form>
			<div id="accordion">
				<h3><a href="#section1" id="section1">General Store Information</a></h3>
					<div id="stores">
						<table class="someother">
							<tr class="someother">
								<td valign="top"><strong><div id="storedetails"></div></strong></td>
								<td>
									<div id="map_canvas" style="border: 1px solid #979797; background-color: #e5e3df;width: 500px; height: 300px; margin:0 4em;">
									</div>
								</td>
								<td><div><a href="http://www.mrwaffle.ie" target="_blank"><img src="coffee.jpg" width="150" height="150"></a></div></td>
							</tr>
						</table>
					</div>
				
				<h3><a href="#section2" id="section2">Configuration</a></h3>
					<div id="config"><strong>Store configuration data.</strong>
					</div>	
				<h3><a href="#section3" id="section3">Customer Trends</a></h3>
					<div id="tabs">
						<ul>
							<li><a href="#tabs-1" id="tabpoints">Transactions</a></li>
							<li><a href="#tabs-2" id="tabvouchers">Vouchers</a></li>
							<li><a href="#tabs-3" id="tabredeem">Redeemed</a></li>
							<li><a href="#tabs-4" id="tabchart">Charts</a></li>
							<li><a href="#tabs-5" id="tabfacebook">Facebook</a></li>
						</ul>
						<div id="tabs-1">
							<table cellspacing="1"  id="transactions_table"></table>
						</div>
						<div id="tabs-2">
							<table cellspacing="1" id="vouchers_table"></table>
						</div>	
						<div id="tabs-3">
							<table cellspacing="1" id="redeemed_table"></table>
						</div>	
						<div id="tabs-4">
							<div id="resizer">
								<div id="inner-resizer">
									<div id="container"></div>
								</div>
							</div>
						</div>
						<div id="tabs-5" style="display:none">
							<table cellspacing="1" id="facebook_table"></table>
						</div>	
					</div>
			</div>
		</div>
</body>
</html>
