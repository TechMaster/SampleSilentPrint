var mixin = {
	data: {
    //Internal state of Vue app
    previousSelectedTextId: null,  //id of selected text
    preTextBackgroundColor: null,  //background color of selected text
    mode: "edit", //There are two possible mode: edit and view readonly
    //In mode "view", we deactivate methods: openCameraRoll and enterText
    //--------------------------------------------
  },
  methods: {
    openCameraRoll: function (event) {
     if (app.mode === "view") return;
     if (app.previousSelectedTextId!== null) {
      clearSelectedText(app.previousSelectedTextId);
    }
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
  }  //end of method declaration
};

/*
Apply new photo to photo place holder
*/
function changePhoto(path, photoid) {  
  app[photoid] = path
}
/*
Assign new text string to text element
*/
function setText(id, text) {
	app[id] = text
}

/*
* Set dataObject to Vue report
* https://stackoverflow.com/questions/684672/how-do-i-loop-through-or-enumerate-a-javascript-object
*/
function setData(dataObject) {
  for (var key in dataObject) {
    if (app.hasOwnProperty(key)) {      
      app[key] = dataObject[key];
    }
  }
}

/*
Get page zoom scale
*/
function getZoomLevel() {
	return document.body.style.zoom;
}

function clearSelectedText(id) {
	if (app.previousSelectedTextId!== null) {
    document.getElementById(app.previousSelectedTextId).style.background = app.preTextBackgroundColor;
    app.previousSelectedTextId = null;
    app.preTextBackgroundColor = null;
  }
}

function scrollToSelectedElement(id) {
	if (id !== null) {
		VueScrollTo.scrollTo("#" + id);
	}
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