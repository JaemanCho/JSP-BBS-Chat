package user;

import java.sql.Connection;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.mysql.jdbc.PreparedStatement;

public class UserDAO {

	DataSource dataSource;

	public UserDAO() {
		try {
			InitialContext initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/com/env");
			dataSource = (DataSource) envContext.lookup("jdbc/JSP-BBS-Chat");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	// ログイン
	public int login(String userID, String userPassword) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM USER WHERE userID = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = (PreparedStatement) conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("userPassword").equals(userPassword)) {
					return 1;	// ログリン成功
				}
				return 2;	// パスワード不一致
			} else {
				return 0; // 該当ユーザーが存在しない
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();

			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		// データベースエラー
		return -1;
	}

	public int registerCheck(String userID) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "SELECT * FROM USER WHERE userID = ?";
		try {
			conn = dataSource.getConnection();
			pstmt = (PreparedStatement) conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next() || userID.equals("")) {
				return 0;	// すでに存在しているユーザー
			} else {
				return 1;	// 登録可能なID
			}


		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();

			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		// データベースエラー
		return -1;
	}

	// DB登録
	public int register(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail, String userProfile) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?, ?, ?);";
		try {
			conn = dataSource.getConnection();
			pstmt = (PreparedStatement) conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, userPassword);
			pstmt.setString(3, userName);
			pstmt.setInt(4, Integer.parseInt(userAge));
			pstmt.setString(5, userGender);
			pstmt.setString(6, userEmail);
			pstmt.setString(7, userProfile);

			rs = pstmt.executeQuery();
			if(rs.next()) {
				return 0;	// すでに存在しているユーザー
			} else {
				return 1;	// 登録可能なID
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();

			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		// データベースエラー
		return -1;
	}
}
