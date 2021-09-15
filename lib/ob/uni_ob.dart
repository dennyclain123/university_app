class UniOb {
  String country;
  // Null stateProvince;
  List<String> webPages;
  String alphaTwoCode;
  String name;
  List<String> domains;

  UniOb(
      {this.country,
        // this.stateProvince,
        this.webPages,
        this.alphaTwoCode,
        this.name,
        this.domains});

  UniOb.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    // stateProvince = json['state-province'];
    webPages = json['web_pages'].cast<String>();
    alphaTwoCode = json['alpha_two_code'];
    name = json['name'];
    domains = json['domains'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    // data['state-province'] = this.stateProvince;
    data['web_pages'] = this.webPages;
    data['alpha_two_code'] = this.alphaTwoCode;
    data['name'] = this.name;
    data['domains'] = this.domains;
    return data;
  }
}
