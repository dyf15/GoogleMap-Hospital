<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.DBManager"%>
<%@ page import="bean.Hospital"%>
<%
	
 	//String condi_id = (String) request.getAttribute("condiId");
	int condiId = Integer.parseInt("2");
	DBManager db = new DBManager();
	//0228追加
	Hospital hos = new Hospital();
	ArrayList<Hospital> hospital = new ArrayList<Hospital>();
	db.dbClose();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" type="text/css" href="emergencyHeader.css">
<link rel="stylesheet" type="text/css" href="emergencyTop.css">
<link rel="stylesheet" href="css/reset.css" media="all">
<link rel="stylesheet" href="css/layout.css" media="all">
<link rel="stylesheet" type="text/css" href="test.css">
<script	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC4Ic696Ufkj6OpDKh3h_wjStdPC8R4qaU"></script>

<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>


<script src="http://maps.google.com/maps/api/js?sensor=true"></script>
<script src="http://raw.githubusercontent.com/HPNeo/gmaps/master/gmaps.js"></script>


<script type="text/javascript">

//行ける病院一覧

	var hos = {
	<%for (int i = 0; i < hospital.size(); i++) {%>
		
	<%=hospital.get(i).getHospitalId()%>:{
			name:'<%=hospital.get(i).getName()%>',
			toLatitude:<%=hospital.get(i).getToLatitude()%>,
			toLongitude:<%=hospital.get(i).getToLongitude()%>
			
		},
		
		<%System.out.println(i);
				System.out.println(hospital.get(i).getName());
				//System.out.println(hospital.get(i).getAddress());
				System.out.println(hospital.get(i).getToLatitude());
				System.out.println(hospital.get(i).getToLongitude());

			}%>

	};
	
	var drawId = -1;
	var isDecision = false;
	var condi_id = <%= condiId%>;
	//テスト
	console.log('テスト開始１');	
	// 一覧病院マップ表示
	function initialize(key)
	{
		//マップ表示する場所id取得
		var mapDiv = document.getElementById('map_canvas');
			
		//クラスに緯度経度の値をいれ、APIで利用
		var latlng = new google.maps.LatLng(hos[key]['toLatitude'], hos[key]['toLongitude']);
		
		//インスタンス作成
		var mapCanvas = new google.maps.Map(mapDiv,{
			center : latlng,
			zoom : 14,
			mapTypeId : google.maps.MapTypeId.ROADMAP //地図の種類
		});
		
		//マーカー
		var maeker = new google.maps.Marker({
			position : latlng,
			map : mapCanvas,
			
		});
		
		//円
		var rectangle = new google.maps.Circle({
			center : latlng, // 中心の位置座標をLatLngクラスで指定
			radius : 500, // 円の半径(メートル単位)
			map : mapCanvas, // 設置する地図キャンパス
			strokeColor : '#0088ff',// 線の色
			strokeOpacity : 0.8,//線の不透明度
			strokeWeight : 1,// 線の太さ
			fillColor : '#0088ff',//塗りつぶしの色
			fillOpacity : 0.2,//内部の不透明度

		});	
	}
	//イベント
	google.maps.event.addDomListener(window,"load",initialize);//addDomListenerを使うことで、複数初期化関数登録可能
	//テスト
	console.log('テスト開始２');	
	//本当にこの病院でいいかどうか確認するアラート
	function decision(key)
	{
		myRet = confirm(hos[key]['name'] + "にいきますか？");
		//病院を選択した後、ルート表示と病院情報出す
		if(myRet == true)
		{
			alert("緯度" + hos[key]['toLatitude'] + "経度" + hos[key]['toLongitude'] );

			var FromLatitude = '';
			var FromLongitude = '';
			
			isDecision = true;
			//現在位置を取得する
			if (navigator.geolocation)
			{
				navigator.geolocation.getCurrentPosition(
				function(position){
				FromLatitude = position.coords.latitude;
				FromLongitude = position.coords.longitude;
				var txt = "緯度："+FromLatitude+"<br />経度："+FromLongitude;
				document.getElementById("condition_insert").innerHTML = "Geo Location APIに対応していません";
				root(key,FromLatitude,FromLongitude);
				
				update(condi_id,hos[key]['id']);
				information();
				}
				);
				
			}
			else
			{
				document.getElementById("map_canvas").innerHTML = "Geo Location APIに対応していません";
			}
		
		}
		else
		{
			alert("no");
		}
	}
	//テスト
	console.log('テスト開始３');	
	//ルート表示
	   function root(key,FromLatitude,FromLongitude){

			//病院
			var ToLatitude = hos[key]['toLatitude'];
			var ToLongitude = hos[key]['toLongitude']
		
			    var map = new GMaps({
	            div: "#map_canvas",//id名
	            lat: FromLatitude,
	            lng: FromLongitude,
	            zoom: 13//縮尺
	        });
			    
	        map.drawRoute({
	          origin: [FromLatitude, FromLongitude],//出発点の緯度経度
	          destination: [ToLatitude, ToLongitude],//目標地点の緯度経度
	          travelMode: 'driving',//モード(walking,driving)
	          strokeColor: '#2ecc40',//ルートの色
	          strokeOpacity: 0.8,//ルートの透明度
	          strokeWeight: 4//ルート線の太さ
	        });
	        
	      //救急車のマーカー
	        map.addMarker({
	            lat: FromLatitude,
	            lng: FromLongitude,
	            title: '救急車の現在位置',
	            infoWindow: {
	                content: "<p>救急車の現在位置</p>"
	            }
	        });
	      
	      //病院のマーカー
	        map.addMarker({
	            lat: ToLatitude,
	            lng: ToLongitude,
	            title: hos[key]['name'],
	            infoWindow: {
	                content: "<p>" + hos[key]['name'] + "</p>"
	            }
	        });
	        var information = document.getElementById("condition_insert");
		    information.innerHTML =  "<p>" +hos[key]['name'] + "</p>";
		  	information.innerHTML += "緯度" + hos[key]['latitude']; 
		  	information.innerHTML += "経度" + hos[key]['longitude']; 
	    };
	  google.maps.event.addDomListener(window,"load",root);//addDomListenerを使うことで、複数初期化関数登録可能
		
		function repeatSelect()
		{
			if (!isDecision)
			{
				console.log('テスト');
				select(condi_id,ok);
			  	//setTimeout('time();',3*1000);
			  	
			  	console.log('テストtime');
			  	setTimeout('repeatSelect();',60*1000);
			}
			else
			{
				console.log('病院一覧の取得を停止しました');
			}
		  	
		}
	  //domツリー完成時
		$(function(){

			repeatSelect();
			console.log('domツリー構築完了');
		});
	  
		//レンダリング完了時
		$(document).ready(function(){
			console.log('レンダリング完了');
			if (drawId == -1)
			{
				drawId = 0;		
			}
			else if ( drawId != -1)
			{
				initialize(hospital[0]['hospitalId']);
			}
  
		});
		function ok(data)
		{
			var hospital = data['hospital'];
			
			

			console.log('病院一覧');
			console.log(hospital);	
				
			// 書き換え対象取得
			var element = document.getElementById("condition_insert"); 
			while (element.firstChild) element.removeChild(element.firstChild);                                 
						
			var _hos = {};
			for ( var i = 0; i < hospital.length; i++)
			{
				var tmp = {};
				tmp['id'] = hospital[i]['hospitalId'],
				tmp['name'] = hospital[i]['name'] ,
				tmp['toLatitude'] = hospital[i]['toLatitude'] ,
				tmp['toLongitude'] = hospital[i]['toLongitude'] ;
				//tmp['mileage'] = duration(tmp);

				_hos[hospital[i]['hospitalId']] = tmp;
				console.log('ここ');
				console.log(tmp);
			
			
				console.log('...');
				console.log(_hos);
				console.log(_hos[hospital[i]['hospitalId']]);
				
				console.log(hospital[i]['name']);
				console.log(hospital[i]['toLatitude']);
				console.log(hospital[i]['toLatitude']);
			}
			// _hosを昇順でソート
			
			// hosへ代入
			hos = _hos;
			
			// hosからDOMツリー生成
			//var html = 'JSで生成した病院一覧のHTML';  
			var html = '<ul>';
			
			for ( var i = 0; i < hospital.length; i++)
			{
				html += '<li><a href="#" name= ' + hos[hospital[i]["hospitalId"]]["id"] + ' onclick="initialize(name);">'+ hos[hospital[i]['hospitalId']]['name']+'</li>';  
				html += '<button name= ' + hos[hospital[i]["hospitalId"]]["id"] + ' onclick="decision(name);">この病院にいきます</button>';
			}
			html += '</ul>';
			console.log(html);
			
			
			//要素の作成
			var div = document.createElement('div');                                                            
			
			div.innerHTML = html;   
			
			//最後の子要素として追加
			element.appendChild(div);   
			
			console.log('ko : finished.')
			
			if (drawId == -1)
			{
				drawId = hospital[0]['hospitalId'];	
			}
			else if (drawId == 0)
			{
				drawId = -1;
				initialize(hospital[0]['hospitalId']);	
			}
			
		}

	/**
	 * ajaxによるリクエスト送信
	 * コールバック関数への値<json> {
	 * status  : "OK" or "NG" -> サーバー処理結果ステータス
	 * message : サーバー処理結果メッセージ
	 * data    : サーバー処理結果内容<json>
	 * }
	 * 
	 * @param button ボタンオブジェクト
	 * @param success 成功時コールバック関数
	 * @param failure 失敗時コールバック関数
	 *
	 */
	function select(condiId, success, failure) {
		// ajaxでリクエスト送信
		$.ajax({
			type        : 'POST',
			url         : 'select', // 'http://localhost:8080/hello',
			dataType    : 'json',
			contentType : 'application/json',
			mimeType    : 'application/json',
			data: JSON.stringify({
				message : 'hello world',
				condiId : condiId,
				ids     : [1,2,3]
			})
		}).done(function(result) {
			// デバッグ表示
			console.log(result);
			console.log('timeout1');
			console.log(result.message);
			
			// 通信成功
			if (result.status == 'OK'  && typeof success != 'undefined') {
				// サーバー処理成功、コールバックが指定されていれば呼び出す
				success(result);
				
				console.log('timeout2');
			} else if (result.status == 'NG' && typeof failure != 'undefined') {
				// サーバー処理失敗、コールバックが指定されていれば呼び出す
				console.log('timeout3');
				failure(result);
			}
		}).fail(function(error) {
			// 通信失敗
			alert('通信エラーが発生しました。');
		}).always(function() {
			// 後処理(finally)
			//alert('ajax処理が完了しました。');
		});
	}
	// リクエスト成功時処理
	function success(result) {
		// コンソールへ表示
		console.log(result);
		//console.log(ok());
		alert('成功処理完了');
	}
	// リクエスト失敗時処理
	function failure(result) {
		// コンソールへ表示
		console.log(result);

		alert('失敗処理完了');
	}
	
	
	
	function update(condiId, id, success, failure) {
		// ajaxでリクエスト送信
		$.ajax({
			type        : 'POST',
			url         : 'update', // 'http://localhost:8080/hello',
			dataType    : 'json',
			contentType : 'application/json',
			mimeType    : 'application/json',
			data: JSON.stringify({
				//message : 'hello world',
				
				//容体ID
				condiId : condiId,
				
				//クリックされた病院idを一番目
				ids     : [id]
			})
		}).done(function(result) {
			// デバッグ表示
			console.log(result);
			alert(result.message);
			
			// 通信成功
			if (result.status == 'OK'  && typeof success != 'undefined') {
				// サーバー処理成功、コールバックが指定されていれば呼び出す
				success(result);
			} else if (result.status == 'NG' && typeof failure != 'undefined') {
				// サーバー処理失敗、コールバックが指定されていれば呼び出す
				failure(result);
			}
		}).fail(function(error) {
			// 通信失敗
			alert('通信エラーが発生しました。');
		}).always(function() {
			// 後処理(finally)
			//alert('ajax処理が完了しました。');
		});
	}
	// リクエスト成功時処理
	function success(result) {
		// コンソールへ表示
		console.log(result);

		alert('成功処理完了');
	}
	// リクエスト失敗時処理
	function failure(result) {
		// コンソールへ表示
		console.log(result);

		alert('失敗処理完了');
	}
 </script>
</head>
<body>

	<div id="all">
		<div id="map_canvas"></div>

		<div id="condition_insert">
			
			

		</div>
	</div>

</body>
</html>
