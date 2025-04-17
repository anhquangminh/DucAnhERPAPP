import 'package:equatable/equatable.dart';
import 'package:ducanherp/models/danhgia_model.dart';

abstract class DanhGiaState extends Equatable {
  const DanhGiaState();

  @override
  List<Object?> get props => [];
}

class DanhGiaInitial extends DanhGiaState {}

class DanhGiaLoading extends DanhGiaState {}

class DanhGiaLoaded extends DanhGiaState {
  final DanhGiaModel danhGia;

  const DanhGiaLoaded({required this.danhGia});

  @override
  List<Object> get props => [danhGia];
}

class DanhGiaSuccess extends DanhGiaState {}

class DanhGiaError extends DanhGiaState {
  final String message;

  const DanhGiaError(this.message);

  @override
  List<Object> get props => [message];
}
