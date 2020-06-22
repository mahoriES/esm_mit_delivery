import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartCount extends StatelessWidget {
  final Function(BuildContext context, _ViewModel count) builder;

  CartCount({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: builder,
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Product> cartListDataSource;
  List<Product> localCart;
  double getCartTotal;
  Function getCartTotalPrice;
  VoidCallback navigateToCart;
  _ViewModel();

  _ViewModel.build(
      {this.cartListDataSource,
      this.getCartTotalPrice,
      this.navigateToCart,
      this.localCart,
      this.getCartTotal})
      : super(equals: [cartListDataSource, localCart, getCartTotal]);
  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      cartListDataSource: [], //state.productState.cartListingDataSource.items,
      localCart: state.productState.localCartItems,
      navigateToCart: () {
        dispatch(NavigateAction.pushNamed('/CartView'));
      },
      getCartTotalPrice: () {
        if (state.productState.localCartItems.isNotEmpty) {
          final formatCurrency = new NumberFormat.simpleCurrency(
            name: "INR",
          );
          var total =
              state.productState.localCartItems.fold(0, (previous, current) {
                    double price =
                        double.parse(current.price.toString()) * current.count;

                    return double.parse(previous.toString()) + price;
                  }) ??
                  0.0;

          return formatCurrency.format(total.toDouble());
        } else {
          return "Cart is empty";
        }
      },
      getCartTotal: 0.0,
    );
  }
}

class BottomView extends StatefulWidget {
  final String storeName;
  final String buttonTitle;
  final VoidCallback didPressButton;
  final double height;
  const BottomView({
    Key key,
    this.storeName,
    this.didPressButton,
    this.buttonTitle,
    this.height,
  }) : super(key: key);

  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          return Container(
            height: widget.height,
            padding: EdgeInsets.only(
              left: 16,
              right: 14,
            ),
//                    margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x65e7eaf0),
                  offset: Offset(0, -8),
                  blurRadius: 15,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CartCount(builder: (context, snapshot) {
                    return Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          // TOTAL
                          Text("TOTAL",
                              style: const TextStyle(
                                  color: const Color(0xff515c6f),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "JosefinSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0),
                              textAlign: TextAlign.left),

                          // ₹ 55.00
                          Text(snapshot.getCartTotalPrice(),
                              style: const TextStyle(
                                  color: const Color(0xff515c6f),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "JosefinSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0),
                              textAlign: TextAlign.left),
                          // Organic Store
                          Text(widget.storeName ?? "",
                              style: const TextStyle(
                                  color: const Color(0xff727c8e),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Avenir",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.left)
                        ],
                      ),
                    );
                  }),
                ),
                InkWell(
                  onTap: () {
                    widget.didPressButton();
                  },
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      height: 46,
                      width: widget.buttonTitle == 'VIEW ITEMS' ? 120 : 160,
                      decoration: BoxDecoration(
                        color: Color(0xff5091cd),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.buttonTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
