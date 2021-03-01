<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<div class="form-group">
					<label>Bno</label> <input class="form-control" name='bno'
						value='<c:out value="${board.bno}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Title</label> <input class="form-control" name='title'
						value='<c:out value="${board.title}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Text Area</label> <input class="form-control" name='content'
						value='<c:out value="${board.content}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Writer</label> <input class="form-control" name='writer'
						value='<c:out value="${board.writer}"/>' readonly="readonly">
				</div>

				<button data-oper='modify' class="btn btn-default">Modify</button>
				<button data-oper='list' class="btn btn-info">List</button>

				<form id='operForm' action="/board/modify" method="get">
					<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
					<input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
				</form>
			</div>
			<!-- /.panel-body -->
		</div>
		<div class="row">
			<div class="col-lg-12">
				<!-- pannel -->
				<div class="panel panel-default">
					<div class = "panel-heading">
						<i class="fa fa-comments fa-fw"></i> Reply
						<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
					</div>
					
					<!-- ./panel-heading -->
					<div class="panel-body">
						<ul class="chat">
							<!-- start reply -->
							<li class="left clearfix" data-rno='12'>
								<div>
									<div class="header">
										<strong class="primary-font">user00</strong>
										<small class="pull-right text-muted">2021-02-28 15:34</small>
									</div>
									<p>Good job!!</p>
								</div>
							</li>
						</ul>
					</div><!-- panel body end -->
					<div class="panel-footer">
					
					</div>
				</div>
				
	  <!-- Modal -->
      <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
        aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal"
                aria-hidden="true">&times;</button>
              <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label>Reply</label> 
                <input class="form-control" name='reply' value='New Reply!!!!'>
              </div>      
              <div class="form-group">
                <label>Replyer</label> 
                <input class="form-control" name='replyer' value='replyer'>
              </div>
              <div class="form-group">
                <label>Reply Date</label> 
                <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
              </div>
            </div>
      <div class="modal-footer">
              <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
              <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
              <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
              <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
            </div>          </div>
                <!-- /.modal-content -->
              </div>
              <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
			</div>
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
		showList(1);
		
		function showList(page){
			console.log("show list " + page);
			replyService.getList({bno:bnoValue, page:page||1}, function(replyCnt, list){
				console.log("replyCnt: " + replyCnt);
				console.log("list: " + list);
				
				if(page==-1){
					pageNum = Math.ceil(replyCnt/10.0); //전체댓글갯수 파악
					showList(pageNum); // 재호출(마지막페이지를가지고)
					return;
				}
				var str="";
				if(list==null || list.length==0){
					replyUL.html("");
					return;
				}
				for(var i=0, len = list.length||0; i<len; i++){
					str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
					str += "<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
					str += "<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
					str += "<p>"+list[i].reply+"</p></div></li>";
				}
				replyUL.html(str);
				showReplyPage(replyCnt);
			});
		}
		//댓글페이지로직Start
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt){
			console.log("임승배 확인값: " + pageNum);
			var endNum = Math.ceil(pageNum/10.0)*10;
			var startNum = endNum-9;
			
			var prev = startNum !=1;
			var next = false;
			
			if(endNum*10>=replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
			if(endNum*10<replyCnt){
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";
			if(prev){
				str+= "<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>"
			}
			for(var i = startNum; i<=endNum; i++){
				var active = pageNum ==i? "active":"";
				str+="<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			if(next){
				str+="<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
			}
			str += "</ul></div>";
			console.log(str);
			replyPageFooter.html(str);
		}
		replyPageFooter.on("click", "li a", function(e){
			e.preventDefault();
			console.log("page click");
			
			var targetPageNum = $(this).attr("href");
			
			console.log("targetPageNum: " + targetPageNum);
			pageNum = targetPageNum;
			showList(pageNum);
		});
		//댓글페이지로직End
		
		//모달로직Start
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		//
		$("#addReplyBtn").on("click", function(e){
			modal.find("input").val("");
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id!='modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			$(".modal").modal("show");
		});
		//모달 새로운 댓글처리
		modalRegisterBtn.on("click", function(e){
			var reply = {
					reply:modalInputReply.val(),
					replyer:modalInputReplyer.val(),
					bno:bnoValue
			};
			replyService.add(reply, function(result){
					alert("result: " + result);
					modal.find("input").val("");
					modal.modal("hide");
					
					showList(-1);
				});
		})
		//x
		$(".chat").on("click", "li", function(e){
			var rno = $(this).data("rno");
			replyService.get(rno, function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id !='modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				$(".modal").modal("show");
			})
		})
		//get모달창에서 댓글수정
		modalModBtn.on("click", function(e){
			var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
			console.log("ssssssssssssss"+modalInputReply.val());
			
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			})
		})
		//get모달창에서 댓글삭제
		modalRemoveBtn.on("click", function(e){
			var rno = modal.data("rno");
			
			replyService.remove(rno, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
	});
	$(document).ready(function() {
		var operForm = $("#operForm");
		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});

		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list")
			operForm.submit();
		});
	});
	
</script>

<%@include file="../includes/footer.jsp"%>
