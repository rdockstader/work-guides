// JavaScript Document
$(document).ready(function() {
    var xhttpSideBar = new XMLHttpRequest();
	xhttpSideBar.onreadystatechange = function() {
		if(this.readyState == 4 & this.status == 200) {
			var sideBarDiv = document.getElementById('ecourt-side-nav');
			if(sideBarDiv != null) {
				var sideDivJSON = JSON.parse(xhttpSideBar.responseText).ecourt;
				var sideBarHTML = '';
				sideBarHTML += '<div class="accordion" id="side-bar-accordion">';
				sideBarHTML += '<div class="card">';
				for (var group in sideDivJSON) {
					// Setup Group in side bar
					group = sideDivJSON[group];
					var headingId = group.idName + '-heading';
					var collapseId = group.idName + '-collapse'; 
					sideBarHTML += '<div class="card-header" id="' + headingId + '">';
					sideBarHTML += '<h5 class="mb-0">';
					sideBarHTML += '<button class="btn btn-link" type="button" data-toggle="collapse" data-target="#';
					sideBarHTML += collapseId;
					sideBarHTML +='" aria-expanded="true" aria-controls="';
					sideBarHTML += collapseId;
					sideBarHTML += '">';
					sideBarHTML += group.name;
					sideBarHTML += "</button></h5></div>";
					sideBarHTML += '<div id="' + collapseId +'" class="collapse" aria-labelledby="' + headingId + '" data-parent="#side-bar-accordion">';
					sideBarHTML += '<div class="card-body"><ul class="list-group list-group-flush">';
					for(var link in group.links) {
						// Setup each link in group
						link = group.links[link];
						sideBarHTML += '<a href="';
						sideBarHTML += link.link;
						sideBarHTML += '" class="list-group-item list-group-item-action">';
						sideBarHTML += link.name;
						sideBarHTML += '</a>';
					}
					
					// Finish group in side bar
					sideBarHTML += '</div></ul>';
					sideBarHTML+="</div>";


				}
				// Finish Side Bar
				sideBarHTML+="</div></div>"
				// Set side bar to nav
			    sideBarDiv.innerHTML = sideBarHTML;
			}
			
		}
	};
	xhttpSideBar.open("GET", "/training/JSON/side-nav.json", true);
	xhttpSideBar.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttpSideBar.send();
  
})


