import 'package:advanced_app/data/network/failure.dart';
import 'package:advanced_app/data/network/requests.dart';
import 'package:advanced_app/domain/model/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository{
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
}