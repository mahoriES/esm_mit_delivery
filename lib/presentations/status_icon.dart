import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/modules/AgentHome/model/order_response.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final String agentStatus;
  final String orderStatus;
  final bool hasStatusName;
  const StatusIcon(
    this.agentStatus,
    this.orderStatus, {
    this.hasStatusName = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.toHeight,
          height: 40.toHeight,
          child: Center(
            child: Icon(
              (agentStatus == OrderStatusStrings.dropped &&
                      orderStatus == OrderStatusStrings.orderCompleted)
                  ? Icons.check
                  : (agentStatus == OrderStatusStrings.rejected)
                      ? Icons.remove
                      : (agentStatus == OrderStatusStrings.picked)
                          ? Icons.autorenew
                          : (agentStatus == OrderStatusStrings.accepted)
                              ? Icons.check
                              : Icons.new_releases,
              color: Colors.white,
            ),
          ),
          decoration: BoxDecoration(
            color: (agentStatus == OrderStatusStrings.dropped &&
                    orderStatus == OrderStatusStrings.orderCompleted)
                ? Colors.green
                : (agentStatus == OrderStatusStrings.rejected)
                    ? Colors.red
                    : (agentStatus == OrderStatusStrings.picked)
                        ? Color(0xffdd8126)
                        : (agentStatus == OrderStatusStrings.accepted)
                            ? Color(0xffdd8126)
                            : Color(0xffdd8126),
            shape: BoxShape.circle,
          ),
        ),
        if (hasStatusName) ...[
          SizedBox(height: 10.toHeight),
          Flexible(
            child: Text(
              (agentStatus == OrderStatusStrings.dropped &&
                      orderStatus == OrderStatusStrings.orderCompleted)
                  ? tr("screen_home.Completed")
                  : (agentStatus == OrderStatusStrings.rejected)
                      ? tr("screen_home.Rejected")
                      : (agentStatus == OrderStatusStrings.picked)
                          ? tr("screen_home.In_progress")
                          : (agentStatus == OrderStatusStrings.accepted)
                              ? tr("screen_home.tab_bar.accepted")
                              : tr("screen_home.New"),
              style: TextStyle(
                color: Color(0xff5f5959),
                fontSize: 12.toFont,
                fontFamily: 'Avenir',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]
      ],
    );
  }
}
