# voronoi-TBS
ドコモ・バイクシェアのポートをボロノイ図に落とし、ポート距離的に移動が不便な地域を示します

## 流れ

1. https://www.google.com/maps/d/u/0/viewer?mid=1L2l1EnQJhCNlm_Xxkp9RTjIj68Q&ll=35.64795847085711%2C139.68733279646017&z=12
からマップデータをKMLでダウンロードします。(その際名前が煩雑なので今回はTBS.kmlにリネームしました)

2. kml2geojson

```
ogr2ogr -f GeoJSON TBS.geojson TBS.kml
```

3. geojson形式に変換したファイルをvoronoi.Rで分析。shp形式で書き出します。

4. shp2geojson

```
ogr2ogr -f geoJSON voronoi-TBS.geojson vornoi-TBS.shp
```

5. geojsonをleaflet.Rで可視化!


## 結果
![](https://github.com/pandorina1013/voronoi-TBS/blob/master/voronoi.png)

yey.
