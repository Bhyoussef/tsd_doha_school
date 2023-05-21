class Message {
  String? academicYear;
  String? group;
  List<Attachments>? attachments;
  int? studentId;
  String? titleOfMessage;
  String? teacher;
  String? state;
  String? teacherImage;
  String? student;
  String? date;
  String? message;
  String? Class;
  int? iD;

  Message({this.academicYear, this.group, this.attachments, this.studentId, this.titleOfMessage, this.teacher, this.state, this.teacherImage, this.student, this.date, this.message, this.Class, this.iD});

  Message.fromJson(Map<String, dynamic> json) {
  academicYear = json['academic_year'];
  group = json['group'];
  if (json['attachments'] != null) {
  attachments = <Attachments>[];
  json['attachments'].forEach((v) { attachments!.add(new Attachments.fromJson(v)); });
  }
  studentId = json['student_id'];
  titleOfMessage = json['title_of_message'];
  teacher = json['teacher'];
  state = json['state'];
  teacherImage = json['teacher_image'];
  student = json['student'];
  date = json['date'];
  message = json['message'];
  Class = json['class'];
  iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['academic_year'] = this.academicYear;
  data['group'] = this.group;
  if (this.attachments != null) {
  data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
  }
  data['student_id'] = this.studentId;
  data['title_of_message'] = this.titleOfMessage;
  data['teacher'] = this.teacher;
  data['state'] = this.state;
  data['teacher_image'] = this.teacherImage;
  data['student'] = this.student;
  data['date'] = this.date;
  data['message'] = this.message;
  data['class'] = this.Class;
  data['ID'] = this.iD;
  return data;
  }
}

class Attachments {
  String? fileName;
  int? id;

  Attachments({this.fileName, this.id});

  Attachments.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['id'] = this.id;
    return data;
  }
}
