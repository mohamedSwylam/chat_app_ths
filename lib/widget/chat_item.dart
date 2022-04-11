Widget buildChatItem(SocialUserModel model,context) =>
    InkWell(
      onTap: (){
        navigateTo(context, ChatDetailsScreen(
          userModel: model,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  '${model.image}'),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              '${model.name}',
              style: TextStyle(
                  height: 1.4, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
}