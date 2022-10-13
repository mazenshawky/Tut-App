import 'dart:async';
import 'dart:ffi';

import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/usecase/store_details_usecase.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsModelInput, StoreDetailsModelOutput{

  final StreamController _storeDetailsStreamController = BehaviorSubject<StoreDetails>();

  final StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  // -- inputs
  @override
  void start() {
    _getStoreDetails();
  }
  @override
  void dispose() {
    _storeDetailsStreamController.close();
    super.dispose();
  }

  _getStoreDetails() async{
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _storeDetailsUseCase.execute(Void))
        .fold(
            (failure) => {
          // left -> failure
          inputState.add(ErrorState(
              StateRendererType.fullScreenErrorState, failure.message))
        }, (data) {
      // right -> data (success)
      inputState.add(ContentState());
      inputStoreDetails.add(data);
    });
  }

  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;

  // -- outputs
  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsStreamController.stream.map((data) => data);
}

abstract class StoreDetailsModelInput{
  Sink get inputStoreDetails;
}

abstract class StoreDetailsModelOutput{
  Stream<StoreDetails> get outputStoreDetails;
}