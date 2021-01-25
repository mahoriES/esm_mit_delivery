import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class ConfirmActionDialogue extends StatefulWidget {
  final String message;
  final Function onConfirm;
  final Function onCancel;
  final bool shouldConfirmPayment;
  final String paymentConfirmationMessage;

  ConfirmActionDialogue({
    @required this.message,
    @required this.onConfirm,
    this.onCancel,
    this.shouldConfirmPayment = false,
    this.paymentConfirmationMessage,
  });

  @override
  _ConfirmActionDialogueState createState() => _ConfirmActionDialogueState();
}

class _ConfirmActionDialogueState extends State<ConfirmActionDialogue> {
  bool isPaymentCompleted;

  @override
  void initState() {
    isPaymentCompleted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.toWidth,
            vertical: 20.toHeight,
          ),
          margin: EdgeInsets.symmetric(horizontal: 50.toWidth),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.message ?? '',
                style: TextStyle(
                  fontSize: 12.toFont,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.shouldConfirmPayment ?? false) ...[
                SizedBox(height: 20.toHeight),
                Row(
                  children: [
                    Checkbox(
                      value: isPaymentCompleted,
                      activeColor: AppColors.icColors,
                      onChanged: (isSelected) {
                        setState(() {
                          isPaymentCompleted = isSelected;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        widget.paymentConfirmationMessage ?? '',
                        style: TextStyle(
                          fontSize: 12.toFont,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 20.toHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.onCancel != null) widget.onCancel();
                      },
                      color: Theme.of(context).errorColor,
                      child: FittedBox(
                        child: Text(
                          tr("screen_account.cancel"),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: RaisedButton(
                      onPressed: !widget.shouldConfirmPayment ||
                              (widget.shouldConfirmPayment &&
                                  isPaymentCompleted)
                          ? () {
                              Navigator.pop(context);
                              widget.onConfirm();
                            }
                          : null,
                      color: AppColors.icColors,
                      child: FittedBox(
                        child: Text(
                          tr("screen_home.confirm"),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
