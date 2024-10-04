part of 'image_getter_cubit.dart';

abstract class ImageGetterState extends Equatable {
  const ImageGetterState();
}

class ImageGetterInitial extends ImageGetterState {
  @override
  List<Object> get props => [];
}

class ImageGetterLoading extends ImageGetterState{
  @override
  List<Object> get props => [];
}

class ImageGetterLoaded extends ImageGetterState{
  const ImageGetterLoaded({
    required this.imagesData
});
  final List<ImageData> imagesData;
  @override
  List<Object> get props => [imagesData];
}

class ImageGetterRefreshing extends ImageGetterState{
  const ImageGetterRefreshing({required this.imagesData});
  final List<ImageData> imagesData;
  @override
  List<Object> get props => [imagesData];
}

class ImageGetterError extends ImageGetterState{
  const ImageGetterError({this.errorMsg='Unable to load images, try again later.'});
  final String errorMsg;
  @override
  List<Object> get props => [errorMsg];
}