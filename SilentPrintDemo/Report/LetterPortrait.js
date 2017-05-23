	var origin = $('#report').html() // gán biến origin là trạng thái HTML đầu tiên

	function getImage(data,imagesPerPage){
		//reset lại lúc đầu tiên
		const totalImage = data.length
		$('#report').html(origin);

		// gọi ra số trang sẽ hiển thị
		var numberOfPage = Math.ceil(totalImage/imagesPerPage)
		//tạo số trang
		var content = ''
		for (var i=0 ; i<numberOfPage ; i++ ){
			content += $('#otherPages').html()
		}
		//tạo ảnh 
		for (var i=numberOfPage ; i<totalImage ; i++ ){
			content += $('.image_box').html();
		}
		$('#otherPages').html(content);

		//truyền thông tin vào ảnh và xóa class kích thước ảnh nếu có
		for (var i=0 ; i<totalImage ; i++ ){
			$('.image')[i].src = data[i].file ;
			$('.title')[i].innerText = data[i].desc;
			$('img')[i].className = $('img')[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
		}

		// chia ảnh ra các trang
		var image_box = $('.image_box')
		for (var i=0 ; i<=numberOfPage ; i++){
			for(var j=0 ; j<imagesPerPage ; j++){
				var k = j+i*imagesPerPage ;
				$($('.image_info')[k]).appendTo(image_box[i]);
			}
		}

		//số trang
		var allPage =$('.allPage');
		var pageNumber =$('.pageNumber');
		for (var i=0 ; i<=numberOfPage+1 ; i++) {
			allPage[i].innerText = numberOfPage+2 ;
			pageNumber[i].innerText = i+1 ;
		}
		
		// Set kích thước cho ảnh 
		switch(imagesPerPage) {
			case 1 : break;
			case 2 : 
				for (var i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b2' ;
				}
				break;
			case 3 : 
			case 4 :
				for (var i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b3' ;
				}
				break;	
			case 5 :
			case 6 :
				for (var i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b5' ;
				}
				break;
			case 7 :
			case 8 :
			case 9 :
				for (var i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b7' ;
				}
				break;
			case 10 :
			case 11 :
			case 12 :
				for (var i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b10' ;
				}
				break;
		}	
	}