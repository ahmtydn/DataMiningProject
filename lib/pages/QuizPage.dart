import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verimadenciligi/model/sorularModel.dart';
import 'package:verimadenciligi/pages/answerPage.dart';
import 'package:verimadenciligi/pages/homePage.dart';
import 'package:verimadenciligi/pages/questionPage.dart';

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
                return QuizPageHelper(
                    indexZex: index,
                    size: size,
                    listData: listData,
                    pageController: pageController);
              },
            ));
  }
}

class QuizPageHelper extends StatelessWidget {
  const QuizPageHelper({
    Key? key,
    required this.size,
    required this.listData,
    required this.pageController,
    required this.indexZex,
  }) : super(key: key);

  final Size size;
  final int indexZex;
  final List<SoruDatum>? listData;
  final PageController pageController;

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
                          if(listData!.length==pageController.page!.toInt()+1){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

                          }
                          pageController.nextPage(
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic);
                          print(listData![indexZex].cevaplar[indeks].cevap);
                        },
                        child: AnswerPage(
                            answerText:
                                "${listData![indexZex].cevaplar[indeks].cevap}"));
                  }),
            ),
            /* ElevatedButton(onPressed: (){
         var services=AuthServices();
         services.logout();
        }, child: Text("Çıkış"))*/
          ],
        ),
      ),
    );
  }
}
