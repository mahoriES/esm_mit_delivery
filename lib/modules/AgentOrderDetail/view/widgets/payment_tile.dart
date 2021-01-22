import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class PaymentTile extends StatelessWidget {
  final Order order;
  const PaymentTile(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 40.toHeight,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              order.isPaymentDone ? Icons.check : Icons.watch_later,
              color: order.isPaymentDone ? Colors.green : Colors.red,
            ),
          ),
        ),
        SizedBox(width: 8.toWidth),
        Flexible(
          child: Text(
            order?.dPaymentString ?? "",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: order.isPaymentDone ? Colors.green : Colors.red,
                ),
          ),
        ),
      ],
    );
  }
}
