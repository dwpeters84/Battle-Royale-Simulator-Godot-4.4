extends PanelContainer

@onready var changebg = %ChangeBgImage
@onready var bg = %BgPreview

var areaname: String
var links: Array
var tags: Array
var items: Array

@onready var area_info = {
	"name": areaname,
	"links": [links],
	"tags": [tags],
	"items": [items],
	}
