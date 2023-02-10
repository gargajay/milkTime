class WalletModel {
  WalletModel({
      this.id, 
      this.userId, 
      this.typeId, 
      this.amount, 
      this.info, 
      this.transactionId, 
      this.verifyToken, 
      this.createdAt, 
      this.updatedAt,});

  WalletModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    typeId = json['type_id'];
    amount = json['amount'];
    info = json['info'];
    transactionId = json['transaction_id'];
    verifyToken = json['verifyToken'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  dynamic id;
  dynamic userId;
  dynamic typeId;
  dynamic amount;
  String info;
  dynamic transactionId;
  String verifyToken;
  String createdAt;
  String updatedAt;


}