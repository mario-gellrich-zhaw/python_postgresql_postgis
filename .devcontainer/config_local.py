# Esri World Gray Canvas, generally available without an API key.
DEFAULT_GEOMETRY_VIEWER_PROVIDER = {
    "url": "https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}",
    "name": "Esri World Gray Canvas",
    "crs": "EPSG:3857",
    "attribution": "Tiles &copy; Esri",
    "max_zoom": 16,
}

# Previous provider: OpenTopoMap.
# DEFAULT_GEOMETRY_VIEWER_PROVIDER = {
#     "url": "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
#     "name": "Topography",
#     "crs": "EPSG:3857",
#     "attribution": "&copy; <a href=\"https://www.openstreetmap.org/copyright\" target=\"_blank\">OpenStreetMap</a> contributors, &copy; <a href=\"https://opentopomap.org\" target=\"_blank\">OpenTopoMap</a>",
#     "max_zoom": 17,
# }