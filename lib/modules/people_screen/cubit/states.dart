abstract class PeopleStates {}

class PeopleInitialState extends PeopleStates {}
class SocialGetAllUserSuccessState extends PeopleStates {}
class GetUsersListState extends PeopleStates {}
class GetChatsListState extends PeopleStates {}
class SocialGetAllUserErrorState extends PeopleStates {
  final String error;
  SocialGetAllUserErrorState(this.error);
}
class SocialSendMessageSuccessState extends PeopleStates {}
class SocialSendMessageErrorState extends PeopleStates {
  final String error;
  SocialSendMessageErrorState(this.error);
}

