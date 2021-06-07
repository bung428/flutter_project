import 'package:flutter/material.dart';
import 'package:flutter_scrollbar/webscrollbar.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff101010),
      body: Container(
        child: Stack(
          children: [
            WebScrollBar(
              visibleHeight: Get.height,
              controller: controller,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 43.0,
                      ),
                      Text(
                        'Feel free to contact me anytimes',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Get in Touch',
                        style: TextStyle(
                            fontSize: 46.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(
                        height: 112.0,
                      ),
                      Get.width > 1000
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MessageMe(),
                              SizedBox(width: 45.0,),
                              ContactInfo(),
                            ],
                          )
                        : Column(
                           children: [
                             MessageMe(),
                             SizedBox(width: 45.0,),
                             ContactInfo(),
                           ],
                          )
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}

class MessageMe extends StatefulWidget {
  @override
  _MessageMeState createState() => _MessageMeState();
}

class _MessageMeState extends State<MessageMe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: MediaQuery.of(context).size.width > 1000
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Message me',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 10.0,),
          Row(
            children: [
              CustomTextFormField(hint: 'Name'),
              SizedBox(width: 25.0,),
              CustomTextFormField(hint: 'Email'),
              SizedBox(height: 25.0,),
              Container(
                height: 50.0,
                child: CustomTextFormField(
                  hint: 'Subject',
                  max: 25,
                ),
              ),
              SizedBox(height: 25.0,),
              Container(
                height: 200.0,
                child: CustomTextFormField(
                  hint: 'Message',
                  max: 25,
                ),
              ),
              SizedBox(height: 25.0,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xff009c66),
                  ),
                  child: Center(
                    child: Text(
                      'Send Message',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.0,),
        ],
      ),
    );
  }
}

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: MediaQuery.of(context).size.width > 1000
        ? MediaQuery.of(context).size.width * 0.3
        : MediaQuery.of(context).size.width * 0.65,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Info',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15.0,),
            Text(
              'Always available for freelance work if the right project comes alone.',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15.0,),
            ContactCard(
              head: 'Name',
              sub: 'Email Smith',
              icon: Icons.assignment_ind_outlined,
            ),
            ContactCard(
              head: 'Location',
              sub: '4155 Mann Island, Liverpool, United Kingdom',
              icon: Icons.location_on,
            ),
            ContactCard(
              head: 'Call Me',
              sub: '+44 1632 967704',
              icon: Icons.phone_outlined,
            ),
            ContactCard(
              head: 'Email Me',
              sub: 'example@example.com',
              icon: Icons.send_outlined,
            ),
          ],
        ),
      ),
    );
  }
}


class CustomTextFormField extends StatefulWidget {
  final String? hint;
  final int? max;
  CustomTextFormField({this.hint, this.max});
  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xff161616),
        child: TextFormField(
          maxLines: widget.max ?? 1,
          scrollPadding: EdgeInsets.all(0),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent)
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Color(0xff6c6c6c),
              fontSize: 20.0,
              fontWeight: FontWeight.w500
            ),
            prefix: Container(width: 30.0,)
          ),
        ),
      )
    );
  }
}

class ContactCard extends StatefulWidget {
  final String? head;
  final String? sub;
  final IconData? icon;
  ContactCard({this.head, this.sub, this.icon});
  @override
  _ContactCardState createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      width: MediaQuery.of(context).size.width > 1000
        ? MediaQuery.of(context).size.width * 0.3
        : MediaQuery.of(context).size.width * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: 35,
            color: Color(0xff009e66),
          ),
          SizedBox(width: 20.0,),
          Container(
            width: 3.0,
            color: Color(0xff161616),
          ),
          SizedBox(width: 20.0,),
          Container(
            width: MediaQuery.of(context).size.width > 1000
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.5 - 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                Text(
                  widget.head ?? '',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.sub ?? '',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

