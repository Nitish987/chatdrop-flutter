import 'package:chatdrop/modules/camera/presentation/cubit/camera_feature/camera_feature_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraFeatureCubit extends Cubit<CameraFeatureState> {
  CameraFeatureCubit() : super(PhotoCameraState());

  changeFeature(CameraFeatureState state) {
    emit(state);
  }
}