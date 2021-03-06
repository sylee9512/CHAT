$(document).ready(function(){


	var page = $('#page').val();
	var perPageNum = $('#perPageNum').val();

	$(function () {
        var chatBox = $('.box');
        var messageInput = $('input[name="msg"]');
        var roomNo = $('.content').data('room-no');
        var member = $('.content').data('member');
        var sock = new SockJS("/endpoint");
        var client = Stomp.over(sock);
        
        function sendmsg(){
        	var message = messageInput.val();
            if(message == ""){
            	return false;
            }
            client.send('/app/'+ roomNo, {}, JSON.stringify({
            	message: message, writer: member
            	}
            ));
            
            messageInput.val('');
        }
        
        client.connect({}, function () {
        	// 여기는 입장시
        	client.send('/app/join/'+ roomNo , {}, JSON.stringify({ writer: member})); 
//           일반메세지 들어오는곳         
            client.subscribe('/subscribe/chat/' + roomNo, function (chat) {
                var content = JSON.parse(chat.body);
                
                if(content.messageType == ""){
                	
                	chatBox.append("<li>" + content.writer + " :  <br/>" + content.message + "</li>").append('<span>' + "[보낸 시간]" + content.chatdate + "</span>" + "<br>");
                	  
                }else{
                	$('.user ul').empty();
                	
                	chatBox.append("<li>" + content.messageType + " :  <br/>" + content.message + "</li>").append('<span>' + "[보낸 시간]" + content.chatdate + "</span>" + "<br>");
                	
                	var members = content.memberList.split(",");
                	
	            	for(var i = 0; i < members.length - 1; i++){
	                	if(i == 0){
	                		$('.user ul').append('<li>' + members[i] + '<span> [ 방장 ] </span>' + '</li>');
	                	}else{
	                		$('.user ul').append('<li>' + members[i] + '</li>');
	                	}
	            		
	            	
	            	}
	            	
                }
                
                $(".chatcontent").scrollTop($(".chatcontent")[0].scrollHeight);

            });
            
        });
//         대화시
        $('.send').click(function () {
            sendmsg();
        });
        
//        나가기
        $('.roomOut').click(function(){
         
            if(member != null){
               $.ajax({
                  type : "get",
                  url : "/memberOut",
                  data :  {
                      userId : $('.roomOut').val(),
                      roomNo : roomNo
                   },// para 1/ -1
            
                  success:function(data){
                	  alert(data);
                     if(data == -1){
                    	 viewList();
                     }else{
                    	 viewList();
                     }
                     
                  }// success
               });// ajax
               
            }
     });// click
      

	function closeConnection () {
	    sock.close();
	}

	function viewList(){
	
		alert('viewList');
		var url = "/chat/chatList?page=" + page + "&perPageNum=" + perPageNum;
		location.replace(url);
	}



	$(document).keydown(function(e) {
		key = (e) ? e.keyCode : event.keyCode;
	     
	    if (key == 116 || (key == 17 && key == 82) || ((key == 17 && key == 116))) {
	        if (e) {
	            e.preventDefault();
	           var conf = confirm('해당 페이지를 벗어나시겠습니까?');
	           if(conf){
	        	   viewList();
	           }else{
	        	   return false;
	           }
	           
	        }else {
	            event.keyCode = 0;
	            event.returnValue = false;
	        }
	    }else if(key == 13){
	    	sendmsg();
	    }
	   
	});

	history.pushState(null, document.title, location.href); 
	window.addEventListener('popstate', function(event) { 
		
		history.pushState(null, null, null); 
		viewList();
	});


	window.onbeforeunload = function() {
	
		var dat;
	
		$.ajax({
				url : "/memberOut",
				cache : "false", //캐시사용금지
				method : "get",
				data : { 
					userId: $('.roomOut').val(),
					roomNo: $('.content').data('room-no')
				},
				dataType: "html",
				async : false, //동기화설정(비동기화사용안함)
				
				success:function(args){ 
					dat = args;
					location.replace("/chat/chatList?page=" + page + "&perPageNum=" + perPageNum);	
				},   
		
				error:function(e){  
					alert(e.responseText);  
				}
	
		 });	
		
		 if(dat != 1){// 방 삭제가 안됐을 때만 send
			 client.send('/app/out/' + roomNo , {}, JSON.stringify({ writer: member}));
		 }
		 
		}
	
	});



});

function isOwner(roomNo, userId){
	alert(roomNo + userId);
	 $.ajax ({
	       type:'get',
	       url:'/isOwner',
	       data: {
	    	   roomNo : roomNo,
	    	   member : userId
	    	   },
	    	   
	       success:function(data) {
	          if (data == 1) {
	             updatePw(roomNo);
	          } else {
	             alert('방장 권한이 없습니다');
	             return false;
          }   
       }
    });

}

function updatePw(roomNo) {
	var input = prompt('수정할 비밀번호를 입력하세요!');
	
	$.ajax ({
	   type:'get',
	   url:'/updatePw',
	   data:  {
		   roomNo : roomNo,
		   newPass : input
		   },
	   success:function(data) {
	      if (data == 1) {
	         alert('비밀번호가 수정되었습니다')
	      } else {
	         alert('수정에 실패하셨습니다. 다시 시도해주세요');
	      }   
	   }
	});
}