package servlet.user;

import javabean.Base;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import utils.PingUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet implementation class Book
 */
@WebServlet("/user/device")
public class Device extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		resp.setContentType("application/json; charset=utf8");
		// 接收参数
		String limit = req.getParameter("limit");
		String page = req.getParameter("page");
		String condition = (String) req.getParameter("condition");
		String conditionValue = (String) req.getParameter("conditionValue");
		String where = ""; // 无限制条件
		if (page == null) {
			page = "1";
		}
		if (limit == null) {
			limit = "10";
		}
		// 准备查询
		Connection connection = null;
		PreparedStatement pstmt = null;
		PreparedStatement countPstmt = null;
		ResultSet resultSet = null;
		ResultSet countSet = null;
		String sql = "";
		String countSql = "";
		// 准备返回参数
		int code = 1;

		int ping_status;
		String msg = "无数据";
		int count = 0;
		int result = 0;

		JSONObject jsonData = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonResult = new JSONObject();
		// 进行查询
		try {
			connection = (Connection) Base.getConnection();
			sql = "select * from device";
			if (condition != null && conditionValue != null && !condition.equals("") && !conditionValue.equals("")) {
				where = " where " + condition + " like '%" + conditionValue + "%' ";
				sql += where;
			}
			sql += " limit ?,?";// 1 10 (1-1)*10
			pstmt = connection.prepareStatement(sql);
			pstmt.setInt(1, (Integer.parseInt(page) - 1) * Integer.parseInt(limit));
			pstmt.setInt(2, Integer.parseInt(limit));
			resultSet = pstmt.executeQuery();
			while (resultSet.next()) {
				String device_ip = resultSet.getString("ip");

				PingUtil pingUtil=new PingUtil();
				ping_status=pingUtil.ping(device_ip);
//				System.out.println(ping_status);

				String update_ip_sql = "update device_status set online_status=? where device_ip= '"+device_ip+"'";
				pstmt = connection.prepareStatement(update_ip_sql);
				pstmt.setInt(1, ping_status);
				result = pstmt.executeUpdate();


				String sql1= "select * from device_status where device_ip= '"+device_ip+"'";
				PreparedStatement pstmt1 = connection.prepareStatement(sql1);
				ResultSet rs1 = pstmt1.executeQuery();
				String online_status = "";
				String occupy_status="";
				while (rs1.next()) {
					online_status= rs1.getString("online_status");
					occupy_status=rs1.getString("occupy_status");

				}

				jsonData.put("id", resultSet.getString("id"));
				jsonData.put("name", resultSet.getString("name"));
				jsonData.put("mark", resultSet.getString("mark"));
				jsonData.put("ip", resultSet.getString("ip"));
				jsonData.put("username", resultSet.getString("username"));
				jsonData.put("password", resultSet.getString("password"));
				jsonData.put("onlinestatus",online_status);
				jsonData.put("occupystatus", occupy_status);
				jsonData.put("notes", resultSet.getString("notes"));
				jsonArray.add(jsonData);
			}
			countSql = "select count(*) as count from device ";
			countSql += where;
			countPstmt = connection.prepareStatement(countSql);
			countSet = countPstmt.executeQuery();
			if (countSet.next()) {
				count = countSet.getInt("count");
			}
			if (!jsonArray.isEmpty()) {
				code = 0;
				msg = "查询成功";
			}

		} catch (ClassNotFoundException e) {
			msg = "class没找到";
		} catch (SQLException e) {
			msg = "sql error";
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			try {
				Base.closeResource(null, pstmt, resultSet);
				Base.closeResource(connection, countPstmt, countSet);
			} catch (SQLException e) {
				msg = "关闭资源失败";
			}

		}
		// 返回数据
		jsonResult.put("code", code);
		jsonResult.put("count", count);
		jsonResult.put("msg", msg);
		jsonResult.put("data", jsonArray.toArray());
		PrintWriter out = resp.getWriter();
		out.print(jsonResult.toString());
	}

}
