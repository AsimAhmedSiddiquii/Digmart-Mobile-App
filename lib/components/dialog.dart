import 'package:digmart_business/components/constants.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final IconData icon;
  final Widget navigateTo;
  final Color bgColor;

  const CustomDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.buttonText,
      required this.icon,
      required this.bgColor,
      required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: avatarRadius + defaultPadding,
            bottom: defaultPadding,
            left: defaultPadding,
            right: defaultPadding,
          ),
          margin: const EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(defaultPadding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: defaultPadding * 0.4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return navigateTo;
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 60)),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: defaultPadding,
          right: defaultPadding,
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: avatarRadius,
            child: Icon(
              icon,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}
