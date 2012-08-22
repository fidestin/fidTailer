//loads the open Vouchers - for a StoreManager
//Website and App
var Fidestin={};

Fidestin.Utils={};

Fidestin.WebServices={};
Fidestin.DirectWebServices={};				//location of the web services required for integration with the DirectBooking Engine.


Fidestin.Utils.AboutPage='http://www.fidestin.com/about.html';          //About page.


//Webservices Location - Dont point to Handygrub.com - or you will get Access-Origina error for script.

//Fidestin.WebServices.Location='http://www.fidestin.com/loya';
Fidestin.WebServices.Location='http://www.fidestin.com/test';			//was mistakenly submitted to Apple pointing to TEST...
Fidestin.DirectWebServices.Location='https://www.fidestin.com/interbooking';
//Fidestin.WebServices.Location='http://www.fidestin.com/LoyaltyVersions/1.3';


//WebService Version
//Fidestin.Utils.Version=1.3;   //DEV
Fidestin.Utils.Version=1.2;   	//TEST This matches the webservice version which was in release Env May 10th-26th
//Fidestin.Utils.Version=1.1	//PRODUCTION


var DEBUG_debugalert=true;

function debugalert(themessage){
    if (DEBUG_debugalert==true){
        alert(themessage);
        console.log(themessage);
    }
    else
    {
        console.log(themessage);
    }
}


Fidestin.Utils.checkConnection=function(){
    
   try{
   debugalert('here1');
    console.log('Checking network');
    var networkState = navigator.network.connection.type;
    var alertmessage='An internet connection is required to use this app fully, but you may scan and store offline.';
    var states = {};
    states[Connection.UNKNOWN]  = 'Unknown connection';
    states[Connection.ETHERNET] = 'Ethernet connection';
    states[Connection.WIFI]     = 'WiFi connection';
    states[Connection.CELL_2G]  = 'Cell 2G connection';
    states[Connection.CELL_3G]  = 'Cell 3G connection';
    states[Connection.CELL_4G]  = 'Cell 4G connection';
    states[Connection.NONE]     = 'No network connection';
    console.log('Network state :' + networkState);
    if(states[networkState]==states[Connection.NONE] || states[networkState]==states[Connection.UNKNOWN]){
        debugalert('here2');
        //Ext.Msg.alert('',alertmessage);
        var thetitle='No Connection';
        var themessage='An internet connection is required to use this application. You may scan while off-line, and upload when back online.';
        
        Fidestin.Utils.DisplayMessage(thetitle,themessage,'AAC');
        
        console.log('False network');
        return false;
    } else {
			debugalert('here3');
            console.log('Network true');
            return true;   
                 //FIX_57 COMMENTED CHECK Stil to be added....BCMA
    }
    
	}
	catch(b){
		debugalert('An error has occurred ' +b);
	}
    
    
}


//Used to redeem the voucher for the retailer...
Fidestin.Utils.javFunc=function(vid){
		if (confirm("Redeem this Voucher : " + vid+"?"))
		{
            var params="{voucherID:'"+vid+"'}";
            $.ajax({
                type:"POST",
                data:params,
                dataType:"json",    
                contentType: "application/json; charset=utf-8",
                url:Fidestin.WebServices.Location+"/Service1.asmx/RedeemVoucher",
                success:function(result) {
                    //alert('Voucher ' + vid + ' redeemed.Reloading data....');
                    window.location.reload();
                },
                error:function(){
                    alert('Error in Fidestin.Utils.javFunc');
                }
            });      
	      }
}

Fidestin.Utils.getMonthAsInteger=function(monthstring)
{
	var result=0;
	var upperMonth=monthstring.toLocaleUpperCase();
	if (upperMonth=="JAN") result=1;
	if (upperMonth=="FEB") result=2;
	if (upperMonth=="MAR") result=3;
	if (upperMonth=="APR") result=4;
	if (upperMonth=="MAY") result=5;
	if (upperMonth=="JUN") result=6;
	if (upperMonth=="JULY") result=7;
	if (upperMonth=="AUG") result=8;
	if (upperMonth=="SEPT") result=9;
	if (upperMonth=="OCT") result=10;
	if (upperMonth=="NOV") result=11;
	if (upperMonth=="DEC") result=12;
	
	return result;
	
}

Fidestin.Utils.getOpenVouchers=function(storeID){
				var params="{customercode:'0',redeemedstatus:'0',storeID:'"+storeID+"'}";
	            $.ajax({
	                type:"POST",
	                data:params,
	                dataType:"json",    
	                contentType: "application/json; charset=utf-8",
	                url:Fidestin.WebServices.Location+"/Service1.asmx/ListCustomerVouchers",
	                success:function(result) {
							vouchers=result.length;
							$('#tabvouchers').html('Vouchers ('+vouchers+')');
							var htmltable='<thead>';
							var trclass='';
							htmltable+='<tr><th>Customer</th><th>Purchase Date</th><th>Store</th><th>Description</th><th>Town</th><th>Voucher Code</th></tr>';
							htmltable+='</thead><tbody>';
							for (var i=0;i<result.length;i++){
								trclass=(i%2==0)?'alt':'bla';
								htmltable+='<TR class='+trclass+'><TD><a href=Fidestin.WebServices.Location+"/CustomerAccounts.html?c='+result[i].customerID+'" target="_blank">'+result[i].customername+'</a></TD><TD>'+ result[i].datecreated+'</TD><td>'+result[i].storename+'</td><td>'+result[i].description+'</td><td>'+result[i].town+'</td><td><a href="#" onclick="javascript:Fidestin.Utils.javFunc('+result[i].id+');">'+result[i].id+'-'+result[i].customerID+'-'+result[i].storeID+'</td></TR>';
							}
							htmltable+='</tbody>';
							$('#vouchers_table').append(htmltable);
	                },
	                error:function(){
	                    alert('Error in getOpenVouchers');
	                }
	            });      
}
			
//AAA=120, AAB=180, AAC=220 height. All are 250 width.
Fidestin.Utils.DisplayMessage=function(thetitle, themessage,classsize){
    if (classsize==null) classsize='AAA';
    Ext.Msg.show({ title : thetitle, msg : themessage,cls:classsize,               
                 buttons : [{
                            itemId : 'A',
                            text : 'OK',
                            ui : 'action'}]}).doComponentLayout();
}

//The Hold Vouchers have already been created
//This step just creates/registers the customer, INSERTS them as Active
//EMails out the Vouchers also...
//Called by BasicSignUp.html when Integrating with Boking Engine via javascript_jQuery
Fidestin.Utils.CreateDirectCust=function(firstname,lastname,email,password){
	try{
		
		  var params="{Firstname:'"+firstname+"',LastName:'"+lastname+"',EMail:'"+email+"',password:'"+password+"'}";
		        $.ajax({
	                type:"POST",
	                data:params,
	                dataType:"json",    
	                contentType: "application/json; charset=utf-8",
	                url:Fidestin.DirectWebServices.Location+"/booking.asmx/CreateDirectCustomer",
	                success:function(result) {
	                        if (result=='-99'){
	                	 		return -99;
	                	 	}
	                	 	else{
	                	 	
	                	 		return 0;
	                	 	}
	                		
	                },
	                error:function(){
	                    $(document).ajaxError(function(e, xhr, settings, exception) { 
	                    	debugalert('error in: ' + settings.url + ' \n'+'error:\n' + xhr.responseText ); 
	                    	});
						return -99;
	                }

	            })      
			}
			
			catch (b){
				//No error throwing in webversion
				//debugalert('Error in TranslateCode ' + b);	
			}
}
