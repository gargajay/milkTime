class UserInfoModel {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  int isPhoneVerified;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String emailVerificationToken;
  String phone;
  String cmFirebaseToken;
  String loginMedium;
  String self_ref_code;
  dynamic ref_amount;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.isPhoneVerified,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.cmFirebaseToken,
        this.loginMedium,
        this.self_ref_code,
        this.ref_amount,
      });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    self_ref_code = json['self_ref_code'];
    ref_amount = json['ref_amount'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    loginMedium = '${json['login_medium'] ?? ''}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_verification_token'] = this.emailVerificationToken;
    data['phone'] = this.phone;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['login_medium'] = this.loginMedium;
    data['self_ref_code'] = this.self_ref_code;
    data['ref_amount'] = this.ref_amount;
    return data;
  }
}
