import 'package:advanced_app/data/network/failure.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:advanced_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../repository/repository.dart';

class StoreDetailsUseCase implements BaseUseCase<void, StoreDetails> {
  final Repository _repository;

  StoreDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await _repository.getStoreDetails();
  }
}
