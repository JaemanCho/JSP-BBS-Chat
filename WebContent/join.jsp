<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width" initial-scale="1">
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
      			<li class="active"><a href="index.jp">ホーム</a></li>
      		</ul>
      		<%
      			if(userID == null) {
    		%>
    			<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
			          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">参加する<span class="caret"></span></a>
			          <ul class="dropdown-menu">
			            <li><a href="login.jsp">ログイン</a></li>
			            <li><a href="join.jsp">新規登録</a></li>
			          </ul>
			        </li>
       			</ul>
    		<%
      			} else {
      		%>
      			<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
			          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">会員管理<span class="caret"></span></a>
			        </li>
       			</ul>
      		<% } %>
		</div>
	</nav>

	<div class="container">
		<form method="post" action="./userRegister">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="3"><h4>会員登録</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width:200px;"><h5>ID</h5></td>
						<td><input class="form-control" type="text" id="userID" name="userID" maxlength="20" placeholder="IDを入力してください"></td>
						<td style="width:200px"><button class="btn btn-primary" onclick="registerChecFunction();" type="button">重複チェック</button></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>パスワード</h5></td>
						<td colspan="2"><input onkeyup="passwordChecFunction();" class="form-control" id="userPassword1" type="password"  name="userPassword1" maxlength="20" placeholder="パスワードを入力してください"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>パスワード確認</h5></td>
						<td colspan="2"><input onkeyup="passwordChecFunction();" class="form-control" id="userPassword2" type="password"  name="userPassword2" maxlength="20" placeholder="パスワード確認を入力してください"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>お名前</h5></td>
						<td colspan="2"><input class="form-control" id="userName" type="text"  name="userName" maxlength="20" placeholder="お名前を入力してください"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>年齢</h5></td>
						<td colspan="2"><input class="form-control" id="userAge" type="number"  name="userAge" maxlength="20" placeholder="年齢を入力してください"></td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>性別</h5></td>
						<td colspan="2">
							<div class="form-group" style="text-align:center; margin:0 auto;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary active">
										<input type="radio" name="userGender" autocomplete="off" value="男性" checked>男性
									</label>
									<label class="btn btn-primary">
										<input type="radio" name="userGender" autocomplete="off" value="女性" checked>女性
									</label>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width:200px;"><h5>メールアドレス</h5></td>
						<td colspan="2"><input class="form-control" id="userEmail" type="email"  name="userEmail" maxlength="20" placeholder="メールアドレスを入力してください"></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</body>
</html>