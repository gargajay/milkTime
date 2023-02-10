import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/data/model/response/wallet_model.dart';
import 'package:flutter_grocery/data/model/response/wishlist_model.dart';
import 'package:flutter_grocery/data/repository/wallet_repo.dart';
import 'package:flutter_grocery/data/repository/wishlist_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';

class WalletProvider extends ChangeNotifier {
  final WalletRepo walletRepo;

  WalletProvider({@required this.walletRepo});

  List<WalletModel> _walletList;

  List<WalletModel> get walletList => _walletList;

  // Product _product;
  // Product get product => _product;
  //List<int> _wishIdList = [];
  //List<int> get wishIdList => _wishIdList;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /*void addToWishList(Product product, BuildContext context) async {
    _wishList.add(product);
    _wishIdList.add(product.id);
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo.addWishList([product.id]);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      showCustomSnackBar(getTranslated('item_added_to', context), context,isError: false);
    } else {
      _wishList.remove(product);
      _wishIdList.remove(product.id);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, BuildContext context) async {
    _wishList.remove(product);
    _wishIdList.remove(product.id);
    notifyListeners();
    ApiResponse apiResponse = await wishListRepo.removeWishList([product.id]);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      showCustomSnackBar(getTranslated('item_removed_from', context), context,isError: false);
    } else {
      _wishList.add(product);
      _wishIdList.add(product.id);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }*/

  Future<void> getWalletList(BuildContext context) async {
    _isLoading = true;
    _walletList = [];
    ApiResponse apiResponse = await walletRepo.getWalletHistoryList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _walletList = [];
      apiResponse.response.data.forEach((category) => _walletList.add(WalletModel.fromJson(category)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addWalletAmount(BuildContext context, amount, trans) async {
    ApiResponse apiResponse = await walletRepo.addWalletAmount(amount, trans);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      showCustomSnackBar("Added balance sucessfully", context,isError: false);
      //apiResponse.response.data.forEach((category) => _walletList.add(WalletModel.fromJson(category)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

}
