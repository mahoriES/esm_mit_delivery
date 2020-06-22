import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/home/models/merchant_response.dart';
import 'package:esamudaayapp/modules/material_search/material_search.dart';
import 'package:esamudaayapp/modules/search/actions/search_actions.dart';
import 'package:esamudaayapp/modules/search/models/models.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/user_manager.dart';
import 'package:flutter/material.dart';

class ProductSearchView extends StatefulWidget {
  @override
  _ProductSearchViewState createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
          model: _ViewModel(),
          builder: (context, snapshot) {
            return MaterialSearch<Merchants>(
              //placeholder of the input and of the search bar text input
              placeholder: tr('screen_search.search'),

              getResults: (String criteria) async {
                snapshot.searchProduct(criteria);
                return snapshot.searchResults
                    .map((item) => new MaterialSearchResult<Merchants>(
                          value: item, //The value must be of type <String>
                          icon: Icons.search,
                          merchants: item,
                        ))
                    .toList();
              },

              onSelect: (dynamic selected) {
                if (selected == null) {
                  //user closed the MaterialSearch without selecting any value
                  return;
                }
                snapshot.navigateToDetailsPage(selected);
              },
            );
          }),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function(String) searchProduct;
  Function(Merchants) navigateToDetailsPage;
  List<Merchants> searchResults;
  _ViewModel();
  _ViewModel.build(
      {this.searchProduct, this.searchResults, this.navigateToDetailsPage})
      : super(equals: [searchResults]);
  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      searchResults: state.productState.searchResults,
      searchProduct: (query) async {
        var user = await UserManager.userDetails();
        dispatch(SearchAction(
            searchRequest:
                SearchRequest(phoneNumber: user.phone, searchQuery: query)));
      },
      navigateToDetailsPage: (merchant) {
//        dispatch(UpdateSelectedMerchantAction(selectedMerchant: merchant));
        dispatch(NavigateAction.pushNamed('/StoreDetailsView'));
      },
    );
  }
}
