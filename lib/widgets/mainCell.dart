import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<MaterialColor> cols = [
  Colors.red,
  Colors.orange,
  //Colors.amber,
  //Colors.lime,
  Colors.green,
  Colors.teal,
  Colors.cyan,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  //Colors.grey
];

class mainCell extends StatelessWidget {
  mainCell({
    Key? key,
    required this.pageController,
    required this.index,
    required this.page,
  }) : super(key: key);

  PageController pageController;
  int index;
  dynamic page; // != Widget
  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width* pageController.viewportFraction;//MediaQuery.of(context).size.width;
    double boxRadius = 100.0;
    MaterialColor color = cols[index%cols.length];

    String title = page.title;
    Widget pageWidget = page.page;
    Widget cardWidget = page.card;

    return AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          double value = 0;
          if (pageController.position.haveDimensions) value = pageController.offset/pageWidth - index;//_pageController.page! - index;
          return Transform(
            transform: Matrix4.identity()..setEntry(3, 2, 0.002)..rotateY(-value),
            alignment: Alignment.center,
/*view*/      child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
  /*title*/       Expanded(
                    flex: 3,
                    child : Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 50,
                          color: color.shade300,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
  /*card*/       Expanded(
                    flex: 7,
                    child: Container(
                      //padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color.shade300,
                        borderRadius: BorderRadius.circular(boxRadius)
                      ),
                      /*
                      
    print("S : page.provider.get()");
    page.provider.get().then(
      (value)=>print("E : page.provider.get()")
    );
                      */
                      child: Column(
                        children: [
                          Expanded(
                            child : Container(
                              color: Colors.teal.withOpacity(0.03),
                              padding: EdgeInsets.fromLTRB(30, 30, 30, 00),
                              child: Column(
                                children: <Widget>[
                                  cardWidget,
                                ],
                              )
                            )
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => pageWidget));
                            },
                            minWidth: double.infinity,
                            height: boxRadius,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(boxRadius))),
                            child: Text("[$title]"),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),

            )
          );
        },
      );

    

  }
}