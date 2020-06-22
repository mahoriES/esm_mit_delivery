import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esamudaayapp/main.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/cart/actions/cart_actions.dart';
import 'package:esamudaayapp/modules/cart/views/cart_bottom_view.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/store_details/actions/store_actions.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StoreProductListingView extends StatefulWidget {
  @override
  _StoreProductListingViewState createState() =>
      _StoreProductListingViewState();
}

class _StoreProductListingViewState extends State<StoreProductListingView>
    with TickerProviderStateMixin, RouteAware {
  TextEditingController _controller = TextEditingController();

  TabController controller;
  int _currentPosition = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    super.didPop();
  }

  @override
  void didPush() {
    super.didPush();
  }

  @override
  void didPopNext() {
    store.dispatch(UpdateProductListingDataAction(
        listingData: store.state.productState.productListingDataSource));
    super.didPopNext();
  }

  @override
  void initState() {
//    store.state.productState.selectedMerchand.categories
//        .asMap()
//        .forEach((index, a) {
//      if (a.id == store.state.productState.selectedCategory.id) {
//        _currentPosition = index + 1;
//      }
//    });
//    controller = TabController(
//      length: store.state.productState.selectedMerchand.categories.length + 1,
//      vsync: this,
//      initialIndex: _currentPosition,
//    );
    controller.addListener(() {
//      if (!controller.indexIsChanging) {
//        if (controller.index != 0) {
//          store.dispatch(UpdateSelectedCategoryAction(
//              selectedCategory: store.state.productState.selectedMerchand
//                  .categories[controller.index - 1]));
//          store.dispatch(UpdateProductListingDataAction(listingData: []));
//          store.dispatch(GetCatalogDetailsAction(
//              request: CatalogSearchRequest(
//                  categoryIDs: [store.state.productState.selectedCategory.id],
//                  merchantID:
//                      store.state.productState.selectedMerchand.merchantID)));
//        } else {
//          store.dispatch(GetCatalogDetailsAction(
//              request: CatalogSearchRequest(
//                  merchantID:
//                      store.state.productState.selectedMerchand.merchantID)));
//        }
//      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: StoreConnector<AppState, _ViewModel>(
            model: _ViewModel(),
            builder: (context, snapshot) {
              return Text(
                snapshot.selectedCategory.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
      ),
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 20),
                    child: new TextField(
                      controller: _controller,

//          autofocus: true,
                      decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search for item",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: new BorderSide(
                                color: Colors.grey,
                              ))),
                      onSubmitted: (String value) {
                        _controller.text = "";
                        snapshot.updateProductList(snapshot.productTempListing);
                      },
                      onChanged: (text) {
                        if (snapshot.productTempListing.isEmpty) {
                          snapshot.updateTempProductList(snapshot.products);
                        }
                        var filteredResult =
                            snapshot.productTempListing.where((product) {
                          return product.name
                              .toLowerCase()
                              .contains(text.toLowerCase());
                        }).toList();
                        snapshot.updateProductList(filteredResult);
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    child: TabBar(
                      isScrollable: true,
                      controller: controller,
                      labelStyle: TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      unselectedLabelStyle: TextStyle(
                          color: const Color(0xff9f9f9f),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      labelColor: Color(0xff000000),
                      unselectedLabelColor: Color(0xff9f9f9f),
                      indicator: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onTap: (index) {
                        if (index != 0) {
                          snapshot.updateProductList([]);
                        }
                      },
                      tabs: List.generate(
                        snapshot.selectedMerchant.categories.length + 1,
                        (index) => // All
                            Container(
                          height: 50,
                          child: Center(
                            child: Text(
                                index == 0
                                    ? "All"
                                    : snapshot.selectedMerchant
                                        .categories[index - 1].name,
                                textAlign: TextAlign.left),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ModalProgressHUD(
                      inAsyncCall:
                          snapshot.loadingStatus == LoadingStatus.loading,
                      opacity: 0,
                      child: TabBarView(
                        controller: controller,
//                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(
                          snapshot.selectedMerchant.categories.length + 1,
                          (index) => // All
                              ListView.separated(
                            padding: EdgeInsets.all(15),
                            itemCount: snapshot.products.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 15,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ProductListingItemView(
                                index: index,
                                imageLink: snapshot.selectedCategory.imageLink,
                                item: snapshot.products[index],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    height: snapshot.localCartListing.isEmpty ? 0 : 86,
                    duration: Duration(milliseconds: 300),
                    child: BottomView(
                      storeName: snapshot.selectedMerchant.shopName,
                      height: snapshot.localCartListing.isEmpty ? 0 : 86,
                      buttonTitle: "VIEW ITEMS",
                      didPressButton: () {
                        snapshot.navigateToCart();
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function navigateToCart;
  List<Product> products;
  LoadingStatus loadingStatus;
  List<Product> localCartListing;
  List<Product> productTempListing;
  Merchants selectedMerchant;
  Categories selectedCategory;
  Function(Product, BuildContext) addToCart;
  Function(Product) removeFromCart;
  Function(String, String) getProducts;
  Function(Categories) updateSelectedCategory;
  Function(List<Product>) updateTempProductList;
  Function(List<Product>) updateProductList;

  _ViewModel();

  _ViewModel.build(
      {this.navigateToCart,
      this.updateSelectedCategory,
      this.loadingStatus,
      this.selectedCategory,
      this.products,
      this.addToCart,
      this.removeFromCart,
      this.localCartListing,
      this.getProducts,
      this.productTempListing,
      this.updateTempProductList,
      this.updateProductList,
      this.selectedMerchant})
      : super(equals: [
          products,
          localCartListing,
          selectedMerchant,
          loadingStatus,
          productTempListing,
          selectedCategory
        ]);
  @override
  BaseModel fromStore() {
    // TODO: implement fromStore
    return _ViewModel.build(
        addToCart: (item, context) {
          dispatch(AddToCartLocalAction(product: item, context: context));
        },
        removeFromCart: (item) {
          dispatch(RemoveFromCartLocalAction(product: item));
        },
        navigateToCart: () {
          dispatch(NavigateAction.pushNamed('/CartView'));
        },
        getProducts: (categoryId, merchantId) {
          dispatch(UpdateProductListingDataAction(listingData: []));
          dispatch(GetCatalogDetailsAction(
              request: CatalogSearchRequest(
                  categoryIDs: [categoryId], merchantID: merchantId)));
        },
        updateSelectedCategory: (category) {
          dispatch(UpdateSelectedCategoryAction(selectedCategory: category));
        },
        updateTempProductList: (list) {
          dispatch(UpdateProductListingTempDataAction(listingData: list));
        },
        updateProductList: (list) {
          dispatch(UpdateProductListingDataAction(listingData: list));
        },
        productTempListing: state.productState.productListingTempDataSource,
        loadingStatus: state.authState.loadingStatus,
        selectedCategory: state.productState.selectedCategory,
//        selectedMerchant: state.productState.selectedMerchand,
        products: state.productState.productListingDataSource,
        localCartListing: state.productState.localCartItems);
  }
}

class ProductListingItemView extends StatelessWidget {
  final int index;
  final Product item;
  final String imageLink;
  const ProductListingItemView({Key key, this.index, this.item, this.imageLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          print(item.restockingAt);
          bool isOutOfStock = item.restockingAt == null ||
              item.restockingAt == "" ||
              (DateTime.fromMillisecondsSinceEpoch(
                          int.parse(item.restockingAt) * 1000))
                      .difference(DateTime.now())
                      .inSeconds <=
                  0;
          return IgnorePointer(
            ignoring: !isOutOfStock,
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(
                    left: 13,
                    right: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe7eaf0),
                        offset: Offset(0, 8),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ColorFiltered(
                        child: item.imageLink == null
                            ? Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
//                                                  height: 80,
                                    imageUrl: imageLink,
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Icon(Icons.error),
                                        )),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CachedNetworkImage(
                                    height: 500.0,
                                    fit: BoxFit.cover,
                                    imageUrl: item.imageLink,
                                    placeholder: (context, url) =>
                                        CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Image.network(
                                            imageLink,
                                          ),
                                        )),
                              ),
                        colorFilter: ColorFilter.mode(
                            !isOutOfStock ? Colors.grey : Colors.transparent,
                            BlendMode.saturation),
                      ),
                      !isOutOfStock
                          ? Positioned(
                              bottom: 5,
                              child: // Out of stock
                                  Text("Out of stock",
                                      style: const TextStyle(
                                          color: const Color(0xfff51818),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Avenir",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      textAlign: TextAlign.left))
                          : Container()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(item.name,
                            style: const TextStyle(
                                color: const Color(0xff515c6f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Avenir",
                                fontStyle: FontStyle.normal,
                                fontSize: 15.0),
                            textAlign: TextAlign.left),
                        // ₹ 55.00
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text("₹ ${item.price.toString()}",
                                    style: TextStyle(
                                        color: (!isOutOfStock
                                            ? Color(0xffc1c1c1)
                                            : Color(0xff5091cd)),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Avenir",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0),
                                    textAlign: TextAlign.left),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(item.skuSize,
                                    style: TextStyle(
                                        color: Color(0xffa7a7a7),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Avenir",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                    textAlign: TextAlign.left)
                              ],
                            ),
                            CSStepper(
                              backgroundColor: !isOutOfStock
                                  ? Color(0xffb1b1b1)
                                  : Color(0xff5091cd),
                              didPressAdd: () {
                                item.count = ((item?.count ?? 0) + 1)
                                    .clamp(0, double.nan);
                                snapshot.addToCart(item, context);
                              },
                              didPressRemove: () {
                                item.count = ((item?.count ?? 0) - 1)
                                    .clamp(0, double.nan);
                                snapshot.removeFromCart(item);
                              },
                              value: item.count == 0
                                  ? "Add "
                                  : item.count.toString(),
                            ),
                          ],
                        ),

                        // 500GMS
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class CSStepper extends StatelessWidget {
  final String value;
  final Function didPressAdd;
  final Function didPressRemove;
  final Color backgroundColor;
  const CSStepper(
      {Key key,
      this.didPressAdd,
      this.didPressRemove,
      this.value,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 73,
      decoration: BoxDecoration(
        color: this.backgroundColor ?? Color(0xff5091cd),
        borderRadius: BorderRadius.circular(100),
      ),
      child: value.contains("Add")
          ? InkWell(
              onTap: () {
                didPressAdd();
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18,
                    ),
                    Text(value,
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Avenir",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center),
                    Spacer(),
                  ],
                ),
              ),
            )
          : Row(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      didPressRemove();
                    },
                    child: Container(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 18,
                      ),
                      width: 24,
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Text(value,
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w500,
                          fontFamily: "Avenir",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      didPressAdd();
                    },
                    child: Container(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
