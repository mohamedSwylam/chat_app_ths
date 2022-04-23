import 'package:chat_app_th/widget/show_image.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  final String message;
  const ImageMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2.5,
      width: size.width / 2,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowImage(
              imageUrl: message,
            ),
          ),
        ),
        child: Container(
          height: size.height / 2.5,
          width: size.width / 2,
          decoration: BoxDecoration(border: Border.all()),
          child: message != ""
              ? Image.network(
            message,
            fit: BoxFit.fill,
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
