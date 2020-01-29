<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
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

		UserDTO user = new UserDAO().getUser(userID);
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
      			<li><a href="find.jsp">友達検索</a></li>
      			<li><a href="box.jsp">メッセージボックス<span id="unread" class="label label-info"></span></a></li>
      		</ul>

      			<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
			          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">会員管理<span class="caret"></span></a>
			          <ul class="dropdown-menu">
			          	<li class="active"><a href="update.jsp">会員情報編集</a></li>
						<li><a href="profileUpdate.jsp">プロファイル編集</a></li>
			            <li><a href="logoutAction.jsp">ログアウト</a></li>
			          </ul>
			        </li>
       			</ul>

		</div>
	</nav>

	<div class="container">
		<form method="post" action="./userUpdate">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="2"><h4>会員情報編集</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width:200px;"><h5>ID</h5></td>
						<td><h5><%= userID %></h5>
						<input type="hidden" name="userID" value="<%= userID %>" /></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>パスワード</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" id="userPassword1" type="password"  name="userPassword1" maxlength="20" placeholder="パスワードを入力してください"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>パスワード確認</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" id="userPassword2" type="password"  name="userPassword2" maxlength="20" placeholder="パスワード確認を入力してください"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>お名前</h5></td>
						<td colspan="2"><input class="form-control" id="userName" type="text"  name="userName" maxlength="20" placeholder="お名前を入力してください" value="<%= user.getUserName() %>"></td>
					<tr>
						<td style="width:200px;"><h5>年齢</h5></td>
						<td colspan="2"><input class="form-control" id="userAge" type="number"  name="userAge" maxlength="20" placeholder="年齢を入力してください"value="<%= user.getUserAge() %>"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>性別</h5></td>
						<td colspan="2">
							<div class="form-group" style="text-align:center; margin: 0 auto;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary  <% if(user.getUserGender().equals("男性")) out.print("active"); %>">
										<input type="radio" name="userGender" autocomplete="off" value="男性" <% if(user.getUserGender().equals("男性")) out.print("checked"); %>>男性
									</label>
									<label class="btn btn-primary <% if(user.getUserGender().equals("女性")) out.print("active"); %>">
										<input type="radio" name="userGender" autocomplete="off" value="女性" <% if(user.getUserGender().equals("女性")) out.print("checked"); %>>女性
									</label>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>メールアドレス</h5></td>
						<td colspan="2"><input class="form-control" id="userEmail" type="email"  name="userEmail" maxlength="20" placeholder="メールアドレスを入力してください" value="<%= user.getUserEmail() %>"></td>
					</tr>
					<tr>
						<td	style="text-align: left;" colspan="3">
							<h5 style="color: red" id="passwordCheckMassage"></h5>
							<input class="btn btn-primary pull-right" type="submit" value="登録" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
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

	function passwordCheckFunction() {
		var userPassword1 = $('#userPassword1').val();
		var userPassword2 = $('#userPassword2').val();
		if(userPassword1 != userPassword2) {
			$('#passwordCheckMassage').html('パスワードが一致しません。');
		} else {
			$('#passwordCheckMassage').html('');
		}
	}
	</script>

	</body>
</html>