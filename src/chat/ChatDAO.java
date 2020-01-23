package chat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ChatDAO {

	DataSource dataSource;

	public ChatDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/JSP-BBS-Chat");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	// IDでチャット内容取得
	public ArrayList<ChatDTO> getChatListByID(String fromID, String toID, String chatID) {
		ArrayList<ChatDTO> chatList = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM CHAT WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) OR chatID > ? ORDER BY chatTime";
		try {
			con = dataSource.getConnection();
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(chatID));
			rs = pstmt.executeQuery();
			chatList = new ArrayList<ChatDTO>();
			while (rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "午前";
				if(chatTime >= 12) {
					timeType = "午後";
					chatTime -=12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":" + rs.getString("chatTime").substring(14, 16) + "");
				chatList.add(chat);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(con != null) con.close();

			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}

		return chatList;
	}

	// 最新のチャット内容を指定した数だけ取得
	public ArrayList<ChatDTO> getChatListByRecent(String fromID, String toID, int number) {
		ArrayList<ChatDTO> chatList = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM CHAT WHERE ((fromID = ? AND toID = ?) OR (fromID = ? AND toID = ?)) OR chatID > (SELECT MAX(chatID) - ? FROM CHAT) ORDER BY chatTime";
		try {
			con = dataSource.getConnection();
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, number);
			rs = pstmt.executeQuery();
			chatList = new ArrayList<ChatDTO>();
			while (rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "午前";
				if(chatTime >= 12) {
					timeType = "午後";
					chatTime -=12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":" + rs.getString("chatTime").substring(14, 16) + "");
				chatList.add(chat);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(con != null) con.close();

			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}

		return chatList;
	}

	// チャット内容登録
	public int submit(String fromID, String toID, String chatContent) {
		ArrayList<ChatDTO> chatList = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "INSERT INTO CHAT VALUES (NULL, ?, ?, ?, NOW())";
		try {
			con = dataSource.getConnection();
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, chatContent);
			return pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(con != null) con.close();

			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}

		return -1;	// データベースエラー
	}
}
