let map
let geocoder
let request

// mapの初期設定
function initMap(){
  geocoder = new google.maps.Geocoder()

  map = new google.maps.Map(document.getElementById('map'), {
    //初期位置 latが緯度、lngが経度を示す
    center: {lat: gon.lat, lng: gon.long},
    // 表示領域の大きさ 数値は0〜21まで指定 数値が大きいほど拡大
    zoom: 12,
  });

  //positionに指定した座標にピンを表示させる
  marker = new google.maps.Marker({
    position: {lat: gon.lat, lng: gon.long},
    map: map
  });

  document.getElementById('search-btn').addEventListener('click', function() {
    codeAddress(geocoder, map);
  });
}

function codeAddress(geocoder, resultMap){
  // 検索フォームの入力内容を取得 id='address'
  let inputAddress = document.getElementById('address').value;

  geocoder.geocode({
    'address': inputAddress
  }, function(results, status) {
    // 該当する検索結果がヒットした時に、地図の中身を検索結果の緯度経度に更新
    if (status == 'OK') {
      let latlng = results[0].geometry.location
      map.setCenter(latlng);
      search_lat = latlng.lat();
      search_lng = latlng.lng();

      let directionsService = new google.maps.DirectionsService();
      let directionsRenderer = new google.maps.DirectionsRenderer();
      let routeTime = document.getElementById('route-time')
      let routeDistance = document.getElementById('route-distance')

      directionsRenderer.setMap(map);

      let start = new google.maps.LatLng(search_lat, search_lng);
      let end = new google.maps.LatLng(gon.lat, gon.long);

      request = {
        origin: start,
        destination: end,
        travelMode: 'DRIVING'
      };

      directionsService.route(request, function(result, status) {
        //ステータスがOKの場合、
        if (status === 'OK') {
          directionsRenderer.setDirections(result); //取得したルート（結果：result）をセット
          let duration_text = result.routes[0].legs[0].duration.text;
          let distance_text = result.routes[0].legs[0].distance.text;

          routeTime.textContent = " 約" + duration_text;
          routeDistance.textContent = distance_text;

        }else{
          alert("取得できませんでした：" + status);
        }
      });
    } else {
      alert('該当する結果がありませんでした：' + status);
    }
  });
}



window.initMap = initMap;
