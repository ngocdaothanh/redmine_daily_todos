function $(element_id) {
    return document.getElementById(element_id);
}

function getClientHour() {
    d = new Date();
    utc = d.getTime() + (d.getTimezoneOffset() * 60000);
    timeZone = (d.getTimezoneOffset()/60)*(-1);
    nd = new Date(utc + (3600000*timeZone));
    return nd.getHours().toLocaleString();
}

function intValueOf(str) {
    return parseInt(str,10)
}

function getHourIndexOfTimeSelect(hour, timeElement) {
    
    for(var i=0; i < timeElement.length; i=i+1) {
        var valHour = timeElement.options[i].value;
        
        if (intValueOf(hour) == intValueOf(valHour)) {
            return i;
        }
    }
    return -1;
}

function setCurrentTime() {
    var currentHour = getClientHour();
    var indexHourOfStart = getHourIndexOfTimeSelect(currentHour, $("daily_todo_entry_begin_4i"));
    $("daily_todo_entry_begin_4i").selectedIndex = indexHourOfStart;
    var indexHourOfEnd = getHourIndexOfTimeSelect(currentHour, $("daily_todo_entry_end_4i"));
    $("daily_todo_entry_end_4i").selectedIndex = indexHourOfEnd;
   
   
}
function addNewChar() {
  var opt = document.createElement("option");
    opt.text = '--';
    opt.value = '--';
   $("daily_todo_entry_begin_4i").options.add(opt);
}
function setEnableTime() {
  var val = $("daily_todo_entry_begin_4i").value;
     if (val == "--") {
	$('daily_todo_entry_begin_5i').disabled=true;
	$('daily_todo_entry_end_4i').disabled=true;
        $('daily_todo_entry_end_5i').disabled=true;
        $("daily_todo_entry_begin_4i").value = "--";
        $('daily_todo_entry_begin_5i').value = "--";
        $('daily_todo_entry_end_4i').value = "--";
        $('daily_todo_entry_end_5i').value = "--";
    }
    else {
	$('daily_todo_entry_begin_5i').disabled=false;
        $('daily_todo_entry_end_4i').disabled=false;
        $('daily_todo_entry_end_5i').disabled=false;
    }

}
//var a = "10:15"
//var b = toDate(a,"h:m")
//alert(b);
//function toDate(dStr,format) {
//	var now = new Date();
//	if (format == "h:m") {
// 		now.setHours(dStr.substr(0,dStr.indexOf(":")));
// 		now.setMinutes(dStr.substr(dStr.indexOf(":")+1));
// 		return now;
//	}else
//		return "Invalid Format";
//}