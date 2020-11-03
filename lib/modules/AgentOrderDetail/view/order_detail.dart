import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/action/order_action.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/view/image_view.dart';
import 'package:esamudaayapp/presentations/confirm_dialogue.dart';
import 'package:esamudaayapp/presentations/loading_widget.dart';
import 'package:esamudaayapp/presentations/status_icon.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final picker = ImagePicker();
  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);

    return formatDate(
        todayDate, [dd, ' ', M, ' ', yyyy, ' ', hh, ':', nn, ' ', am]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
      ),
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        onInit: (store) async {
          String _status = store.state.homePageState.selectedOrder.status;
          if (_status == OrderStatusStrings.pending ||
              _status == OrderStatusStrings.accepted) {
            store.dispatch(GetOrderDetailsAction());
          } else {
            store.dispatch(GetTransitDetailsAction());
          }
        },
        builder: (context, snapshot) {
          String status = snapshot.selectedOrder.status;
          return snapshot.loadingStatus == LoadingStatus.loading
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              spreadRadius: 0,
                            )
                          ],
                          color: const Color(0xffffffff),
                        ),
                        padding: EdgeInsets.all(20.toFont),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            StatusIcon(
                              snapshot.selectedOrder.status,
                              snapshot.selectedOrder.order.orderStatus,
                              hasStatusName: false,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 8.toWidth),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${tr("screen_home.Order_ID")} ${snapshot.selectedOrder.order.orderShortNumber},',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.toFont,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  Text(
                                    convertDateFromString(
                                        snapshot.selectedOrder.order.created),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.toFont,
                                      fontFamily: 'Avenir',
                                    ),
                                  ),
                                  if (snapshot.selectedOrder.order
                                              .orderStatus ==
                                          OrderStatusStrings.orderCompleted &&
                                      status ==
                                          OrderStatusStrings.accepted) ...[
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: tr("screen_home.Completed"),
                                            style: TextStyle(
                                              color: Color(0xff505050),
                                              fontSize: 12,
                                              fontFamily: 'Avenir',
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          TextSpan(
                                            text: convertDateFromString(snapshot
                                                .selectedOrder.order.created),
                                            style: TextStyle(
                                              color: Color(0xff959595),
                                              fontSize: 12,
                                              fontFamily: 'CircularStd-Book',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${tr('screen_home.Distance')} ',
                                          style: TextStyle(
                                            color: Color(0xff505050),
                                            fontSize: 12,
                                            fontFamily: 'Avenir',
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        TextSpan(
                                          // TODO : dynamic distace
                                          text: ': 2 km',
                                          style: TextStyle(
                                            color: Color(0xff959595),
                                            fontSize: 12,
                                            fontFamily: 'CircularStd-Book',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Rs.${snapshot.selectedOrder.order.orderTotal}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                Text(
                                  snapshot.selectedOrder.order.orderItems !=
                                          null
                                      ? snapshot.selectedOrder.order.orderItems
                                              .length
                                              .toString() +
                                          " item"
                                      : "0" + " item",
                                  style: TextStyle(
                                    color: Color(0xff9d9797),
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.toFont),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                snapshot.selectedOrder.order.customerName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.toFont,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                // Add your onPressed code here!
                              },
                              child: Image.asset('assets/images/person.png'),
                              backgroundColor: const Color(0xffb9b8b8),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.toFont),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                status == OrderStatusStrings.pending ||
                                        status == OrderStatusStrings.accepted
                                    ? snapshot.selectedOrder.order.pickupAddress
                                        .prettyAddress
                                    : snapshot.selectedOrder.order
                                        .deliveryAddress.prettyAddress,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.toFont,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                LocationPoint location = (status ==
                                            OrderStatusStrings.pending ||
                                        status == OrderStatusStrings.accepted)
                                    ? snapshot.selectedOrder.order.pickupAddress
                                        .locationPoint
                                    : snapshot.selectedOrder.order
                                        .deliveryAddress.locationPoint;
                                _launchMaps(location.lat.toString(),
                                    location.lon.toString());
                              },
                              child:
                                  Image.asset('assets/images/naviagtion.png'),
                              backgroundColor: AppColors.icColors,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.toFont),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                snapshot
                                    .selectedOrder.order.customerPhones.first,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.toFont,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                _makePhoneCall(
                                    mobile:
                                        "tel:${snapshot.selectedOrder.order.customerPhones.first}");
                              },
                              child: Image.asset('assets/images/phone.png'),
                              backgroundColor: AppColors.icColors,
                            )
                          ],
                        ),
                      ),
                      ImageUploadWidget(snapshot.selectedOrder),
                      SizedBox(height: 20.toHeight),
                      Padding(
                        padding: EdgeInsets.all(8.toFont),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10.toWidth),
                              child: Image.asset(
                                'assets/images/path.png',
                                color: AppColors.icColors,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                tr("screen_home.Ordered_Products"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.toFont,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.toHeight),
                        child: OrderItemsBuilder(snapshot),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xffffffff),
                        ),
                      ),
                      status != OrderStatusStrings.dropped
                          ? InkWell(
                              onTap: () async {
                                String _statusString = status ==
                                        OrderStatusStrings.pending
                                    ? tr("screen_home.accept")
                                    : status == OrderStatusStrings.accepted
                                        ? tr("screen_home.pickup")
                                        : status == OrderStatusStrings.picked
                                            ? tr("screen_home.drop")
                                            : status;
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmActionDialogue(
                                    message:
                                        "Are you sure you want to $_statusString order ${snapshot.selectedOrder.order.orderShortNumber} ?",
                                    onConfirm: () {
                                      if (status ==
                                          OrderStatusStrings.pending) {
                                        snapshot.acceptOrder();
                                      } else if (status ==
                                          OrderStatusStrings.accepted) {
                                        snapshot.pickOrder();
                                      } else if (status ==
                                          OrderStatusStrings.picked) {
                                        snapshot.dropOrder();
                                      }
                                    },
                                  ),
                                );
                              },
                              child: new Container(
                                height: 65.toHeight,
                                decoration: new BoxDecoration(
                                  color: AppColors.icColors,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 15.toWidth),
                                    Spacer(),
                                    new Text(
                                      status == OrderStatusStrings.pending
                                          ? tr("screen_home.accept")
                                          : status ==
                                                  OrderStatusStrings.accepted
                                              ? tr("screen_home.pickup")
                                              : status ==
                                                      OrderStatusStrings.picked
                                                  ? tr("screen_home.drop")
                                                  : status,
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        color: Color(0xffffffff),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 15.toWidth)
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                );
        },
      ),
    );
  }

  //display image selected from camera
