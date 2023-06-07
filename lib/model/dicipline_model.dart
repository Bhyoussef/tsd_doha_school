class Dicipline {
  String? academicYear;
  String? group;
  int? studentId;
  String? Class;
  String? titleOfSanction;
  int? iD;
  String? state;
  String? typeOfSanction;
  String? teacherImage;
  String? student;
  String? date;
  String? messageOfSanction;
  String? teacher;
  bool? isMessageRead;

  Dicipline({this.academicYear, this.group, this.studentId, this.Class, this.titleOfSanction, this.iD, this.state, this.typeOfSanction, this.teacherImage, this.student, this.date, this.messageOfSanction, this.teacher});

  Dicipline.fromJson(Map<String, dynamic> json) {
  academicYear = json['academic_year'];
  group = json['group'];
  studentId = json['student_id'];
  Class = json['class'];
  titleOfSanction = json['title_of_sanction'];
  iD = json['ID'];
  state = json['state'];
  typeOfSanction = json['type_of_sanction'];
  teacherImage = json['teacher_image'];
  student = json['student'];
  date = json['date'];
  messageOfSanction = json['message_of_sanction'];
  teacher = json['teacher'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['academic_year'] = this.academicYear;
  data['group'] = this.group;
  data['student_id'] = this.studentId;
  data['class'] = this.Class;
  data['title_of_sanction'] = this.titleOfSanction;
  data['ID'] = this.iD;
  data['state'] = this.state;
  data['type_of_sanction'] = this.typeOfSanction;
  data['teacher_image'] = this.teacherImage;
  data['student'] = this.student;
  data['date'] = this.date;
  data['message_of_sanction'] = this.messageOfSanction;
  data['teacher'] = this.teacher;
  return data;
  }
}
