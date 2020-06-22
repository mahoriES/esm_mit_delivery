import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/address/models/addess_models.dart';
import 'package:esamudaayapp/redux/actions/general_actions.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/URLs.dart';
import 'package:esamudaayapp/utilities/api_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddressAction extends ReduxAction<AppState> {
  final Address request;

  AddAddressAction({this.request});

  @override
  FutureOr<AppState> reduce() async {
    var response = await APIManager.shared.request(
        url: ApiURL.addressUrl,
        params: request.toJson(),
        requestType: RequestType.post);

    if (response.status == ResponseStatus.success200) {
//      AuthResponse authResponse = AuthResponse.fromJson(response.data);
//      UserManager.saveToken(token: authResponse.customer.customerID);
//      var user = User(
//        id: authResponse.customer.customerID,
//        firstName: authResponse.customer.name,
//        address: authResponse.customer.addresses.isEmpty
//            ? ""
//            : authResponse.customer.addresses.first.addressLine1,
//        phone: authResponse.customer.phoneNumber,
//      );
//      UserManager.saveUser(user).then((onValue) {
//        store.dispatch(GetUserFromLocalStorageAction());
//      });

    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      //throw UserException(response.data['status']);
    }
    return null;
  }

  void before() => dispatch(ChangeLoadingStatusAction(LoadingStatus.loading));

  void after() => dispatch(ChangeLoadingStatusAction(LoadingStatus.success));
}