//display image selected from camera
  // imageSelectorCamera(_ViewModel snapshot) async {
  //   snapshot.getLocation();
  //   var orderProgress = await UserManager.getOrderProgressStatus();
  //   final pickedFile =
  //       await picker.getImage(source: ImageSource.camera, imageQuality: 50);
  //   setState(() {
  //     orderProgress != null
  //         ? orderProgress
  //             ? _endImage = File(pickedFile.path)
  //             : snapshot.selectedOrder.status == "PICKED"
  //                 ? _endImage = File(pickedFile.path)
  //                 : _startImage = File(pickedFile.path)
  //         : snapshot.selectedOrder.status == "PICKED"
  //             ? _endImage = File(pickedFile.path)
  //             : _startImage = File(pickedFile.path);
  //   });
  //   snapshot.uploadImage(
  //       orderProgress != null
  //           ? orderProgress
  //               ? _endImage
  //               : snapshot.selectedOrder.status == "PICKED"
  //                   ? _endImage
  //                   : _startImage
  //           : snapshot.selectedOrder.status == "PICKED"
  //               ? _endImage
  //               : _startImage,
  //       orderProgress != null
  //           ? orderProgress
  //               ? snapshot.selectedOrder.status == "PICKED"
  //                   ? false
  //                   : true
  //               : snapshot.selectedOrder.status == "PICKED"
  //                   ? false
  //                   : true
  //           : snapshot.selectedOrder.status == "PICKED"
  //               ? false
  //               : true);
  // }
}

