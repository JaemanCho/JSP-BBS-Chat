<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}

	String toID = null;
	if(request.getParameter("toID") != null) {
		toID = request.getParameter("toID");
	}

	if(userID == null) {
		session.setAttribute("messageType", "エラーメッセージ");
		session.setAttribute("messageContent", "ログインしてください。");
		response.sendRedirect("index.jsp");
		return;
	}

	if(toID== null) {
		session.setAttribute("messageType", "エラーメッセージ");
		session.setAttribute("messageContent", "チャット相手が選択されていません。");
		response.sendRedirect("index.jsp");
		return;
	}

	if(userID.equals(URLDecoder.decode(toID, "UTF-8"))) {
		session.setAttribute("messageType", "エラーメッセージ");
		session.setAttribute("messageContent", "自分にはチャットができません。");
		response.sendRedirect("index.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>会員制チャットシステム</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</head>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			 <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
		        <span class="sr-only">Toggle navigation</span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
     		</button>
     		<a class="navbar-brand" href="index.jsp">会員制チャットサービス</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      		<ul class="nav navbar-nav">
      			<li><a href="index.jsp">ホーム</a></li>
      			<li><a href="find.jsp">友達検索</a></li>
      			<li><a href="box.jsp">メッセージボックス<span id="unread" class="label label-info"></span></a></li>
      		</ul>
      		<%
      			if(userID != null) {
      		%>
      			<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
			          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">会員管理<span class="caret"></span></a>
			          <ul class="dropdown-menu">
			            <li><a href="logoutAction.jsp">ログアウト</a></li>
			          </ul>
			        </li>
       			</ul>
      		<% } %>
		</div>
	</nav>

	<div class="container bootstrap snippet">
		 <div class="row">
		 	<div class="col-xs-12">
		 		<div class="portlet portlet-default">
		 			<div class="portlet-heading">
			 			<div class="portlet-title">
			 				<h4><i class="fa fa-circle text-green"></i> Live チャット</h4>
			 			</div>
			 			<div class="clearfix"></div>
			 		</div>
				 	<div id="chat" class="panel-collapse collapse in">
				 		<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height: 600px;">
				 		</div>
				 		<div class="portlet-footer">
				 			<div class="row" style="height: 90px;">
				 				<div class="form-group col-xs-10">
				 					<textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="メッセージを入力してください。"></textarea>
				 				</div>
				 				<div class="form-group col-xs-2">
				 					<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">送信</button>
				 					<div class="clearfix"></div>
				 				</div>
				 			</div>
				 		</div>
				 	</div>
			 	</div>
		 	</div>
		 </div>

	 	<div class="alert alert-success" id="successMessage" style="display: none;">
			<strong>メッセージ送信が成功しました。</strong>
		</div>
		<div class="alert alert-danger" id="dangerMessage" style="display: none;">
			<strong>お名前と内容を入力してください。</strong>
		</div>
		<div class="alert alert-warning" id="warningMessage" style="display: none;">
			<strong>データベースエラーは発生しました。</strong>
		</div>
	</div>



	<%
		String messageContent = null;
		if(session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}

		String messageType = null;
		if(session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}

		if(messageContent != null) {

	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("エラーメッセージ")) out.println("panel-warning"); else out.println("panel-success"); %>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title"><%= messageType %></h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">確認</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div>
	</div><!-- /.modal -->
	<script>
		$('#messageModal').modal('show');
	</script>
	<%
			session.removeAttribute("messageContent");
			session.removeAttribute("messageType");
		}
	%>

<script type="text/javascript">
	// alert効果処理
	function autoClosingAlert(selector, delay) {

		var alert = $(selector).alert();

		alert.show();

		window.setTimeout(function(){
			alert.hide();
		}, delay);
	}

	// 送信処理
	function submitFunction() {
		var fromID = '<%= userID %>';
		var toID = '<%= toID %>';
		var chatContent = $('#chatContent').val();

		$.ajax({
			type: 'POST',
			url: './chatSubmitServlet',
			data: {
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				chatContent: encodeURIComponent(chatContent)
			},
			success: function(result) {
				if(result == 1) {
					autoClosingAlert('#successMessage', 2000);
					chatListFunction(lastID);
				} else if(result == 0) {
					autoClosingAlert('#dangerMessage', 2000);
				} else {
					autoClosingAlert('#warningMessage', 2000);
				}
			}
		});
		$('#chatContent').val('');
	}

	// チャット内容の読み込み処理
	var lastID = 0;
	function chatListFunction(type) {
		var fromID = '<%= userID %>';
		var toID = '<%= toID %>';

		$.ajax({
			type: 'POST',
			url: './chatListServlet',
			data: {
				fromID: encodeURIComponent(fromID),
				toID: encodeURIComponent(toID),
				listType: type
			},
			success: function(data) {
				if(data == "") return;
				var parsed = JSON.parse(data);
				var result = parsed.result
				if(lastID != Number(parsed.last)) {
					$('#chatList').html('');
					for (var i = 0; i < result.length; i++) {
						if(result[i][0].value == fromID) {
							result[i][0].value = '私';
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
				}
				lastID = Number(parsed.last);
			}
		});
	}

	// チャット内容のレイアウト作成
	function addChat(chatName, chatContent, chatTime) {
		$("#chatList").append(
			'<div class="row">' +
			'<div class="col-lg-12">' +
			'<div class="media">' +
			'<a class="media-left" href="#">' +
			'<img class="media-object img-circle" style="width: 30px; height: 30px" src="images/icon.png">' +
			'</a>' +
			'<div class="media-body">' +
			'<h4 class="media-heading">' +
			chatName +
			'<span class="small pull-right">' +
			chatTime +
			'</span>' +
			'</h4>' +
			'<p>' +
			chatContent +
			'</p' +
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'<hr>');
		$('#chatList').scrollTop($('#chatList').get(0).scrollHeight);
	}
	// 3秒ごとにメッセージを読み込む
	function getInfiniteChat() {
		setInterval(function() {
			chatListFunction(lastID);
		}, 3000);
	}

	// ページ読み込み時メッセージを読み込む
	$(document).ready(function() {
		getUnread();
		chatListFunction('0');
		getInfiniteChat();
		getInfiniteUnread();
	});

	function getUnread() {
		$.ajax({
			type: 'POST',
			url: './chatUnread',
			data: {
				userID: encodeURIComponent('<%= userID %>'),
			},
			success: function(result) {
				if (result >= 1) {
					showUnread(result);
				} else {
					showUnread('');
				}
			}
		});
	}

	function getInfiniteUnread() {
		setInterval(function() {
			getUnread();
		}, 4000);
	}

	function showUnread(result) {
		$('#unread').html(result);
	}
</script>
</body>
</html>