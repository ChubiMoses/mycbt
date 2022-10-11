
class  DocsModel{
   int? id;
   String? firebaseId;
   String? title;
   String? code;
   String? filePath;
   int? pages;
   int? progress;


  DocsModel({
    this.firebaseId,
    this.title,
    this.code,
    this.filePath,
    this.pages,
    this.progress,
  });

  DocsModel.withId({
    this.id,
    this.firebaseId,
    this.title,
    this.code,
    this.filePath,
    this.pages,
    this.progress
  });
  
	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
    if (id != null) {	map['id'] = id;}
    map['firebaseId'] = firebaseId;
		map['title'] = title;
		map['code'] = code;
    map['filePath'] = filePath;
		map['pages'] = pages;
    map['progress'] = progress;
		return map;
	}

	// Extract a Note object from a Map object
	DocsModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.firebaseId = map['firebaseId'];
		this.title = map['title'];
		this.code = map['code'];
    this.filePath = map['filePath'];
		this.pages = map['pages'];
    this.progress = map['progress'];
  }
}









