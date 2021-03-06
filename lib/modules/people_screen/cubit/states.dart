abstract class PeopleStates {}

class PeopleInitialState extends PeopleStates {}
class SocialGetAllUserSuccessState extends PeopleStates {}
class GetUsersListState extends PeopleStates {}
class GetChatsListState extends PeopleStates {}
class ChangeSendIconState extends PeopleStates {}
class PickChatImageSuccessState extends PeopleStates {}
class UploadChatImageSuccessState extends PeopleStates {}
class UploadChatImageErrorState extends PeopleStates {}
class ChangeBetweenSendAndVoiceIcon extends PeopleStates {}
class ChangeHintTextToTypeHere extends PeopleStates {}
class ChangeHintTextToRecording extends PeopleStates {}
class JustAudioPlayerState extends PeopleStates {}
class JustAudioPlayerPositionState extends PeopleStates {}
class JustAudioPlayerStopState extends PeopleStates {}
class ChangeIconDataToPauseState extends PeopleStates {}
class JustAudioPlayerSpeedState extends PeopleStates {}
class ChangeIconDataToPlayState extends PeopleStates {}
class IsPlayingChangeState extends PeopleStates {}
class OnDurationChangedState extends PeopleStates {}
class OnAudioPositionChangedState extends PeopleStates {}

class PickChatImageErrorState extends PeopleStates {
  final String error;
  PickChatImageErrorState(this.error);
}
class SocialGetAllUserErrorState extends PeopleStates {
  final String error;
  SocialGetAllUserErrorState(this.error);
}
class SocialSendMessageSuccessState extends PeopleStates {}
class SocialSendMessageErrorState extends PeopleStates {
  final String error;
  SocialSendMessageErrorState(this.error);
}

