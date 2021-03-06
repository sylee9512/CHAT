<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<jsp:include page ="/WEB-INF/views/common/header.jsp" flush="false" />
<script>
function checkPersonnel(roomNo, roomPw, result) {
	  /* 	alert(typeof roomNo + roomPw + result); */

	   $.ajax ({
	      type:'get',
	      url:'/checkPersonnel',
	      data: {
	    	  roomNo : roomNo
	      },
	      success:function(data) {
	    	  /* alert(data); */
	         if (data >= 6) {
	            alert("방 인원이 꽉 찼습니다");
	            return false;
	         } else {
	        	 alert(!result + data );
	            if (!result) {
	               check(roomNo, roomPw);
	            } else {
	            	submitForm(roomNo);
	            }
	        }
         }
      });
   }

	
function check(roomNo, roomPw){
	/* alert(roomNo + "roomPw" + roomPw); */
	
	var input = prompt('패스워드를 입력하세요 > ');
	if(input == roomPw){
		alert("일치함");
		
		submitForm(roomNo);
	}else{
		alert("패스워드가 일치하지 않습니다.");
		return false;
	}
}

function submitForm(roomNo){
	

	$("#subNo").val(roomNo);
	$("#formByNo").submit();
}

</script>
<style>
	body{
		overflow: hidden;
	}
	#header li a{
		color:#3d3d3d;
	}
	
	#header li a:hover{
		color:#adadad;
	}
	
	.wrap{
		text-align: center;
		
		position: absolute;
		top: 120px;
	}
	
	.wrap h2{
		margin: 20px auto;
	}
	
	.table{	
		width: 80%;
		margin: 0 auto;
		text-align: center;
	}
	.table, tr, td, th{
		border: 1px solid #3d3d3d;
		border-collapse:collapse;
		
	}
	
	thead tr{
		height: 40px;
	}
	
	tbody tr{
		height: 34px;
	}
	
	button{
		width:50%;
		text-align: center;
		
		color:#fff;
		background-color: #3d3d3d;
		
		border: 0;
		height: 25px;
	}
	
	tfoot tr{
		height: 36px;
	}
	
	.wrap_table{
		width: 89%;
		overflow:hidden;
		position:absolute;
		top: 160px;
		left:5%;
	}
	
	.text-center{
	
		margin-top:10px;
	}
	.pagination{
		width: 60%;
		margin: 0 auto;
		
		text-align: center;
	}
	.pagination li{
		display: inline-block;
		padding: 10px 5px 0 5px;
	}
	
	.cre{
		float:right;
	
		width: 120px;
		height: 30px;
		
		padding-top:10px;
		margin-right: 10%;
		
		text-align: center;
		border: 1px solid #ededed;
	}
	
	.cre a:hover{
		text-decoration: none;
		color: #aeaeae;
	}
	
	.thead{
		color: #fff;
		background-color: #3d3d3d;
	}
</style>
</head>
<body>
	<form action="/chat/enterRoom" method="post" id="formByNo">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<input type="hidden" id="subNo" name="roomNo" />
		<input type="hidden" value='${pageMaker.cri.page }'/>
		<input type="hidden" value='${pageMaker.cri.perPageNum }'/>
	</form>
	
		<div class="wrap_table">
			<table class="table">
			   <tr class="thead">
			      <th>방 이름</th>
			      <th>방 타입</th>
			      <th>생성 시간</th>
			      <th>입장</th>
			   </tr>
			   
			   <c:forEach items="${roomList}" var="room">
			      <tr>
			         <td>${room.roomName}</td>
			         <td>${room.roomType}</td>
			         <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${room.reg_date}" /></td>
			     
			         <c:choose>
			         	<c:when test="${room.roomPw == ''}">
			         		<td><button type="button" onclick="return checkPersonnel(${room.roomNo}, ${room.roomNo}, true)">방 입장하기</button></td>
			         	</c:when>
			         	<c:otherwise>
			         		<td><button type="button" id="btn_enter" onclick="return checkPersonnel(${room.roomNo}, ${room.roomPw}, false)" >방 입장하기</button></td>
			         	</c:otherwise>
			        </c:choose>
			      </tr>
			   </c:forEach><!-- 룸 리스트 -->
			</table>
	
	
		
			<div class="text-center">
				<ul class="pagination">	
					<c:if test="${pageMaker.prev}">
						<li><a href="/chat/chatList?page=${pageMaker.startPage - 1}&perPageNum=${pageMaker.cri.perPageNum}">&laquo;</a></li>
					</c:if>
					
					<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
						<li class="page-item" <c:out value="${pageMaker.cri.page == idx ? 'class=active' : ''}"/>>
							<a href="/chat/chatList?page=${idx}&perPageNum=${pageMaker.cri.perPageNum}">${idx}</a>
						</li>
					</c:forEach>
			
					<c:if test="${pageMaker.next}">
						<li><a href="/chat/chatList?page=${pageMaker.endPage + 1}&perPageNum=${pageMaker.cri.perPageNum}">&raquo;</a></li>
					</c:if>
				</ul>
				<div class="cre"><a href="/chat/createRoom">방 만들기</a></div>
		</div><!-- text-center꺼 -->
		
  		
	</div>
</body>
</html>