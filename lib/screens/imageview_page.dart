import 'package:flutter/material.dart';
import 'package:pixabay_image_viewer/models/image_data_model.dart';

class ImageViewPage extends StatefulWidget {
  const ImageViewPage({
    required this.imageData,
    super.key
  });

  final ImageData imageData;

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
            'Detailed View',
          style:  Theme.of(context).textTheme.bodyMedium?.apply(
            color: Colors.white
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.black,
        alignment: Alignment.center,
        child: (widget.imageData.largeImageURL!=null)?
        Image.network(
          widget.imageData.largeImageURL!,
          fit: BoxFit.fitHeight,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.image_outlined,
              color: Colors.blueGrey,
              size: 36,
            );
          },
        ):
        const Icon(
          Icons.image_outlined,
          size: 32,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
