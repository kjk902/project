console.log("자바스크립트 댓글 모듈");

//즉시 실행 함수
var replyService = (function() {
	
	//C
	//댓글 등록
	function add(reply, callback, error) {
		console.log("댓글 등록");
		
		//ajax
		$.ajax({
			type: "post",					//POST 통신 방식 지정 
			url: "/replies/new",			//서버로 보낼 url
			data: JSON.stringify(reply),	//서버로 보낼 데이터(문자열로 변환)
			contentType: "application/json; charset=utf-8",	//서버에 데이터를 보낼 때 JSON형식으로 보내고 문자셋은 utf-8
			
			/* 자바스크립트는 함수의 파라미터 개수를 일치시킬 필요가 없기 때문에 callback이나 error와 같은 파라미터는 필요에 따라 작성 */
			success: function(result, status, xhr) {	//HTTP 요청 성공 시
				if(callback) {
					callback(result);
				}
			},
			error: function(xhr, status, er) {		//HTTP 요청 실패 시
				if(error) {
					error(er);
				}
			}
		})
	}
	
	
	
	//R
	//특정댓글 조회
	function get(rno, callback, error) {
		
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}
	
	//댓글 목록 조회
	function getList(param, callback, error) {
		var bno = param.bno;			//게시글 번호
		var page = param.page || 1;		//페이지 번호(파라미터로 받거나 기본 1)
					
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",	//브라우저에서 JSON 포맷으로 호출
			function(data) {
				if(callback) {
					//callback(data);	//댓글 목록만 가져오는 경우
					callback(data.replyCnt, data.list);	//댓글 개수와 목록을 가져오는 경우
				}
			}).fail(function(xhr, status, err) {
				if(error) {
					error();
				}
			});	
	}
	
	//댓글 작성일, 수정일 처리
	function displayTime(timeValue) {
		
		var today = new Date();
		var gap = today.getTime() - timeValue;	//현재 시간과 작성일 또는 수정일의 시간차
		var dateObj = new Date(timeValue);
		var str = "";		
				
		var hh = dateObj.getHours();
		var mi = dateObj.getMinutes();
		var ss = dateObj.getSeconds();
		var yy = dateObj.getFullYear();
		var mm = dateObj.getMonth() + 1;	//getMonth()는 0이 시작이기 때문에 1을 더해줌
		var dd = dateObj.getDate();
					
		//시간,월,일에 0을 붙여서 두 자리씩 표시 ex.2022/01/15 09:30:05
		return [ yy, "/",
					(mm > 9 ? "":"0") + mm, "/",
					(dd > 9 ? "":"0") + dd, " ",
					(hh > 9 ? "":"0") + hh, ":",
					(mi > 9 ? "":"0") + mi, ":",
					(ss > 9 ? "":"0") + ss ].join("");
	}
	
	
	
	//U
	//댓글 수정
	function update(reply, callback, error) {
		
		console.log("댓글 번호: " + reply.rno);
		
		$.ajax({
			type: "put",					//PUT 통신 방식 지정
			url: "/replies/" + reply.rno,
			
			//댓글 수정시 댓글 내용을 JSON타입으로 전송
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			
			success: function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}

	
	
	//D
	//댓글 삭제
	//스프링 시큐리티 처리(rno와 replyer를 같이 전송)
	function remove(rno, replyer, callback, error) {
		$.ajax({
			type: "delete",					//DELETE 통신 방식 지정
			url: "/replies/" + rno,
			
			//스프링 시큐리티 처리(댓글 삭제시 댓글번호와 댓글 작성자를 JSON타입으로 전송)			
			//data : JSON.stringify({rno:rno, replyer:replyer}),
			data : JSON.stringify({rno:rno, replyer:replyer}),
			contentType : "application/json; charset=utf-8",

			success: function(deleteResult, status, xhr) {
				if(callback) {
					callback(deleteResult);
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	
	
	return {
			add: add,
			get: get,
			getList: getList,
			displayTime: displayTime,
			update: update,
			remove: remove
			};
})();
