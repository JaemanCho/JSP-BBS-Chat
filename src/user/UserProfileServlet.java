package user;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		String savePath = request.getRealPath("/upload").replaceAll("\\\\", "/");
		try {
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());

		} catch (Exception e) {
			request.getSession().setAttribute("messageType", "エラーメッセージ");
			request.getSession().setAttribute("messageContent", "ファイルサイズ10MBまでです。");
			response.sendRedirect("profleUpdate.jsp");
			return;
		}
		String userID = multi.getParameter("userID");
		HttpSession session = request.getSession();
		if(!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "エラーメッセージ");
			session.setAttribute("messageContent", "アクセスできません。");
			response.sendRedirect("index.jsp");
			return;
		}

		String fileName = "";
		File file = multi.getFile("userProfile");
		if(file != null) {
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif")) {
				String prev = new UserDAO().getUser(userID).getUserProfile();
				File preFile = new File(savePath + "/" + prev);
				// 過去のファイル削除
				if(preFile.exists()) {
					preFile.delete();
				}
				fileName = file.getName();
			} else {
				if(file.exists()) {
					file.delete();
				}
				request.getSession().setAttribute("messageType", "エラーメッセージ");
				request.getSession().setAttribute("messageContent", "イメージファイルのみアップロードできます。");
				response.sendRedirect("profleUpdate.jsp");
				return;
			}
		}
		new UserDAO().profile(userID, fileName);
		request.getSession().setAttribute("messageType", "成功メッセージ");
		request.getSession().setAttribute("messageContent", "プロファイル編集に成功しました。");
		response.sendRedirect("index.jsp");
		return;

	}

}
