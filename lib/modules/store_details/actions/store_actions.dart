import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/store_details/models/catalog_search_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/repository/cart_datasourse.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';

class GetCatalogDetailsAction extends ReduxAction<AppState> {
  final CatalogSearchRequest request;

  GetCatalogDetailsAction({this.request});
  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.getCatalogUrl,
        params: request.toJson(),
        requestType: RequestType.post);
    if (response.status == ResponseStatus.error404)
      throw UserException(response.data['message']);
    else if (response.status == ResponseStatus.error500)
      throw UserException('Something went wrong');
    else {
      var responseModel = CatalogSearchResponse.fromJson(response.data);
      var items = responseModel.catalog != null
          ? responseModel.catalog.first.products
          : responseModel.products;
      var products = items.map((f) {
        f.product.count = 0;
        return f.product;
      }).toList();

      List<Product> allCartItems = await CartDataSource.getListOfCartWith();

      products.forEach((item) {
        allCartItems.forEach((localCartItem) {
          if (item.id == localCartItem.id) {
            item.count = localCartItem.count;
          }
        });
      });
      products.sort((a, b) {
        bool aOutOfStock = a.restockingAt == null ||
            (DateTime.fromMillisecondsSinceEpoch(
                        int.parse(a.restockingAt) * 1000))
                    .difference(DateTime.now())
                    .inSeconds <=
                0;
        bool bOutOfStock = b.restockingAt == null ||
            (DateTime.fromMillisecondsSinceEpoch(
                        int.parse(b.restockingAt) * 1000))
                    .difference(DateTime.now())
                    .inSeconds <=
                0;
        return bOutOfStock.toString().compareTo(aOutOfStock.toString());
      });

      return state.copyWith(
          productState:
              state.productState.copyWith(productListingDataSource: products));
    }
  }

  @override
  FutureOr<void> before() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

    return super.before();
  }

  @override
  void after() {
    dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
    super.after();
  }
}

class UpdateSelectedCategoryAction extends ReduxAction<AppState> {
  final Categories selectedCategory;

  UpdateSelectedCategoryAction({this.selectedCategory});

  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState.copyWith(
            selectedCategory: selectedCategory,
            productListingTempDataSource: []));
  }
}

class UpdateProductListingTempDataAction extends ReduxAction<AppState> {
  final List<Product> listingData;

  UpdateProductListingTempDataAction({this.listingData});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState: state.productState
            .copyWith(productListingTempDataSource: listingData));
  }
}

class UpdateProductListingDataAction extends ReduxAction<AppState> {
  final List<Product> listingData;

  UpdateProductListingDataAction({this.listingData});
  @override
  FutureOr<AppState> reduce() {
    return state.copyWith(
        productState:
            state.productState.copyWith(productListingDataSource: listingData));
  }
}
