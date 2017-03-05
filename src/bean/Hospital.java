package bean;

/**
 * 容体ID,病院情報など扱っている情報
 * @author fei
 *
 */
public class Hospital
{
	// 病院情報
	private int hospitalId = 0;
	private int condiId = 0;
	private String name = "";
	private String tel = "";
	private String pref = "";
	private String address = "";
	private String toLatitude = "";
	private String toLongitude = "";

	// 救急車要請時の緯度経度
	private String fromLatitude = "";
	private String fromLongitude = "";
	
	//所要時間
	private int time = 0;

	//容体ID
	public int getCondiId()
	{
		return condiId;
	}

	public void setCondiId(int condiId)
	{
		this.condiId = condiId;
	}

	// 病院ID
	public int getHospitalId()
	{
		return hospitalId;
	}

	public void setHospitalId(int hospitalId)
	{
		this.hospitalId = hospitalId;
	}

	//病院名前
	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	//病院電話
	public String getTel()
	{
		return tel;
	}

	public void setTel(String tel)
	{
		this.tel = tel;
	}

	//都道府県
	public String getPref()
	{
		return pref;
	}

	public void setPref(String pref)
	{
		this.pref = pref;
	}

	//住所
	public String getAddress()
	{
		return address;
	}

	public void setAddress(String address)
	{
		this.address = address;
	}

	//病院緯度経度
	public String getToLatitude()
	{
		return toLatitude;
	}

	public void setToLatitude(String toLatitude)
	{
		this.toLatitude = toLatitude;
	}

	public String getToLongitude()
	{
		return toLongitude;
	}

	public void setToLongitude(String toLongitude)
	{
		this.toLongitude = toLongitude;
	}

	//救急車緯度経度
	public String getFromLatitude()
	{
		return fromLatitude;
	}

	public void setFromLatitude(String fromLatitude)
	{
		this.fromLatitude = fromLatitude;
	}

	public String getFromLongitude()
	{
		return fromLongitude;
	}

	public void setFromLongitude(String fromLongitude)
	{
		this.fromLongitude = fromLongitude;
	}

	// 所要時間
	public int getTime()
	{
		return time;
	}

	public void setTime(int time)
	{
		this.time = time;
	}

}
