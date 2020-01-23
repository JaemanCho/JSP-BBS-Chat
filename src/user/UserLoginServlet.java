package user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		String userPassword = request.getParameter("userPassword");

		// 入力有無チェック
		if(
			userID == null || userID.equals("") ||
			userPassword == null || userPassword.equals("")
		) {
			request.getSession().setAttribute("messageType", "エラーメッセージ");
			request.getSession().setAttribute("messageContent", "すべての内容を入力してください。");
			response.sendRedirect("login.jsp");
			return;
		}

		// ログイン
		int result = new UserDAO().login(userID, userPassword);

		if(result == 1) {
			request.getSession().setAttribute("userID", userID);
			request.getSession().setAttribute("messageType", "成功メッセージ");
			request.getSession().setAttribute("messageContent", "ログインに成功しました。");
			response.sendRedirect("index.jsp");
			return;
		} else if(result == 2) {
			request.getSession().setAttribute("messageType", "エラーメッセージ");
			request.getSession().setAttribute("messageContent", "パスワードをご確認ください。");
			response.sendRedirect("login.jsp");
			return;
		} else if(result == 0) {
			request.getSession().setAttribute("messageType", "エラーメッセージ");
			request.getSession().setAttribute("messageContent", "存在しないIDです。");
			response.sendRedirect("login.jsp");
			return;
		} else if(result == -1) {
			request.getSession().setAttribute("messageType", "エラーメッセージ");
			request.getSession().setAttribute("messageContent", "データベースエラーが発生しました。");
			response.sendRedirect("login.jsp");
			return;
		}

	}

}
