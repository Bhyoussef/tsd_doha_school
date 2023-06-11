class Exersice {
  String? dueDate;
  String? academicYear;
  List<AttachmentId>? attachmentId;
  int? studentId;
  String? titleOfHomework;
  String? teacher;
  String? state;
  String? video;
  String? teacherImage;
  String? student;
  String? date;
  String? group;
  int? iD;
  String? messageOfHomework;
  String? Class;

  Exersice(
      {this.dueDate,
      this.academicYear,
      this.attachmentId,
      this.studentId,
      this.titleOfHomework,
      this.teacher,
      this.state,
      this.video,
      this.teacherImage,
      this.student,
      this.date,
      this.group,
      this.iD,
      this.messageOfHomework,
      this.Class});

  Exersice.fromJson(Map<String, dynamic> json) {
    dueDate = json['Due_Date'];
    academicYear = json['academic_year'];
    if (json['attachment_id'] != null) {
      attachmentId = <AttachmentId>[];
      json['attachment_id'].forEach((v) {
        attachmentId!.add(new AttachmentId.fromJson(v));
      });
    }
    studentId = json['student_id'];
    titleOfHomework = json['title_of_homework'];
    teacher = json['teacher'];
    state = json['state'];
    video = json['video'].toString();
    teacherImage = json['teacher_image'];
    student = json['student'];
    date = json['date'];
    group = json['group'];
    iD = json['ID'];
    messageOfHomework = json['message_of_homework'];
    Class = json['class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Due_Date'] = this.dueDate;
    data['academic_year'] = this.academicYear;
    if (this.attachmentId != null) {
      data['attachment_id'] =
          this.attachmentId!.map((v) => v.toJson()).toList();
    }
    data['student_id'] = this.studentId;
    data['title_of_homework'] = this.titleOfHomework;
    data['teacher'] = this.teacher;
    data['state'] = this.state;
    data['video'] = this.video;
    data['teacher_image'] = this.teacherImage;
    data['student'] = this.student;
    data['date'] = this.date;
    data['group'] = this.group;
    data['ID'] = this.iD;
    data['message_of_homework'] = this.messageOfHomework;
    data['class'] = this.Class;
    return data;
  }
}

class AttachmentId {
  String? fileName;
  int? id;

  AttachmentId({this.fileName, this.id});

  AttachmentId.fromJson(Map<String, dynamic> json) {
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
