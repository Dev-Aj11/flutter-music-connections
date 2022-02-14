import 'package:flutter/material.dart';
import 'package:music_connections/models/social_media.dart';
import '../../constants.dart';
import 'package:url_launcher/url_launcher.dart';
import './band_feedback.dart';
import '../../models/band.dart';
import '../../controllers/band_info_controller.dart';

class BandInfo extends StatefulWidget {
  @override
  State<BandInfo> createState() => _BandInfoState();
}

class _BandInfoState extends State<BandInfo> {
  BandInfoController bandInfoController = BandInfoController();
  bool bandInfoLoaded = false;

  @override
  void initState() {
    super.initState();
    _getBandInfo();
  }

  void _getBandInfo() async {
    await bandInfoController.getBandInfoFromFb();
    setState(() {
      bandInfoLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Band bandInfo = bandInfoController.getBandInfo();
    List<SocialMediaChip> socialChips = [];
    if (bandInfoLoaded) {
      socialChips = _createSocialMediaChips(bandInfo);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Band", style: kSectionHeadingStyle),
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('${bandInfo.bandImageUrl}'),
                    radius: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // need to move this up
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${bandInfo.bandName}"),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${bandInfo.bandDesc}",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Find us on",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 1,
                        children: socialChips
                            .where((element) =>
                                (element.type != SocialMediaEnum.venmo))
                            .toList(),
                      ),
                      Wrap(
                        children: [
                          Text(
                            "Love what we play? We accept tips on:",
                          ),
                          (bandInfoLoaded)
                              ? socialChips
                                  .where((element) =>
                                      (element.type == SocialMediaEnum.venmo))
                                  .toList()[0]
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        BandFeedback(),
      ],
    );
  }

  List<SocialMediaChip> _createSocialMediaChips(Band bandInfo) {
    List<SocialMediaChip> socialsWidgets = [];
    for (SocialMedia socialInfo in bandInfo.socials) {
      socialsWidgets.add(SocialMediaChip(socialInfo.type));
    }
    return socialsWidgets;
  }
}

class SocialMediaChip extends StatelessWidget {
  final SocialMediaEnum type;
  SocialMediaChip(this.type);

  @override
  Widget build(BuildContext context) {
    SocialMedia socialInfo = SocialMedia(type: this.type);
    return InputChip(
      avatar: CircleAvatar(
        backgroundColor: Colors.grey.shade100,
        child: socialInfo.icon,
      ),
      label: Text("${socialInfo.name}"),
      onPressed: () async {
        var url = "${socialInfo.url}";
        if (!await launch(url)) throw 'Could now launch $url';
      },
      backgroundColor: Colors.grey.shade100,
    );
  }
}
