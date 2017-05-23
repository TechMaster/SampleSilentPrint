let origin = $('#otherPages').html(); // gán biến origin là trạng thái HTML đầu tiên

	function getImage(data,imagesPerPage){
		const totalImage = data.length;
		//reset lại lúc đầu tiên
		$('#otherPages').html(origin);

		// gọi ra số trang sẽ hiển thị
		let numberOfPage = Math.ceil(totalImage/imagesPerPage) ; 

		//tạo số trang
		let content = '' ;
		for (let i=0 ; i<numberOfPage ; i++ ){
			content += $('#otherPages').html();
		}

		//tạo ảnh 
		for (let i=numberOfPage ; i<totalImage ; i++ ){
			content += $('.image_box').html();
		}
		$('#otherPages').html(content);

		//truyền thông tin vào ảnh và xóa class kích thước ảnh nếu có
		for (let i=0 ; i<totalImage ; i++ ){
			$('.image')[i].src = data[i].file ;
			$('.title')[i].innerText = data[i].desc;
			$('img')[i].className = $('img')[i].className.replace(" b2","").replace(" b3","").replace(" b5","").replace(" b7","").replace(" b10","");
		}

		// chia ảnh ra các trang
		let image_box = $('.image_box')
		for (let i=0 ; i<numberOfPage ; i++){
			for(let j=0 ; j<imagesPerPage ; j++){
				let k = j+i*imagesPerPage ;
				$($('.image_info')[k]).appendTo(image_box[i]);
			}
		}

		//số trang
		let allPage =$('.allPage');
		let pageNumber =$('.pageNumber');
		for (let i=0 ; i<=numberOfPage ; i++) {
			allPage[i].innerText = numberOfPage+1 ;
			pageNumber[i].innerText = i+1 ;
		}
		
		// Set kích thước cho ảnh 
		switch(imagesPerPage) {
			case 1 : break;
			case 2 : 
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b2' ;
				}
				break;
			case 3 : 
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b3' ;
				}
				break;
			case 4 :
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b4' ;
				}
				break;	
			case 5 :
			case 6 :
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b5' ;
				}
				break;
			case 7 :
			case 8 :
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b7' ;
				}
				break;
			case 9 :
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b9' ;
				}
				break;
			case 10 :
			case 11 :
			case 12 :
				for (let i=0 ; i<totalImage ; i++) {
					$('.image_info')[i].className += ' b10' ;
				}
				break;
		}	
	}