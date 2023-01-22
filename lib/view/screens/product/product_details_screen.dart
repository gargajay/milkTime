import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/rating_bar.dart';
import 'package:flutter_grocery/view/base/read_more_text.dart';
import 'package:flutter_grocery/view/base/title_row.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/details_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_image_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_title_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/rating_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/variation_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/web_product_information.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import 'widget/product_review.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  ProductDetailsScreen({@required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>  with TickerProviderStateMixin {
  TabController _tabController;
  int _tabIndex = 0;

  List<DaysBean> listDays = [];
  bool isDaily =false;
  bool isOneTime =true;
  bool isWeekly =false;
  bool isDays =false;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    Provider.of<ProductProvider>(context, listen: false).getProductDetails(
      context, widget.product, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    Provider.of<CartProvider>(context, listen: false).setSelect(0, false);

    listDays?.add(DaysBean(days: "Sun"));
    listDays?.add(DaysBean(days: "Mon"));
    listDays?.add(DaysBean(days: "Tue"));
    listDays?.add(DaysBean(days: "Wed"));
    listDays?.add(DaysBean(days: "Thu"));
    listDays?.add(DaysBean(days: "Fri"));
    listDays?.add(DaysBean(days: "Sat"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Variations _variation;



    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : DetailsAppBar(key: UniqueKey()),

      body: Consumer<CartProvider>(builder: (context, cart, child) {
        return  Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            double price = 0;
            int _stock = 0;
            double priceWithQuantity = 0;
            CartModel _cartModel;

            if(productProvider.product != null) {
              List<String> _variationList = [];
              for (int index = 0; index < productProvider.product.choiceOptions.length; index++) {
                _variationList.add(productProvider.product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
              }
              String variationType = '';
              bool isFirst = true;
              _variationList.forEach((variation) {
                if (isFirst) {
                  variationType = '$variationType$variation';
                  isFirst = false;
                } else {
                  variationType = '$variationType-$variation';
                }
              });

              price = productProvider.product.price;
              _stock = productProvider.product.totalStock;
              for (Variations variation in productProvider.product.variations) {
                if (variation.type == variationType) {
                  price = variation.price;
                  _variation = variation;
                  _stock = variation.stock;
                  break;
                }
              }


              _cartModel = CartModel(
                productProvider.product.id, productProvider.product.image.length > 0
                  ? productProvider.product.image[0] : '', productProvider.product.name, price,
                PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType),
                productProvider.quantity, _variation,
                (price-PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType)),
                (price-PriceConverter.convertWithDiscount(context, price, productProvider.product.tax, productProvider.product.taxType)), productProvider.product.capacity, productProvider.product.unit, _stock,productProvider.product
              );
              productProvider.setExistData(Provider.of<CartProvider>(context).isExistInCart(_cartModel));

              double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType);

              try{
                priceWithQuantity = priceWithDiscount * (productProvider.cartIndex != null ? cart.cartList[productProvider.cartIndex].quantity : productProvider.quantity);
              }catch (e){
                priceWithQuantity = priceWithDiscount;
              }
            }

            return productProvider.product != null ?
            !ResponsiveHelper.isDesktop(context) ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: ResponsiveHelper.isMobilePhone()? BouncingScrollPhysics():null,
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.WEB_SCREEN_WIDTH,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Column(children: [
                              ProductImageView(productModel: productProvider.product),

                              ProductTitleView(product: productProvider.product, stock: _stock, cartIndex: productProvider.cartIndex, isOneTime :isOneTime),

                              VariationView(product: productProvider.product),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: Row(children: [
                                  Text('${getTranslated('total_amount', context)}:', style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(PriceConverter.convertPrice(context, priceWithQuantity), style: poppinsBold.copyWith(
                                    color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
                                  )),
                                ]),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // Description


                              SizedBox(height: 0,),
                             /* Container(
                                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("I need to get it frequently", style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    SizedBox(height: 16,),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isDaily = true;
                                              isWeekly = false;
                                              isDays = false;
                                              isOneTime = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isDaily ? Theme.of(context).primaryColor : Colors.white,
                                              border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(
                                                  50.0) //                 <--- border radius here
                                              ),
                                            ),
                                            child: Text("Daily", style: TextStyle(fontSize: 12, color: !isDaily ? Theme.of(context).primaryColor : Colors.white),),
                                          ),
                                        ),
                                        SizedBox(width: 12,),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isOneTime = true;
                                              isDaily = false;
                                              isWeekly = false;
                                              isDays = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isOneTime ? Theme.of(context).primaryColor : Colors.white,
                                              border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(50.0) //                 <--- border radius here
                                              ),
                                            ),
                                            child: Text("One Time", style: TextStyle(fontSize: 12, color: !isOneTime ? Theme.of(context).primaryColor : Colors.white),),
                                          ),
                                        ),
                                        SizedBox(width: 12,),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isOneTime = false;
                                              isDaily = false;
                                              isWeekly = true;
                                              isDays = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isWeekly ? Theme.of(context).primaryColor : Colors.white,
                                              border: Border.all(width: 2.0,color: Theme.of(context).primaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(
                                                  50.0) //                 <--- border radius here
                                              ),
                                            ),
                                            child: Text("Weekly", style: TextStyle(fontSize: 12,color: !isWeekly ? Theme.of(context).primaryColor : Colors.white),),
                                          ),
                                        ),
                                        SizedBox(width: 12,),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              isOneTime = false;
                                              isDaily = false;
                                              isWeekly = false;
                                              isDays = true;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: isDays ? Theme.of(context).primaryColor : Colors.white,
                                              border: Border.all(width: 2.0,color: Theme.of(context).primaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(
                                                  50.0) //                 <--- border radius here
                                              ),
                                            ),
                                            child: Text("Select Days", style: TextStyle(fontSize: 12, color: !isDays ? Theme.of(context).primaryColor : Colors.white),),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 24,),
                                    if(isDays)
                                    SizedBox(
                                      //height: 100,
                                      child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: listDays?.length,
                                        shrinkWrap: true,
                                        // scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            child: Column(
                                              children: [
                                                Text(listDays[index].days ?? "Sun",style: TextStyle(fontSize: 14),),
                                                Checkbox(value: listDays[index].isCheck, onChanged: (value) {
                                                  setState(() {
                                                    if(listDays[index].isCheck == true) {
                                                      listDays[index].isCheck = false;
                                                    }else{
                                                      listDays[index].isCheck = true;
                                                    }
                                                  });
                                                },)
                                              ],
                                            ),
                                          );
                                        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7,
                                          childAspectRatio: .7
                                      ),),
                                    ),
                                    *//*SizedBox(height: 24,),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Start From", style: TextStyle(fontSize: 16),),
                                              SizedBox(height: 8,),
                                              Container(
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).primaryColor,
                                                      borderRadius: BorderRadius.circular(10)),
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: TextField(
                                                    // controller: emailController,
                                                    keyboardType: TextInputType.text,
                                                    cursorColor: Theme.of(context).primaryColor,
                                                    onTap: (){

                                                    },
                                                    readOnly: true,
                                                    autocorrect: true,
                                                    style: const TextStyle(

                                                      fontSize: 14,
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'From',
                                                      hintStyle: TextStyle(),
                                                      filled: true,
                                                      fillColor: Colors.transparent,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("To Data", style: TextStyle(fontSize: 16),),
                                              SizedBox(height: 8,),
                                              Container(
                                                  height: 44,
                                                  decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
                                                      borderRadius: BorderRadius.circular(10)),
                                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                                  child: TextField(
                                                    // controller: emailController,
                                                    keyboardType: TextInputType.text,
                                                    cursorColor: Theme.of(context).primaryColor,
                                                    onTap: (){

                                                    },
                                                    readOnly: true,
                                                    autocorrect: true,
                                                    style: const TextStyle(

                                                      fontSize: 14,
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'To',
                                                      hintStyle: TextStyle(
                                                          ),
                                                      filled: true,
                                                      fillColor: Colors.transparent,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )*//*
                                  ],
                                ),
                              )*/

                            ],),

                           _description(context, productProvider),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    width: 1170,
                    child: CustomButton(
                      margin: Dimensions.PADDING_SIZE_SMALL,
                      buttonText: getTranslated(productProvider.cartIndex != null ? 'already_added' : _stock <= 0 ? 'out_of_stock' : 'add_to_card', context),
                      onPressed: (productProvider.cartIndex == null && _stock > 0) ? () {
                       // var tsCart = Provider.of<CartProvider>(context).cartList.length;
                        var tsCart = Provider.of<CartProvider>(context, listen: false).cartList.length;

                          if (productProvider.cartIndex == null && _stock > 0) {

                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(_cartModel);
                            //   _key.currentState.shake();


                            showCustomSnackBar(
                                getTranslated('added_to_cart', context),
                                context, isError: false);

                           /* if(isOneTime){
                              _cartModel.type = "One Time";
                              _cartModel.days = [];
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(_cartModel);
                              //   _key.currentState.shake();


                              showCustomSnackBar(
                                  getTranslated('added_to_cart', context),
                                  context, isError: false);
                            }else{
                              if(tsCart == 0){

                                if(isDaily){
                                  _cartModel.type = "Daily";
                                  _cartModel.days = [];
                                } if(isWeekly){
                                  _cartModel.type = "Weekly";
                                  _cartModel.days = [];
                                } if(isDays){
                                  _cartModel.type = "Select Days";
                                  List<dynamic> days = [];
                                  listDays.forEach((element) {
                                    if(element.isCheck){
                                      days.add(element.days);
                                    }
                                  });
                                  _cartModel.days = days;
                                }

                                Provider.of<CartProvider>(context, listen: false)
                                    .addToCart(_cartModel);
                                //   _key.currentState.shake();


                                showCustomSnackBar(
                                    getTranslated('added_to_cart', context),
                                    context, isError: false);
                              }else{
                                showCustomSnackBar("Multiple Order available only One Time delivery option"
                                    *//*getTranslated('already_added', context)*//*,
                                    context);
                              }
                            }*/

                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('already_added', context)), backgroundColor: Colors.red,));
                            showCustomSnackBar(
                                getTranslated('already_added', context),
                                context);
                          }
                      } : null,
                    ),
                  ),
                ),

              ],
            )
                : SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: Column(children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Center(
                        child: SizedBox(
                          width: 1170,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Expanded(flex: 5, child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 350,
                                  child: Consumer<CartProvider>(
                                      builder: (context, cartProvider, child) {
                                        return FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder(context),
                                          fit: BoxFit.cover,
                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${
                                              productProvider.product.image.isNotEmpty ? productProvider.product.image[cartProvider.productSelect] : ''
                                          }',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), fit: BoxFit.cover),
                                        );
                                      }
                                  ),
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                Container(height: 100,
                                  child: productProvider.product.image != null ? ListView.builder(
                                      itemCount: productProvider.product.image.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        return Padding(
                                          padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                          child: InkWell(
                                            onTap: (){
                                              Provider.of<CartProvider>(context, listen: false).setSelect(index, true);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(Provider.of<CartProvider>(context, listen: false).productSelect == index ? 3 : 0),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Provider.of<CartProvider>(context, listen: false).productSelect == index ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),width: 1)
                                              ),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: Images.placeholder(context),
                                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${productProvider.product.image[index]}',
                                                width: 100,
                                                fit: BoxFit.cover,
                                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 100,fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        );
                                      }) : SizedBox(),)
                              ],
                            ),),
                            const SizedBox(width: 30),
                            Expanded(flex: 6,child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  productProvider.product != null ? WebProductInformation(product: productProvider.product, stock: _stock, cartIndex: productProvider.cartIndex,priceWithQuantity: priceWithQuantity) : CircularProgressIndicator(),
                                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                                  Builder(
                                    builder: (context) => Center(
                                      child: Container(
                                        width: 1170,
                                        child: CustomButton(
                                          buttonText: getTranslated(productProvider.cartIndex != null ? 'already_added' : _stock <= 0 ? 'out_of_stock' : 'add_to_card', context),
                                          onPressed: (productProvider.cartIndex == null && _stock > 0) ? () {
                                            if (productProvider.cartIndex == null && _stock > 0) {
                                              Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);

                                              showCustomSnackBar(getTranslated('added_to_cart', context),context, isError: false);

                                            } else {
                                              showCustomSnackBar(getTranslated('already_added', context), context);
                                            }
                                          } : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          ],),
                        ),
                      ),
                      //Description
                      Center(child: SizedBox(width: Dimensions.WEB_SCREEN_WIDTH,child: _description(context, productProvider))),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                    ]),
                  ),

                  FooterView(),
                ],
              ),
            )

                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          },
        );
      }),
    );
  }

  Widget _description(BuildContext context, ProductProvider productProvider) {
    return Column(children: [
      Center(child: Container(
        width: Dimensions.WEB_SCREEN_WIDTH,
        color: Theme.of(context).cardColor,
        child: TabBar(
          controller: _tabController,
          onTap: (index){
            setState(() {
              _tabIndex = index;
            });
          },
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: poppinsRegular.copyWith(
            color: Theme.of(context).disabledColor,
            fontSize: Dimensions.FONT_SIZE_SMALL,
          ),
          labelStyle: poppinsRegular.copyWith(
            fontSize: Dimensions.FONT_SIZE_SMALL,
            color: Theme.of(context).primaryColor,
          ),
          tabs: [
            Tab(text: getTranslated('description', context)),
            Tab(text: getTranslated('review', context)),
          ],
        ),
      )),


      _tabIndex == 0 ? Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        width: Dimensions.WEB_SCREEN_WIDTH,
        child: HtmlWidget(
          productProvider.product.description ?? '',
          textStyle: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
        ),
      ) :
      Column(
        children: [
          Container(
            width: 700,
            child: Column(children: [
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${productProvider.product.rating.length > 0
                      ? double.parse(productProvider.product.rating.first.average).toStringAsFixed(1) : 0.0}',
                      style: poppinsRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_MAX_LARGE,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      )),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  RatingBar(
                    rating: productProvider.product.rating.length > 0
                        ? double.parse(productProvider.product.rating[0].average)
                        : 0.0, size: 25,
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  Text(
                    '${productProvider.product.activeReviews.length} ${getTranslated('review', context)}',
                    style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Colors.deepOrange),
                  ),


                ],),

              SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                child: RatingLine(),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

            ]),
          ),
          ListView.builder(
            itemCount: productProvider.product.activeReviews.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            itemBuilder: (context, index) {

              return productProvider.product.activeReviews != null
                  ? ReviewWidget(reviewModel: productProvider.product.activeReviews[index])
                  : ReviewShimmer();
            },

          ),
        ],
      ) ,
    ],);
  }
}

class DaysBean {
  String days;
  bool isCheck = false;

  DaysBean({
    this.days,
  });
}

