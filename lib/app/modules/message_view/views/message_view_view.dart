import 'package:agora_task/app/common/app_fontWeight.dart';
import 'package:agora_task/app/common/app_fontsize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/message_view_controller.dart';

class MessageViewView extends GetView<MessageViewController> {
  const MessageViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Aditya Kumar Harijan',
      //     style:TextStyle(
      //       fontWeight: AppFontWeight.font3
      //     )
      //   ),
      //   // centerTitle: true,
      // ),
      body: Column(
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.65,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )
                      )
                    ),
                  ),
                  SizedBox(
            // height: 10
            height: MediaQuery.of(context).size.height * 0.01,
          ),

                  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aditya Kumar Harijan',
                style: TextStyle(
                  fontSize: AppFontSize.size1,
                  fontWeight: AppFontWeight.font3
                ),
                )
            ],
          ),
                ],
              ),
            ],
          ),
          
          
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.23,
                    decoration: BoxDecoration(
                      color:Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 1,
                      )
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    "Audio Call"
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.23,
                    decoration: BoxDecoration(
                      color:Colors.black,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 1,
                      )
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'Video Call'
                  )

                ],
              )
            ],
          )
        ],
      )
      
    );
  }
}
