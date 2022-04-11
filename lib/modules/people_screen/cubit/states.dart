abstract class PeopleStates {}

class PeopleInitialState extends PeopleStates {}
class SocialGetAllUserSuccessState extends PeopleStates {}
class SocialGetAllUserErrorState extends PeopleStates {
  final String error;
  SocialGetAllUserErrorState(this.error);
}

