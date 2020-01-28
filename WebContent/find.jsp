<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		if(userID == null) {
			session.setAttribute("messageType", "エラーメッセージ");
			session.setAttribute("messageContent", "ログインしてください。");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
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
      			<li class="active"><a href="find.jsp">友達検索</a></li>
      			<li><a href="box.jsp">メッセージボックス<span id="unread" class="label label-info"></span></a></li>
      		</ul>
      		<%
      			if(userID != null) {
      		%>
      			<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
			          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">会員管理<span class="caret"></span></a>
			          <ul class="dropdown-menu">
			          	<li><a href="update.jsp">会員情報編集</a></li>
			            <li><a href="logoutAction.jsp">ログアウト</a></li>
			          </ul>
			        </li>
       			</ul>
      		<% } %>
		</div>
	</nav>
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
			<thead>
				<tr>
					<th colspan="3"><h4>友達検索</h4></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width:200px;"><h5>ID</h5></td>
					<td><input class="form-control" type="text" id="findID" name="findID" maxlength="20" placeholder="IDを入力してください"></td>
				</tr>
				<tr>
					<td	style="text-align: left;" colspan="2">
						<input class="btn btn-primary pull-right" onclick="findFunction()" type="submit" value="検索" />
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
		</table>
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

	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							確認メッセージ
						</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">確認</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div>
	</div><!-- /.modal -->

	<script type="text/javascript">
		// 友達検索
		function findFunction() {
			var userID = $('#findID').val();

			$.ajax({
				type: 'POST',
				url: './UserRegisterCheckServlet',
				data: {
					userID: userID
				},
				success: function(result) {
					if(result == 0) {
						$('#checkMessage').html('友達を見つけました。');
						$('#checkType').attr('class', 'modal-content panel-success');
						getFriend(userID);
					} else {
						$('#checkMessage').html('友達がいません。');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();
					}
					$('#checkModal').modal('show');
				}
			});
		}

		// 検索結果表示
		function getFriend(findID) {
			$('#friendResult').html(
				'<thead>' +
				'<tr>' +
				'<th><h4>検索結果</h4></th>' +
				'</tr>' +
				'</thead>' +
				'<tbody>' +
				'<tr>' +
				'<td style="text-align; center;"><h3>' + findID + '</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">チャットする</a></td>' +
				'</tr>' +
				'</tbody>'
			);
		}

		// 検索結果削除
		function failFriend() {
			$('#friendResult').html('');
		}
	</script>
	<script type="text/javascript">
	<%
		if(userID != null) {
	%>

	$(document).ready(function() {
		getUnread();
		getInfiniteUnread();
	});

	<% } %>
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