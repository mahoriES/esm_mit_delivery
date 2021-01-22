import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/models/loading_status.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/action/order_action.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/pick_image.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/model/transit_models.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/view/image_view.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/view/widgets/details_tile.dart';
import 'package:esamudaayapp/modules/AgentOrderDetail/view/widgets/payment_tile.dart';
import 'package:esamudaayapp/presentations/confirm_dialogue.dart';
import 'package:esamudaayapp/presentations/loading_widget.dart';
import 'package:esamudaayapp/presentations/status_icon.dart';
import 'package:esamudaayapp/redux/states/app_state.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/common_methods.dart';
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                StatusIcon(
                                  snapshot.selectedOrder.status,
                                  snapshot.selectedOrder.order.orderStatus,
                                  hasStatusName: false,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.toWidth),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          CommonMethods.convertDateFromString(
                                              snapshot.selectedOrder.created),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.toFont,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        if (snapshot.selectedOrder.order
                                                    .orderStatus ==
                                                OrderStatusStrings
                                                    .orderCompleted &&
                                            status ==
                                                OrderStatusStrings
                                                    .accepted) ...[
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: tr(
                                                      "screen_home.Completed"),
                                                  style: TextStyle(
                                                    color: Color(0xff505050),
                                                    fontSize: 12,
                                                    fontFamily: 'Avenir',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: CommonMethods
                                                      .convertDateFromString(
                                                          snapshot.selectedOrder
                                                              .order.created),
                                                  style: TextStyle(
                                                    color: Color(0xff959595),
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'CircularStd-Book',
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
                                                text:
                                                    ': ${CommonMethods.getDistanceinFormat(snapshot.selectedOrder.distanceInMeters)}',
                                                style: TextStyle(
                                                  color: Color(0xff959595),
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'CircularStd-Book',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      // convert amount in rupees by dividing with 100
                                      'Rs.${(snapshot.selectedOrder.order.orderTotal / 100).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                    Text(
                                      snapshot.selectedOrder.order.orderItems !=
                                              null
                                          ? snapshot.selectedOrder.order
                                                  .orderItems.length
                                                  .toString() +
                                              " ${tr('screen_home.item')}"
                                          : "0" + " ${tr('screen_home.item')}",
                                      style: TextStyle(
                                        color: Color(0xff9d9797),
                                        fontFamily: 'Avenir',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10.toHeight),
                            if (status != OrderStatusStrings.dropped) ...[
                              PaymentTile(snapshot.selectedOrder.order),
                            ]
                          ],
                        ),
                      ),
                      SizedBox(height: 20.toHeight),
                      // merchant details component
                      DetailsTileWidget(
                        showCustomerDetails: false,
                      ),
                      SizedBox(height: 20.toHeight),
                      // customer details component
                      DetailsTileWidget(
                        showCustomerDetails: true,
                      ),
                      SizedBox(height: 20.toHeight),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.toWidth),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (snapshot.selectedOrder.pickupImages != null &&
                                snapshot
                                    .selectedOrder.pickupImages.isNotEmpty) ...[
                              Text(
                                tr("screen_home.pickup_images"),
                                style: TextStyle(
                                  fontSize: 16.toFont,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ],
                            SizedBox(height: 10.toHeight),
                            _ImagesView(
                              images: snapshot.selectedOrder.pickupImages,
                              showUploadOption:
                                  status == OrderStatusStrings.picked,
                              isPickUpImageUpload: true,
                              onUploadImage: (file) => snapshot.uploadImage(
                                file,
                                snapshot.selectedOrder.pickupImages,
                              ),
                              removeImage: (index) {
                                snapshot.selectedOrder.pickupImages
                                    .removeAt(index);
                                snapshot.updateImages(
                                    snapshot.selectedOrder.pickupImages);
                              },
                            ),
                            if (snapshot.selectedOrder.dropImages != null &&
                                snapshot
                                    .selectedOrder.dropImages.isNotEmpty) ...[
                              SizedBox(height: 10.toHeight),
                              Text(
                                tr("screen_home.drop_images"),
                                style: TextStyle(
                                  fontSize: 16.toFont,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ],
                            SizedBox(height: 10.toHeight),
                            _ImagesView(
                              images: snapshot.selectedOrder.dropImages,
                              showUploadOption:
                                  status == OrderStatusStrings.dropped,
                              isPickUpImageUpload: false,
                              onUploadImage: (file) => snapshot.uploadImage(
                                file,
                                snapshot.selectedOrder.dropImages,
                              ),
                              removeImage: (index) {
                                snapshot.selectedOrder.dropImages
                                    .removeAt(index);
                                snapshot.updateImages(
                                    snapshot.selectedOrder.dropImages);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.toHeight),
                      if (status != OrderStatusStrings.dropped &&
                          status != OrderStatusStrings.rejected) ...[
                        status == OrderStatusStrings.pending
                            ? Row(
                                children: [
                                  Expanded(
                                    child: _BottomActionButton(
                                      tr("screen_home.reject"),
                                      snapshot
                                          .selectedOrder.order.orderShortNumber,
                                      () => snapshot.rejectOrder(),
                                    ),
                                  ),
                                  SizedBox(width: 1),
                                  Expanded(
                                    child: _BottomActionButton(
                                      tr("screen_home.accept"),
                                      snapshot
                                          .selectedOrder.order.orderShortNumber,
                                      () => snapshot.acceptOrder(),
                                    ),
                                  ),
                                ],
                              )
                            : _BottomActionButton(
                                status == OrderStatusStrings.accepted
                                    ? tr("screen_home.pickup")
                                    : status == OrderStatusStrings.picked
                                        ? tr("screen_home.drop")
                                        : "",
                                snapshot.selectedOrder.order.orderShortNumber,
                                () {
                                  if (status == OrderStatusStrings.accepted) {
                                    snapshot.pickOrder();
                                  } else if (status ==
                                      OrderStatusStrings.picked) {
                                    snapshot.dropOrder();
                                  }
                                },
                              ),
                      ],
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class _ImagesView extends StatelessWidget {
  final List<ImageResponse> images;
  final bool showUploadOption;
  final bool isPickUpImageUpload;
  final Function(File) onUploadImage;
  final Function(int) removeImage;
  _ImagesView({
    @required this.images,
    @required this.showUploadOption,
    @required this.isPickUpImageUpload,
    @required this.onUploadImage,
    @required this.removeImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int length = (images?.length ?? 0);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        length + 1,
        (index) {
          if (index == length) {
            return showUploadOption
                ? InkWell(
                    onTap: () async {
                      PickedFile pickedFile = await ImagePicker().getImage(
                          source: ImageSource.camera, imageQuality: 25);
                      onUploadImage(File(pickedFile.path));
                    },
                    child: Container(
                      width: 100.toWidth,
                      height: 100.toHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.icColors, width: 2),
                      ),
                      padding: EdgeInsets.all(10.toFont),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline,
                              color: AppColors.icColors),
                          SizedBox(height: 10.toHeight),
                          Flexible(
                            child: Text(
                              tr(isPickUpImageUpload
                                  ? 'screen_support.Upload_Pick_Up_Images'
                                  : 'screen_support.Upload_Drop_Images'),
                              style: TextStyle(color: AppColors.icColors),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink();
          }
          return InkWell(
            onTap: () => showGeneralDialog(
              barrierDismissible: false,
              context: context,
              pageBuilder: (context, _, __) => ImageDisplay(
                imageUrl: images[index].photoUrl,
              ),
            ),
            child: Container(
              width: 100.toWidth,
              height: 100.toHeight,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl: images[index].photoUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, _) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  if (showUploadOption) ...[
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.toFont),
                          ),
                          child: Icon(Icons.clear),
                        ),
                        onTap: () => removeImage(index),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  final String statusString;
  final String orderShortNumber;
  final Function() onConfirm;
  const _BottomActionButton(
    this.statusString,
    this.orderShortNumber,
    this.onConfirm, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => ConfirmActionDialogue(
            message: tr(
              "screen_home.confirm_action_mesage",
              namedArgs: {
                'actionName': statusString,
                'orderNumber': orderShortNumber,
              },
            ),
            onConfirm: onConfirm,
          ),
        );
      },
      child: new Container(
        width: double.infinity,
        height: 65.toHeight,
        decoration: new BoxDecoration(
          color: AppColors.icColors,
        ),
        child: Center(
          child: Text(
            statusString,
            style: TextStyle(
              fontFamily: 'Avenir',
              color: Color(0xffffffff),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

_launchMaps(String lat, String lon) async {
  String googleMapUrl = "https://www.google.com/maps/dir/?api=1&destination=" +
      lat +
      "," +
      lon +
      "&travelmode=driving&dir_action=navigate";
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
  Function(File, List<ImageResponse>) uploadImage;
  Function(List<ImageResponse>) updateImages;
  TransitDetails selectedOrder;
  Function() acceptOrder;
  Function() pickOrder;
  Function() dropOrder;
  Function() rejectOrder;
  LoadingStatus loadingStatus;
  _ViewModel();
  _ViewModel.build({
    this.acceptOrder,
    this.pickOrder,
    this.dropOrder,
    this.rejectOrder,
    this.loadingStatus,
    this.selectedOrder,
    this.uploadImage,
    this.updateImages,
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
      rejectOrder: () {
        dispatch(RejectOrderAction());
      },
      loadingStatus: state.authState.loadingStatus,
      selectedOrder: state.homePageState.selectedOrder,
      uploadImage: (file, existingImages) {
        dispatch(UploadImageAction(file, existingImages));
      },
      updateImages: (images) {
        dispatch(UpdateOrderImagesAction(images));
      },
    );
  }
}
