import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pixabay_image_viewer/models/image_data_model.dart';
import 'package:pixabay_image_viewer/services/network_client.dart';

part 'image_getter_state.dart';

class ImageGetterCubit extends Cubit<ImageGetterState> {
  static final NetworkClient networkClient = NetworkClient();

  ImageGetterCubit() : super(ImageGetterInitial());



  Future<void> getImages() async {
    Response imageResponse = await networkClient.getImages();
    // print('AS :: Get Images :: ${imageResponse.data}');
    if(imageResponse.statusCode==200){
      Map<String,dynamic> reponseData = imageResponse.data;
      // print('AS :: Data :: $reponseData');
      List<dynamic> imagesData = reponseData['hits']??[];
      List<ImageData> images =[];
      for(var x in imagesData){
        ImageData imageData = ImageData.fromJson(x);
        images.add(imageData);
      }
      emit(ImageGetterLoaded(imagesData: images));
    }
    else{
      emit(const ImageGetterError());
    }
  }


  Future<void> getMoreImages({required int pageNumber}) async{
    
    List<ImageData> oldImages = [];
    if(state is ImageGetterLoaded){
      oldImages = state.props.first as List<ImageData>;
    }
    emit(ImageGetterRefreshing(imagesData: oldImages));
    Response imageResponse = await networkClient.getImages(pageNumber: pageNumber);
    // print('AS :: Get More Images :: ${imageResponse.data}');
    if(imageResponse.statusCode==200){
      Map<String,dynamic> reponseData = imageResponse.data;
      List<dynamic> imagesData = reponseData['hits']??[];
      for(var x in imagesData){
        ImageData imageData = ImageData.fromJson(x);
        oldImages.add(imageData);
      }
      emit(ImageGetterLoaded(imagesData: oldImages));
    }
    else{
      emit(const ImageGetterError());
    }

  }
}
