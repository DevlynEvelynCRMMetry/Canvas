<%@ page import="canvas.SignedRequest" %>
<%@ page import="java.util.Map" %>
<%
    // Pull the signed request out of the request body and verify/decode it.
   Map<String, String[]> parameters = request.getParameterMap();
   String[] signedRequest = parameters.get("signed_request");
   if (signedRequest == null) {%>This App must be invoked via a signed request!<%
        return;
    }
	String yourConsumerSecret="19C0F2486930C34034513735C20CB4425AED86BAB714FB568D64E9B5701143D7";
    String signedRequestJson = SignedRequest.verifyAndDecodeAsJson(signedRequest[0], yourConsumerSecret);
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>

    <title>Hello World Canvas Example</title>

    <link rel="stylesheet" type="text/css" href="/sdk/css/canvas.css" />

    <!-- Include all the canvas JS dependencies in one file -->
    <script type="text/javascript" src="/sdk/js/canvas-all.js"></script>
    <!-- Third part libraries, substitute with your own -->
    <script type="text/javascript" src="/scripts/json2.js"></script>

  
</head>
  
<body>
    <br/>
	
    <h1>Hello   <span id='username'></span></h1>
   <h1>List o' users <span id='users'></span></h1>
	
	<script>
        
        // Paste the signed request string into a JavaScript object for easy access.
var sr = JSON.parse('<%=signedRequestJson%>');
// Reference the Chatter user's URL from Context.Links object.
var newQuery = "select+name+from+account+limit+100"
var chatterUsersUrl = sr.context.links.chatterUsersUrl;
var accountUrl =sr.context.links.queryUrl+"?q=" + newQuery;
        if (self === top) {
            // Not in Iframe
            alert("This canvas app must be included within an iframe");
        }


        Sfdc.canvas(function() {
		 var sr = JSON.parse('<%=signedRequestJson%>');
            // Save the token
         Sfdc.canvas.oauth.token(sr.oauthToken);
         Sfdc.canvas.byId('username').innerHTML = sr.context.user.fullName;
	    });



        // Make an XHR call back to salesforce through the supplied browser proxy. 
Sfdc.canvas.client.ajax(accountUrl, 
    {client : sr.client,
    success : function(data){
    // Make sure the status code is OK.
    if (data.status === 200) {
var records = (JSON.parse((JSON.stringify(data.payload.records))));

        for(var i = 0; i < records.length; i++) {
       
        console.table(JSON.parse((JSON.stringify(records[i]))));
        // Alert with how many Chatter users were returned.
        
        Sfdc.canvas.byId('users').innerHTML += JSON.stringify(data.payload.records[i].Name);
        }
    }
}});
    </script>
</body>
</html>