	var report = $('#report') ;  // Get report element. There should be only one element
	var arrayOfPages = $('.page'); // Get all pages in report
	var page_box = $('.page_box'); // Get pagebox
	var image_box = $('.image_box') ; // Get all image_box


	
	function getImage(totalImage,imagesPerPage){
		//----------- Declare function in function --------
		/*
		* 
		*/
		function importImage(totalImage){
			var content = '' ;
			for (var i = 1 ; i<=totalImage ; i++ ){
				content += $(page_box).html();
				$(report).html(content);
			}
			var img = $('img');
			var title = $('.title') ;
			for (var j = 1 ; j<=totalImage ; j++ ){
				img[j-1].src = "images/"+data[j-1].file ;
				title[j-1].innerText = data[j-1].desc;;
			}
			image_box = $('.image_box') ;
			img = $('.img');
			arrayOfPages = $('.page');
			for (var k = 0 ; k < totalImage ; k++) {
				img[k].id += 'i'+ (k+1);
			}
		}

		function displayPage(){
			for (var j=0 ; j<totalImage ; j++) {
				arrayOfPages[j].className = arrayOfPages[j].className.replace("displayNone","");
				arrayOfPages[j].className += " displayNone" ;
			}
			var pages = totalImage/imagesPerPage ;
			if (pages-pages.toFixed(0)>0){pages=+pages.toFixed(0)+1} ;
			if (pages-pages.toFixed(0)<0){pages=+pages.toFixed(0)} ;
			var pageNumber = $('.pageNumber') ;
			for (var k=0 ; k<pages ; k++) {
				arrayOfPages[k].className = arrayOfPages[k].className.replace(" displayBlock","");
				arrayOfPages[k].className += " displayBlock" ;
				allPage[k].innerText = pages ;
				pageNumber[k].innerText = k+1 ;
			}	
		}
		//----------- End declare function in function --------
		importImage(totalImage);
		img = $('.img');
		title = $('.title') ;
		var allPage = $('.allPage');
		


		switch(imagesPerPage)	{
		// CHỌN HIỂN THỊ 1 ẢNH  -------------------------------------------------------------------------------------------------
			case 1 :
				for (var i=0 ; i<imagesPerPage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
				}				
				break;
			// CHỌN HIỂN THỊ 2 ẢNH  -----------------------------------------------------------------------------------------------------
			case 2 :
				$("#i1,#i2").appendTo(image_box[0]);
				$("#i3,#i4").appendTo(image_box[1]);
				$("#i5,#i6").appendTo(image_box[2]);
				$("#i7,#i8").appendTo(image_box[3]);
				$("#i9,#i10").appendTo(image_box[4]);
				$("#i11,#i12").appendTo(image_box[5]);
				$("#i13,#i14").appendTo(image_box[6]);
				$("#i15,#i16").appendTo(image_box[7]);
				$("#i17,#i18").appendTo(image_box[8]);
				$("#i19,#i20").appendTo(image_box[9]);
				$("#i21,#i22").appendTo(image_box[10]);
				$("#i23,#i24").appendTo(image_box[11]);
				$("#i25,#i26").appendTo(image_box[12]);
				$("#i27,#i28").appendTo(image_box[13]);
				$("#i29,#i30").appendTo(image_box[14]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b2' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 3 ẢNH  -----------------------------------------------------------------------------------------------------
			case 3 : 
				$("#i1,#i2,#i3").appendTo(image_box[0]);
				$("#i4,#i5,#i6").appendTo(image_box[1]);
				$("#i7,#i8,#i9").appendTo(image_box[2]);
				$("#i10,#i11,#i12").appendTo(image_box[3]);
				$("#i13,#i14,#i15").appendTo(image_box[4]);
				$("#i16,#i17,#i18").appendTo(image_box[5]);
				$("#i19,#i20,#i21").appendTo(image_box[6]);
				$("#i22,#i23,#i24").appendTo(image_box[7]);
				$("#i25,#i26,#i27").appendTo(image_box[8]);
				$("#i28,#i29,#i30").appendTo(image_box[9]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b3' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 4 ẢNH  -----------------------------------------------------------------------------------------------------
			case 4 :
				$("#i1,#i2,#i3,#i4").appendTo(image_box[0]);
				$("#i5,#i6,#i7,#i8").appendTo(image_box[1]);
				$("#i9,#i10,#i11,#i12").appendTo(image_box[2]);
				$("#i13,#i14,#i15,#i16").appendTo(image_box[3]);
				$("#i17,#i18,#i19,#i20").appendTo(image_box[4]);
				$("#i21,#i22,#i23,#i24").appendTo(image_box[5]);
				$("#i25,#i26,#i27,#i28").appendTo(image_box[6]);
				$("#i29,#i30").appendTo(image_box[7]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b4' ;
				}
				displayPage()
				break;
			//CHỌN HIỂN THỊ 5 ẢNH  -----------------------------------------------------------------------------------------------------
			case 5 :
				$("#i1,#i2,#i3,#i4,#i5").appendTo(image_box[0]);
				$("#i6,#i7,#i8,#i9,#i10").appendTo(image_box[1]);
				$("#i11,#i12,#i13,#i14,#i15").appendTo(image_box[2]);
				$("#i16,#i17,#i18,#i19,#i20").appendTo(image_box[3]);
				$("#i21,#i22,#i23,#i24,#i25").appendTo(image_box[4]);
				$("#i26,#i27,#i28,#i29,#i30").appendTo(image_box[5]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b5' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 6 ẢNH  -----------------------------------------------------------------------------------------------------
			case 6 :
				$("#i1,#i2,#i3,#i4,#i5,#i6").appendTo(image_box[0]);
				$("#i7,#i8,#i9,#i10,#i11,#i12").appendTo(image_box[1]);
				$("#i13,#i14,#i15,#i16,#i17,#i18").appendTo(image_box[2]);
				$("#i19,#i20,#i21,#i22,#i23,#i24").appendTo(image_box[3]);
				$("#i25,#i26,#i27,#i28,#i29,#i30").appendTo(image_box[4]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b5' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 7 ẢNH  -----------------------------------------------------------------------------------------------------
			case 7 :
				$("#i1,#i2,#i3,#i4,#i5,#i6,#i7").appendTo(image_box[0]);
				$("#i8,#i9,#i10,#i11,#i12,#i13,#i14").appendTo(image_box[1]);
				$("#i15,#i16,#i17,#i18,#i19,#i20,#i21").appendTo(image_box[2]);
				$("#i22,#i23,#i24,#i25,#i26,#i27,#i28").appendTo(image_box[3]);
				$("#i29,#i30").appendTo(image_box[4]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b7' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 8 ẢNH  -----------------------------------------------------------------------------------------------------
			case 8 :
				$("#i1,#i2,#i3,#i4,#i5,#i6,#i7,#i8").appendTo(image_box[0]);
				$("#i9,#i10,#i11,#i12,#i13,#i14,#i15,#i16").appendTo(image_box[1]);
				$("#i17,#i18,#i19,#i20,#i21,#i22,#i23,#i24").appendTo(image_box[2]);
				$("#i25,#i26,#i27,#i28,#i29,#i30").appendTo(image_box[3]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b7' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 9 ẢNH  -----------------------------------------------------------------------------------------------------
			case 9 :
				$("#i1,#i2,#i3,#i4,#i5,#i6,#i7,#i8,#i9").appendTo(image_box[0]);
				$("#i10,#i11,#i12,#i13,#i14,#i15,#i16,#i17,#i18").appendTo(image_box[1]);
				$("#i19,#i20,#i21,#i22,#i23,#i24,#i25,#i26,#i27").appendTo(image_box[2]);
				$("#i28,#i29,#i30").appendTo(image_box[3]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b9' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 10 ẢNH  -----------------------------------------------------------------------------------------------------
			case 10 :
				$("#i1,#i2,#i3,#i4,#i5,#i6,#i7,#i8,#i9,#i10").appendTo(image_box[0]);
				$("#i11,#i12,#i13,#i14,#i15,#i16,#i17,#i18,#i19,#i20").appendTo(image_box[1]);
				$("#i21,#i22,#i23,#i24,#i25,#i26,#i27,#i28,#i29,#i30").appendTo(image_box[2]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b10' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 11 ẢNH  -----------------------------------------------------------------------------------------------------
			case 11 :
				$("#i1,#i2,#i3,#i4,#i5,#i6,#i7,#i8,#i9,#i10,#i11").appendTo(image_box[0]);
				$("#i12,#i13,#i14,#i15,#i16,#i17,#i18,#i19,#i20,#i21,#i22").appendTo(image_box[1]);
				$("#i23,#i24,#i25,#i26,#i27,#i28,#i29,#i30").appendTo(image_box[2]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b10' ;
				}
				displayPage()
				break;
			// CHỌN HIỂN THỊ 12 ẢNH  -----------------------------------------------------------------------------------------------------
			case 12 :
				$("#i1,#i2,#i3,#i4,#i5,#i6,#i7,#i8,#i9,#i10,#i11,#i12").appendTo(image_box[0]);
				$("#i13,#i14,#i15,#i16,#i17,#i18,#i19,#i20,#i21,#i22,#i23,#i24").appendTo(image_box[1]);
				$("#i25,#i26,#i27,#i28,#i29,#i30").appendTo(image_box[2]);
				for (var i=0 ; i<totalImage ; i++) {
					img[i].className = img[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
					img[i].className += ' b10' ;
				}
				displayPage()
				break;
			}
		
		displayPage()

		
	}

	

	
	