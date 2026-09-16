import 'package:flutter/material.dart';
import 'constants.dart';

class DefaultButton extends StatelessWidget {
  final double width;
  final Color background;
  final double radius;
  final VoidCallback? function;
  final String label;
  final String buttonText;

  const DefaultButton({
    super.key,
    this.width = double.infinity,
    this.background = mainColor,
    this.radius = 10.0,
    this.function,
    this.label = '',
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        // Directly passing the callback executes it properly when clicked
        onPressed: function,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
          ), // Optional: explicitly styling text color
        ),
      ),
    );
  }
}

//////
class DefaultCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  const DefaultCard({this.padding, this.color, super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

//////
class DefaultFormField extends StatefulWidget {
  final bool isReadOnly;
  final bool isPassword;
  final TextEditingController textControl;
  final String label;
  final IconData prefix;
  final String? Function(String?) validate;
  final TextInputType type;
  final IconData? suffix; // Made nullable so you can hide it completely
  final VoidCallback? suffixPressed;
  final VoidCallback? onTap;

  const DefaultFormField({
    super.key,
    this.isReadOnly = false,
    this.isPassword = false,
    required this.textControl,
    required this.label,
    required this.prefix,
    required this.validate,
    required this.type,
    this.suffix, // Leave null if you don't want a suffix icon
    this.suffixPressed,
    this.onTap,
  });

  @override
  State<DefaultFormField> createState() => _DefaultFormFieldState();
}

class _DefaultFormFieldState extends State<DefaultFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isReadOnly,
      onTap: widget.onTap,
      obscureText: widget.isPassword,
      keyboardType: widget.type,
      controller: widget.textControl,
      validator: widget.validate,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
        prefixIcon: Icon(widget.prefix),
        // Now accurately hides the widget if no suffix icon is provided
        suffixIcon: widget.suffix != null
            ? IconButton(
                icon: Icon(widget.suffix),
                onPressed: widget.suffixPressed,
              )
            : null,
      ),
    );
  }
}

//////
class MainLogo extends StatelessWidget {
  final double logoSize;
  const MainLogo({super.key, this.logoSize = 100});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Icon(Icons.bloodtype);
  }
}
