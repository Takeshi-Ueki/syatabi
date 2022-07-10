let map
let geocoder
let marker = null

// mapの初期設定
function initMap(){
  geocoder = new google.maps.Geocoder()
  // const postLat = document.getElementById('lat').value
  // const postLong = document.getElementById('long').value

  map = new google.maps.Map(document.getElementById('map'), {
    //初期位置 latが緯度、lngが経度を示す
    center: {lat: 35.689009, lng: 139.700707},
    // 表示領域の大きさ 数値は0〜21まで指定 数値が大きいほど拡大
    zoom: 12,
  });

  map.addListener('click', function(e){
    deleteMakers();
    map.panTo(e.latLng);
    getAddress(e.latLng);
  })

  // positionに指定した座標にピンを表示させる
  marker = new google.maps.Marker({
    // position: {lat: 35.689009, lng: 139.700707},
    position: {lat: gon.lat, lng: gon.long},
    map: map
  });
}


// 検索フォームのボタンが押されたときに実行
function codeAddress(){
  // 検索フォームの入力内容を取得 id='address'
const inputAddress = document.getElementById('address').value;

  geocoder.geocode({
    'address': inputAddress
  }, function(results, status) {
    // 該当する検索結果がヒットした時に、地図の中身を検索結果の緯度経度に更新
    if (status == 'OK') {
      map.setCenter(results[0].geometry.location);

          marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location
      });
    } else {
      alert('該当する結果がありませんでした：' + status);
    }
  });
}

function getAddress(latlng) {
  geocoder.geocode({
    latLng: latlng
  }, function(results,status) {
    if(status == 'OK') {
      if(results[0].geometry){
        // deleteMakers();
        post_lat.value = latlng.lat();
        post_long.value = latlng.lng();

       marker = new google.maps.Marker({
          map: map,
          position: latlng
        });
      }
    }
  })
}

function deleteMakers() {
	if(marker != null){
		marker.setMap(null);
	}
	marker = null;
}

window.initMap = initMap;
