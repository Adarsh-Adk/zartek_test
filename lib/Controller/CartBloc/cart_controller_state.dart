part of 'cart_controller_cubit.dart';

@immutable
abstract class CartControllerState {}

// ignore: must_be_immutable
class CartControllerInitial extends CartControllerState {
  CartControllerInitial(this.value);
 int value=0;
}

// ignore: must_be_immutable
class CartControllerLoaded extends CartControllerState{
  int value;

  CartControllerLoaded(this.value);
  int get val=>value;
}

// class CartControllerLoading extends CartControllerState{
//
// }