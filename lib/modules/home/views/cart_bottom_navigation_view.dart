import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:flutter/material.dart';

class NavigationCartItem extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;
  final Widget icon;

  NavigationCartItem({Key key, this.backgroundColor, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 30.0,
              width: 30,
              child: icon,
            ),
            new Positioned(
              right: 1,
              top: 1,
              child: CartCount(builder: (context, vm) {
                return Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: vm.localCart.length == 0
                        ? Colors.transparent
                        : Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    (vm.localCart.length).toString(),
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Center(child: title),
        )
      ],
    );
  }
}

class NavigationNotificationItem extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;
  final Widget icon;

  const NavigationNotificationItem(
      {Key key, this.backgroundColor, this.title, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 30.0,
              width: 30,
              child: icon,
//              decoration: ShapeDecoration(
//                  shape: CircleBorder(
//                      side: BorderSide(width: 0.0, color: Color(0xffcbcbcb))),
//                  color: backgroundColor),
            ),
            new Positioned(
              right: 1,
              top: 1,
              child: new Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: CartCount(builder: (context, vm) {
                  return new Text(
                    "20",
//                    (vm.localCart.length).toString(),
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Center(child: title),
        )
      ],
    );
  }
}

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
  List<String> cartListDataSource;
  List<Product> localCart;
  double getCartTotal;
  Function getCartTotalPrice;
  _ViewModel();

  _ViewModel.build(
      {this.cartListDataSource,
      this.getCartTotalPrice,
      this.localCart,
      this.getCartTotal})
      : super(equals: [cartListDataSource, localCart, getCartTotal]);
  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      cartListDataSource: [], //state.productState.cartListingDataSource.items,
      localCart: state.productState.localCartItems,
      getCartTotalPrice: () {
//        if (state.productState.localCartItems.isNotEmpty) {
//          final formatCurrency = new NumberFormat.simpleCurrency(
//            name: state.productState?.localCartItems?.first?.priceCurrency ??
//                "INR",
//          );
        var total =
//              state.productState.localCartItems.fold(0, (previous, current) {
//                    double price =
//                        double.parse(current.price.toString()) * current.inCart;
//
//                    return double.parse(previous.toString()) + price;
//                  }) ??
            0.0;

//          return formatCurrency.format(total.toDouble());
//        } else {
//          return "Cart is empty";
//        }
      },
      getCartTotal: 0.0,
    );
  }
}
