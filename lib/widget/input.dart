import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? node;
  final String hint;
  final bool enabled;
  final Function(String text)? onChange;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isNumberDecimal;
  final double? maxDecimalInput;
  final double? minDecimalInput;

  //Default Form Input
  Input({
    required this.controller,
    this.node,
    this.hint = "Enter Text Here",
    this.enabled = true,
    this.onChange,
    this.suffixIcon,
    this.prefixIcon,
    this.isNumberDecimal = false,
    this.maxDecimalInput,
    this.minDecimalInput,
  });

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  void initState() {
    super.initState();
    if (widget.isNumberDecimal) {
      if (double.tryParse(widget.controller.text) == null) {
        widget.controller.text = "0";
      } else {
        if (widget.maxDecimalInput != null &&
            double.parse(widget.controller.text) > widget.maxDecimalInput!) {
          widget.controller.text = widget.maxDecimalInput.toString();
        }
        if (widget.minDecimalInput != null &&
            double.parse(widget.controller.text) < widget.minDecimalInput!) {
          widget.controller.text = widget.minDecimalInput.toString();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Default Form Input
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.node,
      inputFormatters: widget.isNumberDecimal
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,4})'))
            ]
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value != null && value.length > 0 ? null : null,
      onChanged: (value) {
        if (widget.isNumberDecimal) {
          if (double.tryParse(value) == null) {
            widget.controller.text = "0";
            widget.onChange?.call(widget.controller.text);
          } else {
            if (widget.maxDecimalInput != null &&
                double.parse(value) > widget.maxDecimalInput!) {
              widget.controller.text = widget.maxDecimalInput.toString();
            }
            if (widget.minDecimalInput != null &&
                double.parse(value) < widget.minDecimalInput!) {
              widget.controller.text = widget.minDecimalInput.toString();
            }
            widget.onChange?.call(widget.controller.text);
          }
        } else {
          widget.onChange?.call(value);
        }
      },
      style: Theme.of(context).textTheme.bodyText2,
      keyboardType: TextInputType.text,
      cursorColor: Colors.black,
      enabled: widget.enabled,
      decoration: inputDecoration(
        context,
        widget.hint,
        enabled: widget.enabled,
        suffixIcon: widget.suffixIcon,
        preffixIcon: widget.prefixIcon,
      ),
    );
  }

  //InputDecoration of Default(Majority) Input
  static InputDecoration inputDecoration(BuildContext context, String hintText,
      {bool enabled = true,
      contentPadding = const EdgeInsets.symmetric(horizontal: 16),
      Widget? suffixIcon,
      Widget? preffixIcon}) {
    return InputDecoration(
        fillColor: enabled ? Colors.white : Color.fromRGBO(235, 241, 244, 1),
        filled: true,
        disabledBorder: border(context),
        enabledBorder: border(context),
        focusedBorder: borderActive(context),
        hoverColor: Colors.transparent,
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: Color.fromRGBO(116, 132, 141, 1)),
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        prefixIcon: preffixIcon);
  }

  static OutlineInputBorder border(
    BuildContext context, {
    double radius = 4, //Default Radius (Majority Form Input) is 4
    Color color = const Color.fromRGBO(
        206, 212, 218, 1), //Default Color (Majority Form Input)
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(width: 1, color: color),
    );
  }

  static OutlineInputBorder borderActive(
    BuildContext context, {
    double radius = 4, //Default Radius (Majority Form Input) is 4
    Color color = const Color.fromRGBO(
        35, 177, 128, 1), //Default Active Color (Majority Form Input)
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(width: 1, color: color),
    );
  }
}
