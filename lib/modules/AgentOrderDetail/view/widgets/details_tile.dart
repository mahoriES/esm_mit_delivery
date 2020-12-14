import 'package:async_redux/async_redux.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/stringConstants.dart';
import 'package:flutter/material.dart';
import "package:esamudaayapp/utilities/sizeconfig.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsTileWidget extends StatelessWidget {
  final bool showCustomerDetails;
  const DetailsTileWidget({@required this.showCustomerDetails, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(showCustomerDetails),
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.getTitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.toHeight),
                    if (snapshot.isNameAvailable) ...[
                      Text(
                        snapshot.getName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                    if (snapshot.isContactAvailable) ...[
                      Text(
                        snapshot.getContact,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                    if (snapshot.isAddressAvailable) ...[
                      SizedBox(height: 4.toHeight),
                      Text(
                        snapshot.getAddressWithHousePrefix,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                    if (snapshot.isAddressLandmarkAvailable) ...[
                      SizedBox(height: 4.toHeight),
                      Text(
                        "Landmark : ${snapshot.getAddressLandmark}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Avenir',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 12.toWidth),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: FloatingActionButton(
                        heroTag: showCustomerDetails
                            ? "customerContactButton"
                            : "merchantCallButton",
                        onPressed: () => snapshot.makePhoneCall(
                          () => Fluttertoast.showToast(
                            msg: 'screen_support.No_contact_details_found'.tr(),
                          ),
                        ),
                        child: Image.asset('assets/images/phone.png'),
                        backgroundColor: AppColors.icColors,
                      ),
                    ),
                    SizedBox(width: 4.toWidth),
                    Flexible(
                      child: FloatingActionButton(
                        heroTag: showCustomerDetails
                            ? "dropAddressButton"
                            : "pickupAddressButton",
                        onPressed: () => snapshot.launchMaps(
                          () => Fluttertoast.showToast(
                            msg: 'screen_support.maps_error'.tr(),
                          ),
                        ),
                        child: Image.asset('assets/images/naviagtion.png'),
                        backgroundColor: AppColors.icColors,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  final bool showCustomerDetails;
  _ViewModel(this.showCustomerDetails);

  TransitDetails selectedOrder;

  _ViewModel.build({
    this.showCustomerDetails,
    this.selectedOrder,
  }) : super(equals: [selectedOrder]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      showCustomerDetails: this.showCustomerDetails,
      selectedOrder: state.homePageState.selectedOrder,
    );
  }

  String get getTitle =>
      showCustomerDetails ? tr("screen_home.drop") : tr("screen_home.pickup");

  String get getName => showCustomerDetails
      ? selectedOrder.order.customerName
      : selectedOrder.order.businessName;

  bool get isNameAvailable => getName != null;

  String get getContact => showCustomerDetails
      ? selectedOrder.customerContact
      : selectedOrder.businessContact;

  bool get isContactAvailable => getContact != null;

  String get _getAddress => showCustomerDetails
      ? selectedOrder.order.deliveryAddress?.prettyAddress
      : selectedOrder.order.pickupAddress?.prettyAddress;

  String get _getAddressHouse => showCustomerDetails
      ? selectedOrder.order.deliveryAddress?.geoAddr?.house
      : selectedOrder.order.pickupAddress?.geoAddr?.house;

  String get getAddressLandmark => showCustomerDetails
      ? selectedOrder.order.deliveryAddress?.geoAddr?.landmark
      : selectedOrder.order.pickupAddress?.geoAddr?.landmark;

  String get getAddressWithHousePrefix =>
      (_isAddressHouseAvailable ? "$_getAddressHouse, " : "") + _getAddress;

  bool get isAddressAvailable => _getAddress != null;

  bool get _isAddressHouseAvailable => _getAddressHouse != null;

  bool get isAddressLandmarkAvailable => getAddressLandmark != null;

  void launchMaps(VoidCallback showError) async {
    PickupPnt location =
        showCustomerDetails ? selectedOrder?.dropPnt : selectedOrder?.pickupPnt;
    double lat = location?.lat;
    double lon = location?.lon;

    debugPrint("launch maps with $lat $lon");

    String mapUrl = Uri.encodeFull(StringConstants.mapsUrl(lat, lon));

    bool canLaunchMap = await canLaunch(mapUrl);

    if (lat != null && lon != null && canLaunchMap) {
      await launch(mapUrl);
    } else {
      showError();
    }
  }

  void makePhoneCall(VoidCallback showError) async {
    final String _url = StringConstants.contactUrl(getContact);
    if (isContactAvailable && await canLaunch(_url)) {
      await launch(_url);
    } else {
      showError();
    }
  }
}
