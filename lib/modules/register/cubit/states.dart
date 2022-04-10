abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class OnChangeBusinessNameState extends RegisterStates {}
class SelectedDateOfBirthSuccessState extends RegisterStates {}

class OnChangeContactNumberState extends RegisterStates {}

class OnChangeEmailState extends RegisterStates {}

class OnChangeFirstNameState extends RegisterStates {}

class OnChangeLastNameState extends RegisterStates {}

class OnChangeGenderState extends RegisterStates {}


class OnChangeAddressState extends RegisterStates {}

class OnChangeCountryState extends RegisterStates {}

class OnChangeState extends RegisterStates {}

class OnChangeCityState extends RegisterStates {}
class OnChangePasswordState extends RegisterStates {}

class PickUserImageSuccessState extends RegisterStates {}

class PickUserImageErrorState extends RegisterStates {
  final String error;

  PickUserImageErrorState(this.error);
}
class SaveToDbSuccessState extends RegisterStates {}

class SaveToDbErrorState extends RegisterStates {
  final String error;

  SaveToDbErrorState(this.error);
}
class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {

}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}