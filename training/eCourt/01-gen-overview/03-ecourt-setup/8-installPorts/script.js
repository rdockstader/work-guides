// JavaScript Document
document.onreadystatechange = function(){
  if (document.readyState === 'complete') {
    var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if(this.readyState == 4 & this.status == 200) {
			var responseJSON = JSON.parse(xhttp.responseText);
            // Setup Schedule table
            var portsHTML = '<table class="table table-striped">';
			portsHTML += '<thead><tr><th scope="col">Name</th><th scope="col">Range Start</th><th scope="col">Range Stop</th><tbody>';
            for (var rep in responseJSON.reps) {
                rep = responseJSON.reps[rep];
                portsHTML += '<tr><td>';
                portsHTML += rep.name;
				portsHTML += '</td><td>';
                portsHTML += rep.portStart;
				portsHTML += '</td><td>';
				portsHTML += rep.portEnd;
                portsHTML += '</td></tr>';
            }
            portsHTML += '</tbody></table>';
            // Set ports to support-schedule
            document.getElementById('install-ports').innerHTML = portsHTML;
            
		}
	};
	xhttp.open("GET", "/training/JSON/ports.json", true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send();
  }
};

