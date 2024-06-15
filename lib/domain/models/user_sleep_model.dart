class UserSleep {
  String? scheduledSleepTime;
  String? scheduledWakeUpTime;
  List<double> days=[0,0,0,0,0,0,0];
  DateTime? sleptAt;

  UserSleep({this.scheduledSleepTime, this.scheduledWakeUpTime, required this.days,this.sleptAt});

  UserSleep.fromJson(Map<String, dynamic> json) {
    scheduledSleepTime = json['SleepTime'];
    scheduledWakeUpTime = json['WakeUpTime'];
    days = json['Days'] ==null? [0,0,0,0,0,0,0]:json['Days'].cast<double>();
    sleptAt = json['sleptAt'] == null?null:DateTime.parse(json['sleptAt']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SleepTime'] = scheduledSleepTime;
    data['WakeUpTime'] = scheduledWakeUpTime;
    data['Days'] = days;
    data['sleptAt'] = sleptAt?.toIso8601String();
    return data;
  }
}
