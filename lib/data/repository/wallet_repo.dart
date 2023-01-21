import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/utill/app_constants.dart';


class WalletRepo {
  final DioClient dioClient;

  WalletRepo({@required this.dioClient});



  Future<ApiResponse> getWalletHistoryList() async {
    try {
      final response = await dioClient.get(AppConstants.WALLET_LIST_GET_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addWalletAmount(amount,transaction_id) async {
    try {
      final response = await dioClient.post(AppConstants.ADD_WALLET_AMOUNT_URI,
          data: {'amount' : amount, 'transaction_id':transaction_id.toString()});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
