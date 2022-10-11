
class  QuizModel{
  int? id;
  String? firebaseId;
  String? subject;
  String? category;
  String? code;
  String? school;
  String? course;
  String? year;
  String? question;
  String? answer;
  String? option1;
  String? option2;
  String? option3;
  String? image;


  QuizModel({
    this.id,
    this.firebaseId,
    this.subject,
    this.code,
    this.category,
    this.school,
    this.course,
    this.year,
    this.question,
    this.answer,
    this.option1,
    this.option2,
    this.option3,
    this.image,
  });

  QuizModel.withId({
    this.id,
    this.firebaseId,
    this.subject,
    this.code,
    this.category,
    this.school,
    this.course,
    this.year,
    this.question,
    this.answer,
    this.option1,
    this.option2,
    this.option3,
    this.image,
  });

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {
		var map = Map<String, dynamic>();
    if (id != null) {map['id'] = id;}
    map['firebaseId'] = firebaseId;
		map['subject'] = subject;
		map['code'] = code;
    map['category'] = category;
		map['school'] = school;
    map['course'] = course;
    map['year'] = year;
		map['question'] = question;
    map['answer'] = answer;
		map['option1'] = option1;
    map['option2'] = option2;	
    map['option3'] = option3;
    map['image'] = image;
		return map;
	}

	// Extract a Note object from a Map object
	QuizModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.firebaseId = map['firebaseId'];
		this.subject = map['subject'];
		this.code = map['code'];
    this.category = map['category'];
		this.school = map['school'];
    this.course = map['course'];
    this.year = map['year'];
		this.question = map['question'];
		this.answer = map['answer'];
    this.option1 = map['option1'];
		this.option2 = map['option2'];
    this.option3 = map['option3'];
    this.image = map['image'];
  }
}









