import 'package:clone_tiktok/utils/colors.dart';
import 'package:flutter/material.dart';

class AllVideosViewWidget extends StatefulWidget {
  const AllVideosViewWidget({super.key, required this.thumbnailUrls});
  final List<String> thumbnailUrls;

  @override
  State<AllVideosViewWidget> createState() => _AllVideosViewWidgetState();
}

class _AllVideosViewWidgetState extends State<AllVideosViewWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.thumbnailUrls.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 1.5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(border: Border.all(color: secondaryColor)),
          child: Image(
            image: NetworkImage(widget.thumbnailUrls[index]),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
