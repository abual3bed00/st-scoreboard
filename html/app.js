window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "open":
      Open(event.data);
      break;
    case "close":
      Close();
      break;
    case "update":
      UpdateData(event.data);
      break;
  }
});

let clockInterval = null;

function updateClock() {
  const now = new Date();
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const seconds = String(now.getSeconds()).padStart(2, '0');
  $('#local-time').text(`${hours}:${minutes}:${seconds}`);
}

function startClock() {
  if (clockInterval) clearInterval(clockInterval);
  updateClock();
  clockInterval = setInterval(updateClock, 1000);
}

function stopClock() {
  if (clockInterval) {
    clearInterval(clockInterval);
    clockInterval = null;
  }
}

const Open = (data) => {
  $(".scoreboard-block").fadeIn(150);
  
  $("#online-players").text(data.players || 0);
  $("#total-players").text((data.players || 0) + " / " + (data.maxPlayers || 48));
  $("#server-uptime").text(data.uptime || "0h 0m");
  
  const percentage = ((data.players || 0) / (data.maxPlayers || 48)) * 100;
  $("#player-progress").css("width", percentage + "%");

  // تحديث جميع الإجراءات (الأنشطة + الخطف)
  if (data.allActions && typeof data.allActions === 'object') {
    $.each(data.allActions, (key, category) => {
      const statusElement = $(`#status-${key}`);
      if (statusElement.length) {
        if (category.busy)
          statusElement.html('<i class="fas fa-clock"></i>');
        else if (data.currentCops >= category.minimumPolice)
          statusElement.html('<i class="fas fa-check"></i>');
        else
          statusElement.html('<i class="fas fa-times"></i>');
      }
    });
  }

  // تحديث إحصائيات المهن
  if (data.jobCounts && typeof data.jobCounts === 'object') {
    let jobsHtml = '';
    const jobIcons = {
      police: { icon: 'fa-handcuffs', label: 'Police' },
      ambulance: { icon: 'fa-ambulance', label: 'EMS' },
      mechanic: { icon: 'fa-wrench', label: 'Mechanic' },
      realestate: { icon: 'fa-building', label: 'Real Estate' },
      taxi: { icon: 'fa-taxi', label: 'Taxi' },
    };
    for (const [job, count] of Object.entries(data.jobCounts)) {
      const jobInfo = jobIcons[job] || { icon: 'fa-briefcase', label: job };
      jobsHtml += `
        <div class="job-item">
          <i class="fas ${jobInfo.icon}"></i>
          <span class="job-label">${jobInfo.label}</span>
          <span class="job-count">${count}</span>
        </div>
      `;
    }
    $('#jobs-container').html(jobsHtml);
  }

  if (data.ping !== undefined) {
    $("#server-ping").text(data.ping + "ms");
  }

  startClock();
};

const Close = () => {
  $(".scoreboard-block").fadeOut(150);
  stopClock();
};

const UpdateData = (data) => {
  $("#online-players").text(data.players || 0);
  $("#total-players").text((data.players || 0) + " / " + (data.maxPlayers || 48));
  $("#server-uptime").text(data.uptime || "0h 0m");
  const newPercentage = ((data.players || 0) / (data.maxPlayers || 48)) * 100;
  $("#player-progress").css("width", newPercentage + "%");

  if (data.ping !== undefined) {
    $("#server-ping").text(data.ping + "ms");
  }

  if (data.allActions && typeof data.allActions === 'object') {
    $.each(data.allActions, (key, category) => {
      const statusElement = $(`#status-${key}`);
      if (statusElement.length) {
        if (category.busy)
          statusElement.html('<i class="fas fa-clock"></i>');
        else if (data.currentCops >= category.minimumPolice)
          statusElement.html('<i class="fas fa-check"></i>');
        else
          statusElement.html('<i class="fas fa-times"></i>');
      }
    });
  }

  if (data.jobCounts && typeof data.jobCounts === 'object') {
    let jobsHtml = '';
    const jobIcons = {
      police: { icon: 'fa-handcuffs', label: 'Police' },
      ambulance: { icon: 'fa-ambulance', label: 'EMS' },
      mechanic: { icon: 'fa-wrench', label: 'Mechanic' },
      realestate: { icon: 'fa-building', label: 'Real Estate' },
      taxi: { icon: 'fa-taxi', label: 'Taxi' },
    };
    for (const [job, count] of Object.entries(data.jobCounts)) {
      const jobInfo = jobIcons[job] || { icon: 'fa-briefcase', label: job };
      jobsHtml += `
        <div class="job-item">
          <i class="fas ${jobInfo.icon}"></i>
          <span class="job-label">${jobInfo.label}</span>
          <span class="job-count">${count}</span>
        </div>
      `;
    }
    $('#jobs-container').html(jobsHtml);
  }
};