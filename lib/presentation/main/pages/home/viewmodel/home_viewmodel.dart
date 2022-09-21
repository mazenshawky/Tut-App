import 'dart:async';
import 'dart:ffi';

import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/usecase/home_usecase.dart';
import 'package:advanced_app/presentation/base/baseviewmodel.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput{
  final StreamController _homeViewStreamController = BehaviorSubject<HomeViewObject>();

  HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  // -- inputs
  @override
  void start() {
    _getHomeData();
  }

  @override
  void dispose() {
    _homeViewStreamController.close();
    super.dispose();
  }

  _getHomeData() async{
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _homeUseCase.execute(Void))
        .fold(
            (failure) => {
          // left -> failure
          inputState.add(ErrorState(
              StateRendererType.fullScreenErrorState, failure.message))
        }, (homeObject) {
      // right -> data (success)
      inputState.add(ContentState());
      inputHomeView.add(HomeViewObject(homeObject.data.stores,
          homeObject.data.services, homeObject.data.banners));
    });
  }

  @override
  Sink get inputHomeView => _homeViewStreamController.sink;

  // -- outputs
  @override
  Stream<HomeViewObject> get outputHomeView =>
      _homeViewStreamController.stream.map((homeView) => homeView);
}

abstract class HomeViewModelInput{
  Sink get inputHomeView;
}

abstract class HomeViewModelOutput{
  Stream<HomeViewObject> get outputHomeView;
}

class HomeViewObject{
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;

  HomeViewObject(this.stores, this.services, this.banners);
}
