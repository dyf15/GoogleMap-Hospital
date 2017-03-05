/**
 *  Ajax update
 */
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import bean.DBManager;
import bean.Hospital;
import net.arnx.jsonic.JSON;

/**
 * Servlet implementation class UpdateTime
 */
@WebServlet(name="UpdateTime", urlPatterns={"/update/*"})
public class UpdateTime extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateTime() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		//容体id
		//TODO int condiId = Integer.parseInt(request.getParameter("condiId"));
		//テスト(0228変更)
		
		
		
		
		// JSONリクエストの読み込み
				BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
				String json = br.readLine();
				
				// JSONレスポンス作成
				JsonResult result = new JsonResult();

				// リクエストの解析
				if (!json.isEmpty()) {
					// JSONデータをJsoParamクラスにマッピング
					JsonParam param = JSON.decode(json, JsonParam.class);

					// デバッグ用受信パラメータ表示
					System.out.println("message : " + param.getMessage());
					
					for (String id : param.getIds()) {
						System.out.println("病院ID : " + id);
					}
					DBManager db = new DBManager();
					
					// 病院一覧取得
					{
						
						result.setHospital(db.hospital(param.getCondiId()));
						
					}
					

					// 応答内容(OK)
					result.setStatus("OK");
					result.setMessage("hello, " + "message : " + param.getMessage());
					Hospital hos = new Hospital();
					hos.setHospitalId(Integer.parseInt(param.getIds().get(0)));
					result.setHospital(new ArrayList<Hospital>() {
						{ add(hos); }
					});
					
					
					//テスト(0228変更)
					db.update(param.getCondiId(), hos.getHospitalId());	
					db.dbClose();
					

					
				} else {
					// 応答内容(NG)
					result.setStatus("NG");
					result.setMessage("パラメーターが受け取れません。");
				}

				// リクエストへの応答
				response.setContentType("application/json; charset=utf-8");
				response.setHeader("Access-Control-Allow-Origin", "http://localhost");

				response.getWriter().print(JSON.encode(result));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	
	/**
	 * JSON受信パラメーター格納クラス
	 */
	class JsonParam
	{
		/** メッセージ */
		private String message;
		/** 病院ID一覧(0番目の要素が選択された病院) */
		private ArrayList<String> ids;

		private int condiId = 0;

		/**
		 * 容体idを取得
		 * @return
		 */
		public int getCondiId()
		{
			return condiId;
		}
		public void setCondiId(int condiId)
		{
			this.condiId = condiId;
		}

		/**
		 * メッセージ を取得する
		 * @return
		 */
		public String getMessage()
		{
			return message;
		}
		/**
		 * メッセージ を設定する
		 * @param message
		 */
		public void setMessage(String message)
		{
			this.message = message;
		}
		public ArrayList<String> getIds()
		{
			return ids;
		}
		public void setIds(ArrayList<String> ids)
		{
			this.ids = ids;
		}
	}
	
	/**
	 * JSON送信パラメーター格納クラス
	 */
	class JsonResult
	{
		/** ステータス : OK or NG */
		private String status;
		/** メッセージ : 任意 */
		private String message;
		/** 病院一覧 */
		private List<Hospital> hospital;
		
		/**
		 * ステータス を取得する
		 * @return
		 */
		public String getStatus()
		{
			return status;
		}
		/**
		 * ステータス を設定する
		 * @param status ステータス(OK or NG)
		 */
		public void setStatus(String status)
		{
			this.status = status;
		}
		
		/**
		 * メッセージ を取得する
		 * @return
		 */
		public String getMessage()
		{
			return message;
		}
		/**
		 * メッセージ を設定する
		 * @param message メッセージ(任意)
		 */
		public void setMessage(String message)
		{
			this.message = message;
		}
		public List<Hospital> getHospital()
		{
			return hospital;
		}
		public void setHospital(List<Hospital> hospital)
		{
			this.hospital = hospital;
		}
	}
}
