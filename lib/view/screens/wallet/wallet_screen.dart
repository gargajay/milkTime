import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/provider/wallet_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;

class WalletScreen extends StatefulWidget {
  const WalletScreen({key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  TextEditingController amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
      context.read<WalletProvider>().getWalletList(context)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? PreferredSize(
              child: WebAppBar(), preferredSize: Size.fromHeight(120))
              : CustomAppBar(title: getTranslated('wallet', context)),
          body:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("Total Balance")),
                        Text("₹ 50")
                      ],
                    ),
                    SizedBox(height: 16,),
                    Container(
                      padding: const EdgeInsets.all(0),
                      child:  TextField(
                        controller: amount,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(), hintText: "Amount (₹5000)")
                      ),
                    ),
                    SizedBox(height: 16,),
                    GestureDetector(
                      onTap: (){
                        var amountValue = amount.text.toString().trim();
                        if(amountValue == ""){
                          showCustomSnackBar("Please add your amount", context,isError: true);
                        }else if(int.parse(amountValue) > 5000){
                          showCustomSnackBar("There is a strict limit of ₹5000", context,isError: true);
                        }else{
                          // payment gateway hit hare
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:  BorderRadius.circular(32),
                        ),
                        child:Align(child: Text("Add Money", style: TextStyle(fontSize: 14, color: Theme.of(context).cardColor),)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height*0.6),
                      child: value.walletList != null ? ListView.builder(
                          itemCount: value.walletList?.length ?? 0,
                          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 350, vertical: 20) :  EdgeInsets.zero,
                          //physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {

                            return InkWell(
                              onTap: () {
                                /* showDialog(context: context, builder: (BuildContext context) {
                                // return NotificationDialog(notificationModel: notificationProvider.notificationList[index]);
                              });*/
                              },
                              hoverColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                    /*decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),*/
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [

                                            // SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                                            Expanded(
                                              child: ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                       "${value.walletList[index].transactionId != null   ? "#"+value.walletList[index].transactionId.toString() :  "Amount"}   (₹${value.walletList[index].amount})" ??"#4343434",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: poppinsBold.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                                      ),
                                                    ),
                                                    Text(
                                                       "${getTime(value.walletList[index].updatedAt)}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: poppinsLight.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                                        color: Theme.of(context).hintColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(value.walletList[index].info ?? "Add Money",
                                                  style: poppinsLight.copyWith(
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            //  SizedBox(width: 10),
                                          ],
                                        ),
                                        Container(height: 1, color: ColorResources.getGreyColor(context).withOpacity(.2))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }) : SizedBox(),
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getTime(savedDateString) {
    if (savedDateString == null) return "";
    DateTime tempDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(savedDateString);
    String date = DateFormat("dd/MM/yyyy").format(tempDate);
    return date;
  }
}
