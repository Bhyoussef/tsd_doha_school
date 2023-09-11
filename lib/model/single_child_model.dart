class ChildModel {
  String? academicYear;
  String? lastName;
  String? parent;
  bool? activePayment;
  String? nameAr;
  Notif? notif;
  String? lastNameAr;
  String? schoolCode;
  String? Class;
  String? group;
  String? name;
  String? birthdateStudent;
  int? classId;
  int? studentId;
  String? admissionDate;
  String? companyId;
  int? parentId;
  String? gender;
  String? ref;
  String? image;

  ChildModel(
      {this.academicYear,
      this.lastName,
      this.parent,
      this.activePayment,
      this.nameAr,
      this.notif,
      this.lastNameAr,
      this.schoolCode,
      this.Class,
      this.group,
      this.name,
      this.birthdateStudent,
      this.classId,
      this.studentId,
      this.admissionDate,
      this.companyId,
      this.parentId,
      this.gender,
      this.ref,
      this.image});

  ChildModel.fromJson(Map<String, dynamic> json) {
    academicYear = json['academic_year'];
    lastName = json['last_name'];
    parent = json['parent'];
    activePayment = json['active_payment'];
    nameAr = json['name_ar'];
    notif = json['notif'] != null ? new Notif.fromJson(json['notif']) : null;
    lastNameAr = json['last_name_ar'];
    schoolCode = json['school_code'];
    //Class = json['class'];
    group = json['group'];
    name = json['name'];
    birthdateStudent = json['birthdate_student'];
    //classId = json['class_id'];
    studentId = json['student_id'];
    admissionDate = json['Admission_Date'];
    companyId = json['company_id'];
    parentId = json['parent_id'];
    gender = json['gender'];
    ref = json['ref'];
    image = json['image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['academic_year'] = this.academicYear;
    data['last_name'] = this.lastName;
    data['parent'] = this.parent;
    data['active_payment'] = this.activePayment;
    data['name_ar'] = this.nameAr;
    if (this.notif != null) {
      data['notif'] = this.notif!.toJson();
    }
    data['last_name_ar'] = this.lastNameAr;
    data['school_code'] = this.schoolCode;
    //data['class'] = this.Class;
    data['group'] = this.group;
    data['name'] = this.name;
    data['birthdate_student'] = this.birthdateStudent;
    //data['class_id'] = this.classId;
    data['student_id'] = this.studentId;
    data['Admission_Date'] = this.admissionDate;
    data['company_id'] = this.companyId;
    data['parent_id'] = this.parentId;
    data['gender'] = this.gender;
    data['ref'] = this.ref;
    data['image'] = this.image;
    return data;
  }
}

class Notif {
  int? discipline;
  int? exercice;

  Notif({this.discipline, this.exercice});

  Notif.fromJson(Map<String, dynamic> json) {
    discipline = json['discipline'];
    exercice = json['exercice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discipline'] = this.discipline;
    data['exercice'] = this.exercice;
    return data;
  }
}
