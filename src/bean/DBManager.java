package bean;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
/**
 * DBの接続
 * 病院一覧のメソッド
 * いかない病院を-1にsetメソッド
 * @author fei
 *
 */
public class DBManager
{

	private static String driverName = "com.mysql.jdbc.Driver";
	private static String dbPass = "jdbc:mysql://localhost:3306/";
	private static String dbName = "hew_pro";
	private static String userName = "root";
	private static String userPassword = "";
	private java.sql.Connection con;
	private java.sql.Statement st;
	private ResultSet rs;
	private PreparedStatement ps;

	/**
	 * DB接続を行うコンストラクタ
	 */
	public DBManager() {
		try
		{
			Class.forName(driverName);
			con = DriverManager.getConnection(dbPass + dbName, userName, userPassword);
			st = con.createStatement();
		} catch (SQLException e)
		{
			e.printStackTrace();
		} catch (ClassNotFoundException e)
		{
			e.printStackTrace();
		}
	}

	/**
	 * DBのクローズ処理を行う
	 */
	public void dbClose()
	{
		try
		{
			st.close();
			con.close();
		} catch (SQLException e)
		{
			e.printStackTrace();
		}
	}

	/**
	 * データベースから取得した病院情報を返す
	 * 
	 * @param sql
	 * @return
	 */
	public ArrayList<Hospital> hospital(int condi_id)
	{
		ArrayList<Hospital> hospitalList = new ArrayList<Hospital>();
		
		String sql = "select h.hospital_id,h.hospital_name,h.latitude,h.longitude from emergency_hospital eh "
				+ "inner join petient_condition pc on pc.condi_id = eh.condi_id "
				+ "inner join hospital h on eh.hospital_id = h.hospital_id "
				+ "where pc.condi_id = " + condi_id + " and eh.acceptable_flg = '1'";
		Hospital hos;
		try
		{
			rs = st.executeQuery(sql);

			while (rs.next())
			{
				hos = new Hospital();
				hos.setHospitalId(rs.getInt("h.hospital_id"));
				hos.setName(rs.getString("h.hospital_name"));
				// hos.setAddress(rs.getString("address"));
				hos.setToLatitude(rs.getString("h.latitude"));
				hos.setToLongitude(rs.getString("h.longitude"));
				hospitalList.add(hos);
			}
			rs.close();
			return hospitalList;
		} catch (SQLException e)
		{
			e.printStackTrace();
			return hospitalList;
		}
		
	}

	/**
	 * いかない病院を-1にset
	 * @param condi_id
	 * @param hospital_id
	 * @return
	 */
	public String update(int condi_id, int hospital_id)
	{
		String sql = "update emergency_hospital set acceptable_flg = '-1' " + "where condi_id = ? and hospital_id != ?";

		
		try
		{
			ps = con.prepareStatement(sql);
			ps.setInt(1, condi_id);
			ps.setInt(2, hospital_id);
			System.out.println(condi_id);
			System.out.println(hospital_id);
			ps.executeUpdate();
		} catch (SQLException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "ng";
		}
		return "ok";
	}

}
