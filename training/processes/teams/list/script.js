// JavaScript Document
document.onreadystatechange = function(){
  if (document.readyState === 'complete') {
    var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if(this.readyState == 4 & this.status == 200) {
			console.log(xhttp.responseText);
			var responseJSON = JSON.parse(xhttp.responseText);
            // Setup Schedule table
            var teamsHTML = '<div class="row">';
            for (var team in responseJSON.teams) {
                team = responseJSON.teams[team];
                teamsHTML += '<div class="col-6 pb-3">';
                teamsHTML += '<h2>';
                teamsHTML += team.name;
                teamsHTML += '</h2><ul class="list-unstyled">'
                for (var i in team.members) {
                    teamsHTML += '<li><strong>' + team.members[i].role + ':</strong> ' + team.members[i].name + '</li>';
                }
                teamsHTML += '</ul></div>';
				
            }
			teamsHTML += '</div>';
            // Set Teams to Teams Table
            document.getElementById('teams').innerHTML = teamsHTML;
		}
	};
	xhttp.open("GET", "/training/JSON/teams.json", true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send();
  }
};

