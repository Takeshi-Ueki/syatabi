let map

// mapの初期設定
function initMap(){
  // const postLat = document.getElementById('lat').value
  // const postLong = document.getElementById('long').value

  map = new google.maps.Map(document.getElementById('map'), {
    //初期位置 latが緯度、lngが経度を示す
    center: {lat: gon.lat, lng: gon.long},
    // 表示領域の大きさ 数値は0〜21まで指定 数値が大きいほど拡大
    zoom: 12,
  });

  //positionに指定した座標にピンを表示させる
  marker = new google.maps.Marker({
    // position: {lat: 35.689009, lng: 139.700707},
    position: {lat: gon.lat, lng: gon.long},
    map: map
  });
}

window.initMap = initMap;
