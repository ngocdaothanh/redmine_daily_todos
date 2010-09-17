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

function addOption(selectbox,text,value )
{
var optn = document.createElement("OPTION");
optn.text = text;
optn.value = value;
selectbox.options.add(optn);
}


function addNewChar() {
  var arr_entry_begin = new Array();
  var arr_entry_end = new Array();
  var index_entry_begin_4i = $("daily_todo_entry_begin_4i").selectedIndex;
  for(var i=0; i< $("daily_todo_entry_begin_4i").length; i++) {
      arr_entry_begin.push($("daily_todo_entry_begin_4i").options[i].value);
  }
  while($("daily_todo_entry_begin_4i").length > 0)
  {
   $("daily_todo_entry_begin_4i").remove(0);
  }
  addOption($("daily_todo_entry_begin_4i"), "--", "--");
  for(var i=0; i< arr_entry_begin.length; i++) {
    addOption($("daily_todo_entry_begin_4i"),arr_entry_begin[i],arr_entry_begin[i]);
  }
  for(var i=0; i< $("daily_todo_entry_begin_5i").length; i++) {
      if ($("daily_todo_entry_begin_5i").options[i].value % 5 == 0) {
        arr_entry_end.push($("daily_todo_entry_begin_5i").options[i].value);
      }
  }
  while($("daily_todo_entry_begin_5i").length > 0)
  {
   $("daily_todo_entry_begin_5i").remove(0);
  }
 for(var i=0; i< arr_entry_end.length; i++) {
    addOption($("daily_todo_entry_begin_5i"),arr_entry_end[i],arr_entry_end[i]);
  }
  $("daily_todo_entry_begin_4i").selectedIndex = index_entry_begin_4i + 1  ;
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
