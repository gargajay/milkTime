class SignUpModel {
  String fName;
  String lName;
  String phone;
  String email;
  String password;
  String ref_code;

  SignUpModel({this.fName, this.lName, this.phone, this.email='', this.password, this.ref_code});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    ref_code = json['ref_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['ref_code'] = this.ref_code;
    return data;
  }
}
