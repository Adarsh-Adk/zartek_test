part of 'cart_controller_cubit.dart';

@immutable
abstract class CartControllerState {}

class CartControllerInitial extends CartControllerState {
  CartControllerInitial(this.value);
 int value=0;
}

class CartControllerLoaded extends CartControllerState{
  int value;

  CartControllerLoaded(this.value);
  int get val=>value;
}

// class CartControllerLoading extends CartControllerState{
//
// }