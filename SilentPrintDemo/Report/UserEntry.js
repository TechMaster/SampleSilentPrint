//$('body').on('click','#topDoctorImage',function(){alert('it works');})

var app = new Vue({
  el: '#report',
  data: {
    greetingText: 'Greeting text from doctor. I don\'t why they give this field too much space',
    topDoctorText: 'The name of the Doctor <br>\
						Organization: <br>\
						Andress: <br>\
						Phone / Fax: <br>\
						Website link',
		bottomDoctorText: "Please enter doctor 's name",
		surgeryInfoText: "Surgey Info Text (max 10 lines)<br>\
											.<br>\
											.<br>\
											.<br>\
											.<br>",
		bottomText1: "Notes from doctor assistant #1 (max 4 lines of text)<br>.<br>.<br>.<br>.<br>",
		bottomText2: "Notes from doctor assistant #2 (max 4 lines of text)<br>.<br>.<br>.<br>.<br>",
		bottomImageHeader1: "Role of 1st surgery assistance",
		bottomImageCaption1: 'Name of 1st surgery assistance',
		bottomImageHeader2: "Role of 2nd surgery assistance",
		bottomImageCaption2: 'Name of 2nd surgery assistance'
  },
    methods: {
      openCameraRoll: function (photoid) {
        var message = {"action":"openCameraRoll", "photoid": photoid}
        window.webkit.messageHandlers.interOp.postMessage(message)
      },

      enterText: function(textid) {
        alert(textid)
      }
    }
})

function changePhoto(path, photoid) {  
  app[photoid] = path
}

// click vào ô chữ tại trang 1 
$('body').on('click','.hover',function(){
	alert('HAVE A NICE DAY !');
})
// click vào ô ảnh tại trang 1 
$('body').on('click','.hover2',function(){
	alert('HAVE A NICE DAY !');
})


