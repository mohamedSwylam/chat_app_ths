abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class OnChangeBusinessNameState extends RegisterStates {}

class OnChangeContactNumberState extends RegisterStates {}

class OnChangeEmailState extends RegisterStates {}

class OnChangeTaxRegisteredState extends RegisterStates {}

class OnChangeGstNumberState extends RegisterStates {}

class OnChangePinCodeState extends RegisterStates {}

class OnChangeLandMark extends RegisterStates {}

class OnChangeAddressState extends RegisterStates {}

class OnChangeCountryState extends RegisterStates {}

class OnChangeState extends RegisterStates {}

class OnChangeCityState extends RegisterStates {}

class PickShopImageSuccessState extends RegisterStates {}

class PickShopImageErrorState extends RegisterStates {
  final String error;

  PickShopImageErrorState(this.error);
}

class PickLogoShopImageSuccessState extends RegisterStates {}

class PickLogoShopImageErrorState extends RegisterStates {
  final String error;

  PickLogoShopImageErrorState(this.error);
}
class SaveToDbSuccessState extends RegisterStates {}

class SaveToDbErrorState extends RegisterStates {
  final String error;

  SaveToDbErrorState(this.error);
}