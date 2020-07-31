class ApiModel {
  int timeUpdate;
  int totalCase;
  int todayCase;
  int death;
  int todayDeath;
  int recovered;
  int todayRecovered;
  int active;
  int critical;
  ApiModel({
    this.timeUpdate,
    this.totalCase,
    this.todayCase,
    this.death,
    this.todayDeath,
    this.recovered,
    this.todayRecovered,
    this.active,
    this.critical,
  });
  ApiModel.fromJson(Map<String, dynamic> json)
      : timeUpdate = json['updated'],
        totalCase = json['cases'],
        todayCase = json['todayCases'],
        death = json['deaths'],
        todayDeath = json['todayDeaths'],
        recovered = json['recovered'],
        todayRecovered = json['todayRecovered'],
        active = json['active'],
        critical = json['critical'];
}
