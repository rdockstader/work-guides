// JavaScript Document
document.onreadystatechange = function(){
  if (document.readyState === 'complete') {
    var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if(this.readyState == 4 & this.status == 200) {
			var responseJSON = JSON.parse(xhttp.responseText);
            // Setup Schedule table
            var scheduleHTML = '<div class="col-1"></div>';
            for (var day in responseJSON.schedule.days) {
                day = responseJSON.schedule.days[day];
                scheduleHTML += '<div class="col-2 pb-3">';
                scheduleHTML += '<p><strong>';
                scheduleHTML += day.name;
                scheduleHTML += '</strong></p><ul class="list-unstyled">'
                for (var rep in day.reps) {
                    scheduleHTML += '<li>' + day.reps[rep] + '</li>';
                }
                scheduleHTML += '</ul></div>';
            }
            scheduleHTML += '<div class="col-1"></div>';
            // Set Schedule table to support-schedule
            document.getElementById('support-schedule').innerHTML = scheduleHTML;
            // Set next rotation date
            document.getElementById('next-rotation-date').innerHTMl = responseJSON.schedule.nextRotation;
            // Set Reminders
            var remindersHTML = "";
            for(reminder in responseJSON.reminders) {
                reminder = responseJSON.reminders[reminder];
                remindersHTML+= "<li>" + reminder + "</li>";
            }
            document.getElementById('reminders-list').innerHTMl = remindersHTML;
		}
	};
	xhttp.open("GET", "/training/JSON/rotations.json", true);
	xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhttp.send();
  }
};

