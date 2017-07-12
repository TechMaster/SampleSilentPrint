var app = new Vue({
	el: '#report',
	mixins: [mixin],
	data: {
		PatientReport: "",
		reportLogo: "logo2.png",
		topDoctorImage: "doctor1.jpg",
    greetingText: "Greeting text from doctor. I don\'t why they give this field too much space", //
    topDoctorText: "The name of the Doctor <br>\
    Organization: <br>\
    Andress: <br>\
    Phone / Fax: <br>\
    Website link:",
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

	doctorInfoLogo: "logo1.png",
	
	//--------------
	selectedImages: [],
	imagesPerPage: 4

}
})