class OrderItemsBuilder extends StatelessWidget {
  final _ViewModel snapshot;
  const OrderItemsBuilder(this.snapshot, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> builder = List.generate(
      snapshot.selectedOrder.order.orderItems != null
          ? snapshot.selectedOrder.order.orderItems.length
          : 0,
      (index) => Padding(
        padding: EdgeInsets.all(15.toFont),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if ((snapshot.selectedOrder.order.orderItems[index].images !=
                    null &&
                snapshot.selectedOrder.order.orderItems[index].images
                    .isNotEmpty)) ...[
              Container(
                height: 50.toHeight,
                width: 50.toWidth,
                child: CachedNetworkImage(
                  imageUrl: snapshot.selectedOrder.order.orderItems[index]
                      .images.first.photoUrl,
                ),
              ),
            ],
            Flexible(
              child: Text(
                  snapshot.selectedOrder.order.orderItems[index].productName,
                  style: const TextStyle(
                      color: const Color(0xff515c6f),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Avenir",
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0),
                  textAlign: TextAlign.left),
            ),
            Text(
                snapshot.selectedOrder.order.orderItems[index].variationOption
                            .size !=
                        null
                    ? snapshot.selectedOrder.order.orderItems[index]
                        .variationOption.size
                    : "" +
                        " x " +
                        snapshot.selectedOrder.order.orderItems[index].quantity
                            .toString(),
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: Color(0xff626262),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
          ],
        ),
      ),
    );
    builder.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Spacer(),
          Text(tr("screen_home.Total_Cost"),
              style: TextStyle(
                fontFamily: 'Avenir',
                color: Color(0xff000000),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('₹ ${snapshot.selectedOrder.order.orderTotal}',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: Color(0xff000000),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
          )
        ],
      ),
    );
    return Column(children: builder);
  }
}

_launchMaps(String lat, String lon) async {
  String googleMapUrl = "https://www.google.com/maps/dir/?api=1&destination=" +
      lat +
      "," +
      lon +
      "&travelmode=driving&dir_action=navigate";
  String googleUrl = 'comgooglemaps://?center=$lat,$lon';
  String appleUrl = 'https://maps.apple.com/?sll=$lat,$lon';
  if (await canLaunch("comgooglemaps://")) {
    print('launching com googleUrl');
    await launch(googleMapUrl);
  } else if (await canLaunch(appleUrl)) {
    print('launching apple url');
    await launch(googleMapUrl);
  } else {
    throw 'Could not launch url';
  }
}

_makePhoneCall({String mobile}) async {
  if (await canLaunch(mobile)) {
    await launch(mobile);
  } else {
    Fluttertoast.showToast(msg: tr('screen_support.No_contact_details_found'));
  }
}

class _ViewModel extends BaseModel<AppState> {
  // Function(File, bool) uploadImage;
  TransitDetails selectedOrder;
  Function() acceptOrder;
  Function() pickOrder;
  Function() dropOrder;
  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build({
    this.acceptOrder,
    this.pickOrder,
    this.dropOrder,
    this.loadingStatus,
    this.selectedOrder,
    // this.uploadImage,
  }) : super(equals: [selectedOrder, loadingStatus]);
  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      acceptOrder: () {
        dispatch(AcceptOrderAction());
      },
      pickOrder: () {
        dispatch(PickOrderAction());
      },
      dropOrder: () {
        dispatch(DropOrderAction());
      },
      loadingStatus: state.authState.loadingStatus,
      selectedOrder: state.homePageState.selectedOrder,

//       uploadImage: (file, isPickup) {
//         dispatch(UploadImageAction(imageFile: file, isPickUp: isPickup));
// //          dispatch(AcceptOrderAction());
//       },
    );
  }
}

class ImageUploadWidget extends StatelessWidget {
  final TransitDetails transitDetails;
  const ImageUploadWidget(this.transitDetails, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transitDetails.pickupImages != null &&
              transitDetails.pickupImages.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                transitDetails.pickupImages.length,
                (index) => InkWell(
                  onTap: () => showGeneralDialog(
                    barrierDismissible: false,
                    context: context,
                    pageBuilder: (context, _, __) => ImageDisplay(
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, _) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (transitDetails.status == OrderStatusStrings.picked) ...[
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.grey[400],
                width: 100,
                height: 100,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline),
                    Text(tr('screen_support.Upload_Pick_Up_Images')),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          if (transitDetails.dropImages != null &&
              transitDetails.dropImages.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                transitDetails.pickupImages.length,
                (index) => InkWell(
                  onTap: () => showGeneralDialog(
                    barrierDismissible: false,
                    context: context,
                    pageBuilder: (context, _, __) => ImageDisplay(
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: transitDetails.pickupImages[index].photoUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, _) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (transitDetails.status == OrderStatusStrings.dropped) ...[
            InkWell(
              onTap: () {},
              child: Container(
                color: Colors.grey[400],
                width: 100,
                height: 100,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline),
                    Text(tr('screen_support.Upload_Drop_Images')),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
