class TimeTable {
  String? salle;
  String? academicYear;
  String? group;
  String? observation;
  String? companyName;
  String? startTime;
  String? period;
  String? Class;
  String? endTime;
  String? teacher;
  String? day;
  String? subject;

  TimeTable(
      {this.salle,
      this.academicYear,
      this.group,
      this.observation,
      this.companyName,
      this.startTime,
      this.period,
      this.Class,
      this.endTime,
      this.teacher,
      this.day,
      this.subject});

  TimeTable.fromJson(Map<String, dynamic> json) {
    salle = json['salle'];
    academicYear = json['academic_year'];
    group = json['group'];
    observation = json['observation'];
    companyName = json['company_name'];
    startTime = json['start_time'];
    period = json['period'];
    //Class = json['class'];
    endTime = json['end_time'];
    teacher = json['teacher'];
    day = json['day'];
    subject = json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salle'] = this.salle;
    data['academic_year'] = this.academicYear;
    data['group'] = this.group;
    data['observation'] = this.observation;
    data['company_name'] = this.companyName;
    data['start_time'] = this.startTime;
    data['period'] = this.period;
    //data['class'] = this.Class;
    data['end_time'] = this.endTime;
    data['teacher'] = this.teacher;
    data['day'] = this.day;
    data['subject'] = this.subject;
    return data;
  }
}
