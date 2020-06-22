import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class TextInputBG extends StatelessWidget {
  final Widget child;

  const TextInputBG({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
//        border: Border.all(color: Colors.redAccent),
        boxShadow: [
          BoxShadow(
            color: Color(0x80c7d0f8),
            offset: Offset(0, 6),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Opacity(
        opacity: 0.596517026424408,
        child: Padding(
          padding: EdgeInsets.only(right: 15, left: 15),
          child: child,
        ),
      ),
    );
  }
}

class OTPField extends StatefulWidget {
  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// Manage the type of keyboard that shows up
//  TextInputType keyboardType;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String> onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String> onCompleted;

  OTPField(
      {Key key,
      this.length = 4,
      this.width = 10,
      this.fieldWidth = 30,
//        this.keyboardType = TextInputType.number,
      this.style = const TextStyle(),
      this.textFieldAlignment = MainAxisAlignment.spaceBetween,
      this.obscureText = false,
      this.fieldStyle = FieldStyle.underline,
      this.onChanged,
      this.onCompleted})
      : assert(length > 1);

  @override
  _OTPFieldState createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  List<Widget> _textFields;
  List<String> _pin;

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>(widget.length);
    _textControllers = List<TextEditingController>(widget.length);

    _pin = List.generate(widget.length, (int i) {
      return '';
    });
    _textFields = List.generate(widget.length, (int i) {
      return buildTextField(context, i);
    });
  }

  @override
  void dispose() {
    _textControllers
        .forEach((TextEditingController controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _textFields,
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int i) {
    if (_focusNodes[i] == null) _focusNodes[i] = new FocusNode();

    if (_textControllers[i] == null)
      _textControllers[i] = new TextEditingController();
    print(i);
    _textControllers[i].addListener(() {
      //here you have the changes of your textfield
      print("value: ${_textControllers[i].text}");
      //use setState to rebuild the widget
      setState(() {});
    });

    return Container(
      width: widget.fieldWidth,
      child: TextField(
        onEditingComplete: () {
          print(_textControllers[i].text);
        },
//        enabled: i == 0
//            ? true
//            : _textControllers[i - 1].text.length == 1 ? true : false,
        autofocus: true,
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: widget.style,
        focusNode: _focusNodes[i],
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            counterText: "",
            border: widget.fieldStyle == FieldStyle.box
                ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                : null),
        onChanged: (String str) {
          // Check if the current value at this position is empty
          // If it is move focus to previous text field.
          if (str.isEmpty) {
            if (i == 0) return;
            _focusNodes[i].unfocus();
            _focusNodes[i - 1].requestFocus();
          }

          // Update the current pin
          setState(() {
            _pin[i] = str;
          });

          // Remove focus
          if (str.isNotEmpty) _focusNodes[i].unfocus();
          // Set focus to the next field if available
          if (i + 1 != widget.length && str.isNotEmpty)
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);

          String currentPin = "";
          _pin.forEach((String value) {
            currentPin += value;
          });

          // if there are no null values that means otp is completed
          // Call the `onCompleted` callback function provided
          if (!_pin.contains(null) &&
              !_pin.contains('') &&
              currentPin.length == widget.length) {
            widget.onCompleted(currentPin);
          }

          // Call the `onChanged` callback function
          widget.onChanged(currentPin);
        },
      ),
    );
  }
}

enum FieldStyle { underline, box }

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
