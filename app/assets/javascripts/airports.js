
function makeMap() {
	// initialize the map on the "map" div with a given center and zoom
	L.mapbox.accessToken = $('body').data('mapboxToken');
	var map = L.mapbox.map('map', 'mapbox.streets')
		.setView([39.045753, -76.641273], 9);

	// Create a feature layer with the map_data GeoJSON
	var featureLayer = L.mapbox.featureLayer()
		.loadURL('/airports/map_data.json')
		.addTo(map);

	// featureLayer.getBounds() returs the corners of the furthest-out
	// markers.map.fitBounds() makes sure the map contains these.
	featureLayer.on('ready', function(e) {
		map.fitBounds(featureLayer.getBounds());
	});
}