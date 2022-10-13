import 'package:advanced_app/app/di.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_app/presentation/resources/color_manager.dart';
import 'package:advanced_app/presentation/resources/strings_manager.dart';
import 'package:advanced_app/presentation/resources/values_manager.dart';
import 'package:advanced_app/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  _bind(){
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data
                ?.getScreenWidget(context, _getContentWidget(), () {
              _viewModel.start();
            }) ??
                _getContentWidget();
          }),
    );
  }

  Widget _getContentWidget(){
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.storeDetails.tr()),
        elevation: AppSize.s0,
        iconTheme: IconThemeData(
          //back button
          color: ColorManager.white,
        ),
        backgroundColor: ColorManager.primary,
        centerTitle: true,
      ),
      body: StreamBuilder<StoreDetails>(
        stream: _viewModel.outputStoreDetails,
        builder: (context, snapshot){
          if(snapshot.data != null) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getImageWidget(snapshot.data!.image),
                  _getSection(AppStrings.details.tr()),
                  _getText(snapshot.data!.details),
                  _getSection(AppStrings.services.tr()),
                  _getText(snapshot.data!.services),
                  _getSection(AppStrings.about.tr()),
                  _getText(snapshot.data!.about),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _getImageWidget(String image){
    return Center(
      child: Image.network(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      ),
    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme
            .of(context)
            .textTheme
            .titleMedium,
      ),
    );
  }

  Widget _getText(String text){
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        text,
        style: Theme
            .of(context)
            .textTheme
            .bodySmall,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
