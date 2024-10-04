
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pixabay_image_viewer/constants/app_constants.dart';
import 'package:pixabay_image_viewer/cubits/image_getter_cubit.dart';
import 'package:pixabay_image_viewer/models/image_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  void showToastMsg({required String msg}){
    showToast(msg,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          ImageViewerConstants.name,
          style:  Theme.of(context).textTheme.bodyMedium?.apply(
            color: Colors.white
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey.shade400,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            alignment: Alignment.center,
            child: BlocBuilder<ImageGetterCubit, ImageGetterState>(
              builder: (context, imageGetterState) {
                print('AS :: State is ${imageGetterState.runtimeType}');
                if(imageGetterState is ImageGetterLoaded || imageGetterState is ImageGetterRefreshing){
                  List<ImageData> imagesData= imageGetterState.props.first as List<ImageData>;
                  return NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        // Check if the user is scrolling near the end
                        final maxScrollExtent = notification.metrics.maxScrollExtent;
                        final currentScroll = notification.metrics.pixels;
                        const scrollThreshold = 240.0; // Customize this to trigger loading before end

                        if (maxScrollExtent - currentScroll <= scrollThreshold) {
                        if(imageGetterState is ImageGetterLoaded){
                          int approxPageNumber=( imagesData.length~/50)+1;
                          if(approxPageNumber<=10){
                            context.read<ImageGetterCubit>().getMoreImages(pageNumber: approxPageNumber);
                          }
                          else{
                            showToastMsg(msg: 'That\'s all for now.');
                          }
                        }
                        }
                      }
                      return false;
                    },
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 160.0, // Maximum width of each item
                        crossAxisSpacing: 10.0, // Horizontal spacing between items
                        mainAxisSpacing: 10.0, // Vertical spacing between items
                        childAspectRatio: 0.75, // Aspect ratio of items
                      ),
                        itemCount: imagesData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 240,
                            color: Colors.blueGrey.shade100,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Image.network(
                                  imagesData[index].previewURL.toString(),
                                  height: 160,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_outlined,
                                      color: Colors.blueGrey,
                                      size: 36,
                                    );
                                  },
                                ),
                                const SizedBox(height: 6,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.remove_red_eye_sharp,
                                                color: Colors.deepPurple,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4,),
                                              Text(
                                                'Views',
                                                style: Theme.of(context).textTheme.bodySmall?.apply(
                                                    color: Colors.blueGrey,
                                                    fontSizeDelta: -2,
                                                    fontWeightDelta: 2
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            (imagesData[index].views??0).toString(),
                                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                                color: Colors.blueGrey
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Likes',
                                                style: Theme.of(context).textTheme.bodySmall?.apply(
                                                    color: Colors.blueGrey,
                                                    fontSizeDelta: -2,
                                                    fontWeightDelta: 2
                                                ),
                                              ),
                                              Text(
                                                (imagesData[index].likes??0).toString(),
                                                style: Theme.of(context).textTheme.bodySmall?.apply(
                                                  color: Colors.blueGrey
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },),
                  );
                }
                else{
                  return const SizedBox(
                    height: 24,
                    width: 24,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 1.6,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
