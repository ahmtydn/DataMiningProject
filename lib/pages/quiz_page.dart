import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verimadenciligi/model/sorular_model.dart';
import 'package:verimadenciligi/model/survey_data.dart';
import 'package:verimadenciligi/pages/answer_page.dart';
import 'package:verimadenciligi/pages/home_page.dart';
import 'package:verimadenciligi/pages/question_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var valueFirst = null;
  bool isLoading = true;
  Map? mapsSoru;
  List<SoruDatum>? listData;
  SorularModel? sorularModel;
  PageController pageController = PageController(initialPage: 0);
  List<SurveyDatum> quizList = [];

  Future<void> getJson() async {
    final jsonString = await rootBundle.loadString('asset/jsonData/soru.json');
    sorularModel = sorularModelFromJson(jsonString);
    listData = sorularModel!.soruData;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.amber[600],
            appBar: AppBar(
              centerTitle: true,
              title: Text("Veri Madenciliği"),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(130),
                ),
              ),
              backgroundColor: Colors.blueGrey.shade900,
            ),
            body: PageView.builder(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listData!.length,
              itemBuilder: (context, index) {
                print(quizList);
                return QuizPageHelper(
                    listQuiz: quizList,
                    indexZex: index,
                    size: size,
                    listData: listData,
                    pageController: pageController);
              },
            ));
  }
}

class QuizPageHelper extends StatelessWidget {
  QuizPageHelper({
    Key? key,
    required this.size,
    required this.listData,
    required this.pageController,
    required this.indexZex,
    required this.listQuiz,
  }) : super(key: key);

  final Size size;
  final List<SurveyDatum> listQuiz;
  SurveyData? surveyData;
  final int indexZex;
  final List<SoruDatum>? listData;
  final PageController pageController;

  void saveSurveyData() async {
    var userID = await FirebaseAuth.instance.currentUser!.uid;
    print(userID);
    var jsonData = jsonEncode(surveyData!);
    var url =
        "https://datamining-367013-default-rtdb.firebaseio.com/Data/${userID}/surveyData.json";
    var httpClient = http.Client();
    var res = await httpClient.post(Uri.parse(url), body: jsonData);
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[600],
                // border: Border.all(color: Colors.white),
              ),
              width: size.width,
              height: 280,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      top: 160,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            )),
                        width: size.width,
                        height: size.height,
                      )),
                  Positioned(
                    top: 25,
                    left: 20,
                    right: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        QuestionPage(
                            questionText: "${listData![indexZex].soru}"),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 35,
                      left: 105,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade900,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            )),
                        width: 160,
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Soru: ${indexZex + 1}/${listData!.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 25,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: size.width - 110,
              height: size.height,
              child: ListView.separated(
                  separatorBuilder: (context, index2) => const SizedBox(
                        height: 15,
                      ),
                  itemCount: listData![indexZex].cevaplar.length,
                  itemBuilder: (context, indeks) {
                    return GestureDetector(
                        onTap: () {
                          if (listData!.length ==
                              pageController.page!.toInt() + 1) {
                            listQuiz.add(SurveyDatum(
                                soruId: (indexZex + 1).toString(),
                                soru: listData![indexZex].soru.toString(),
                                answer: listData![indexZex]
                                    .cevaplar[indeks]
                                    .cevap
                                    .toString()));
                            surveyData = SurveyData(surveyData: listQuiz);

                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: 'Anket Tamamlandı',
                              desc: 'Anketi tamamladığınız için teşekkürler :)',
                              buttonsTextStyle:
                                  const TextStyle(color: Colors.black),
                              dismissOnTouchOutside: false,
                              btnOkOnPress: () {
                                saveSurveyData();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              },
                            ).show();
                          } else {
                            pageController.nextPage(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.easeOutCubic);
                            listQuiz.add(SurveyDatum(
                                soruId: (indexZex + 1).toString(),
                                soru: listData![indexZex].soru.toString(),
                                answer: listData![indexZex]
                                    .cevaplar[indeks]
                                    .cevap
                                    .toString()));
                          }
                        },
                        child: AnswerPage(
                            answerText:
                                "${listData![indexZex].cevaplar[indeks].cevap}"));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
