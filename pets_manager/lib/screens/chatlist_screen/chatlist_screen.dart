// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_is_empty
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_helper.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../chat_screen/chat_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({ Key? key }) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  
  Stream<QuerySnapshot>? chatRoomsStream;
  
  @override
  void initState() {
    super.initState();
    ChatDatabaseModel().getUserChatRooms(Constants.appUser.userId).then((value){
      setState(() {
        chatRoomsStream = value;        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*5, SizeConfig.blockSizeVertical*0, SizeConfig.blockSizeHorizontal*5, 0),
        child: chatMessageList(),
      ),
    );
  }

   Widget chatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? (snapshot.data!.docs.length > 0) ? MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              dynamic cellData = snapshot.data!.docs[index].data();
              String chatUserID = cellData['chatRoomId'];
              chatUserID = chatUserID.replaceFirst("_", "");
              chatUserID = chatUserID.replaceFirst("${Constants.appUser.userId}", "");
              String userName = cellData['${chatUserID}_name'];
              return MessageCell(messageData: snapshot.data!.docs[index].data() as Map<dynamic, dynamic>);
            }
          ),
        ) : Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Center(
            child: Text(
              'No Messages',
              style: TextStyle(
                color : Colors.grey[500],
                fontSize : SizeConfig.fontSize * 2.0,
              ),
            ),
          ),
        )
        : Container();
      }
    );
  }
}

class MessageCell extends StatefulWidget {

  final Map messageData;
  const MessageCell({required this.messageData});

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {

  AppUser chatUser = AppUser();
  String chatUserID = "";
  String chatRoomId = "";
  
  @override
  void initState() {
    super.initState();
    chatRoomId = widget.messageData['chatRoomId'];
    chatUserID = widget.messageData['chatRoomId'];
    chatUserID = chatUserID.replaceFirst("_", "");
    chatUserID = chatUserID.replaceFirst("${Constants.appUser.userId}", "");
    chatUser.name = widget.messageData['${chatUserID}_name'];
    chatUser.oneSignalUserId = widget.messageData['${chatUserID}_token'];
    chatUser.userProfilePicture = widget.messageData['${chatUserID}_picture'];
    chatUser.userId = chatUserID;
    //getUserDetail();
  }

  // void deleteChatCell(BuildContext context) async {
  //   EasyLoading.show(status: '${AppLanguage.getLanguageWord('please_wait')}', maskType: EasyLoadingMaskType.black,);
  //   await ChatDatabaseModel().deleteChatRoom(chatRoomId);
  //   EasyLoading.dismiss();
  // }

  @override
  Widget build(BuildContext context) {
    final lastMsgTime = widget.messageData['lastMessageTimeStamp'].toDate();
    String dateText = timeago.format(lastMsgTime, locale: 'en'); 
    return GestureDetector(
      onTap: (){
        Get.to(ChatScreen(chatUser: chatUser));
      },
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: SizeConfig.blockSizeVertical * 8,
        child: Row(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeVertical * 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: (chatUser.userProfilePicture .isEmpty) ?  AssetImage('assets/user_bg.png') as ImageProvider : CachedNetworkImageProvider(chatUser.userProfilePicture),
                  fit: BoxFit.cover
                )
              ),
            ),
          
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${chatUser.name}',
                              style: TextStyle(
                                color: Constants.appThemeColor,
                                fontSize:  SizeConfig.fontSize * 1.8,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                           Text(
                            '$dateText',
                            style: TextStyle(
                              color: Colors.grey[500], fontSize:  SizeConfig.fontSize * 1.5, fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.8),
                      child: Text(
                        '${widget.messageData['last_msg']}',
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.grey[500], fontSize:  SizeConfig.fontSize * 1.6, fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//   Widget messageCell(int index){
//     return GestureDetector(
//       onTap: (){
//         Get.to(ChatScreen(chatUser: AppUser(),));
//       },
//       child: Container(
//         margin: EdgeInsets.only(top: (index == 0) ? 0 : 15),
//         height: SizeConfig.blockSizeVertical * 8,
//         width: double.infinity,
//         child: Row(
//           children: [
//             Container(
//               height: SizeConfig.blockSizeVertical * 6,
//               width: SizeConfig.blockSizeVertical * 6,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: AssetImage('assets/user_bg.png'),
//                   fit: BoxFit.cover
//                 )
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*3, right: 5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               'Imran Nadeem',
//                               style: TextStyle(
//                                 color: Constants.appThemeColor,
//                                 fontSize:  SizeConfig.fontSize * 1.7,
//                                 fontWeight: FontWeight.w500
//                               ),
//                             ),
//                           ),
//                            Text(
//                             '15 min',
//                             style: TextStyle(
//                               color: Colors.grey[500], fontSize:  SizeConfig.fontSize * 1.3, fontWeight: FontWeight.w500
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.8),
//                       child: Text(
//                         'Are you available for blood donation?',
//                         maxLines: 2,
//                         style: TextStyle(
//                           color: Colors.grey[500], fontSize:  SizeConfig.fontSize * 1.5, fontWeight: FontWeight.w500
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }