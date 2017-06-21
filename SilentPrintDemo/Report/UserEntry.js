var app = new Vue({
  el: '#report',
  data: {
  	//Internal state of Vue app
  	previousSelectedTextId: null,  //id of selected text
		preTextBackgroundColor: null,  //background color of selected text
		mode: "edit", //There are two possible mode: edit and view readonly
		//In mode "view", we deactivate methods: openCameraRoll and enterText
		//--------------------------------------------
		//Data for report
  	reportLogo: "logo2.png",
  	topDoctorImage: "doctor1.jpg",
    greetingText: "Greeting text from doctor. I don\'t why they give this field too much space", //
    topDoctorText: "The name of the Doctor <br>\
						Organization: <br>\
						Andress: <br>\
						Phone / Fax: <br>\
						Website link",
		bottomDoctorText: "Please enter doctor 's name",
		surgeryInfoText: "Surgey Info Text (max 10 lines)<br>\
											.<br>\
											.<br>\
											.<br>\
											.<br>",
		bottomText1: "Notes from doctor assistant #1 (max 4 lines of text)<br>.<br>.<br>.<br>.<br>", //
		bottomText2: "Notes from doctor assistant #2 (max 4 lines of text)<br>.<br>.<br>.<br>.<br>", //
		bottomImageHeader1: "Role of 1st surgery assistance", //
		bottomImage1: "doctor2.jpg",
		bottomImageCaption1: "Name of 1st surgery assistance", //

		bottomImageHeader2: "Role of 2nd surgery assistance",  //
		bottomImage2: "doctor3.jpg",
		bottomImageCaption2: "Name of 2nd surgery assistance", //
		//-------------

		reportLine1: "Doctor: Ivan Zhivago Baker",
		reportLine2: "Mayo Clinic - Cardio Surgery",
		reportLine3: "Email: zhivago@gmail.com",

		reportLine4: "MRN: 212-485",
		reportLine5: "Patient: John Silver Bank",
		reportLine6: "Surgery date: 2017-06-10",

		doctorInfoLogo: "logo1.png"
  },
    methods: {
      openCameraRoll: function (event) {
      	if (app.mode === "view") return;
        var message = {"action":"openCameraRoll", "id": event.target.id}
        window.webkit.messageHandlers.interOp.postMessage(message)        
      },

      enterText: function(event) {
      	if (app.mode === "view") return;

        var message = {"action":"enterText", "id": event.target.id, "text": event.target.innerText}

        if (app.previousSelectedTextId !== event.target.id) {
        	if (app.previousSelectedTextId!== null) {
        		document.getElementById(app.previousSelectedTextId).style.background = app.preTextBackgroundColor;
        	}
        	app.previousSelectedTextId = event.target.id;
        	app.preTextBackgroundColor = event.target.style.background;
        }

        event.target.style.background = "#DDDDDD";
        window.webkit.messageHandlers.interOp.postMessage(message)
      }
    }
})


function changePhoto(path, photoid) {  
  app[photoid] = path
}

function setText(id, text) {
	app[id] = text
}

function getZoomLevel() {
	return document.body.style.zoom;
}

/*
mode can be: 'view' or 'edit'
view: to display, print report
edit: to entry text and place photo to report
*/
function setMode(mode) {
	app.mode = mode;

	//When set mode back to 'view' clear previousSelectedTextId, preTextBackgroundColor to null
	if (mode === 'view' && app.previousSelectedTextId != null) {
		document.getElementById(app.previousSelectedTextId).style.background = app.preTextBackgroundColor;
		app.previousSelectedTextId = null;
		app.preTextBackgroundColor = null;
	}
}
