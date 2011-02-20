var mins;
var secs;

function cd() {
	/* change minutes here */
 	mins = 1 * m("00"); 
	/* change seconds here (always add an additional second to your total) */
 	secs = 0 + s(timeout_value); 
 	redo();
}

function m(obj) {
 	for(var i = 0; i < obj.length; i++) {
  		if(obj.substring(i, i + 1) == ":")
  		break;
 	}
 	return(obj.substring(0, i));
}

function s(obj) {
 	for(var i = 0; i < obj.length; i++) {
  		if(obj.substring(i, i + 1) == ":")
  		break;
 	}
 	return(obj.substring(i + 1, obj.length));
}

function dis(mins,secs) {
 	var disp;
 	if(mins <= 9) {
  		disp = " 0";
 	} else {
  		disp = " ";
 	}
 	disp += mins + ":";
 	if(secs <= 9) {
  		disp += "0" + secs;
 	} else {
  		disp += secs;
 	}
 	return(disp);
}

function redo() {
 	secs--;
 	if(secs == -1) {
  		secs = 59;
  		mins--;
 	}

	/* setup additional displays here */
 	document.cd.disp.value = dis(mins,secs); 
 	if((mins == 0) && (secs == 0)) {
		/* change timeout message as required */
  		window.alert("Firmware load is completed. Press OK to continue.");
		/* redirects to specified page once timer ends and ok button is pressed */
  		window.location = script_name;
 	} else {
 		cd = setTimeout("redo()",1000);
 	}
}

function init() {
  cd();
}

window.onload = init;



