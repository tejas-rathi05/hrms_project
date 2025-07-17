import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';

class MyApp_group extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp_group> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MainExample(),
    );
  }
}

class MainExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainExampleState();
  }
}

class _MainExampleState extends State<MainExample>
    with TickerProviderStateMixin {
  late TabController tabController;
  ValueNotifier<int> current = ValueNotifier(0);
  final customController = CustomGroupController(
    isMultipleSelection: false,
    //initSelectedItem: "basics",
  );
  final List<String> drawerItems = ["basics", "custom"];

  void tabChanged() {
    current.value = tabController.index;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: current.value,
      length: drawerItems.length,
      vsync: this,
    );
    tabController.addListener(tabChanged);
    // customController.listen((value) {
    //   final index = drawerItems.indexOf(value);
    //   if (index != -1) {
    //     tabController.index = index;
    //     Navigator.pop(context);
    //   }
    // });
  }

  @override
  void dispose() {
    tabController.removeListener(tabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ValueListenableBuilder<int>(
          valueListenable: current,
          builder: (ctx, value, _) {
            return Column(
              children: [
                SizedBox(
                  height: 56,
                ),
                Expanded(
                  child: CustomGroupedCheckbox<String>(
                    controller: customController,
                    itemBuilder: (ctx, index, isSelected, isDisabled) {
                      return ListTile(
                        title: Text(
                          drawerItems[index],
                          style: TextStyle(
                            color: value == index ? Colors.blue : null,
                          ),
                        ),
                      );
                    },
                    itemExtent: 64,
                    values: drawerItems,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Text("examples"),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[_SimpleGrouped(), _DialogExample()],
      ),
    );
  }
}

class _SimpleGrouped extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GroupController controller = GroupController(initSelectedItem: [2]);
    GroupController switchController = GroupController();
    GroupController chipsController =
        GroupController(isMultipleSelection: true);
    GroupController multipleCheckController = GroupController(
      isMultipleSelection: true,
      initSelectedItem: List.generate(10, (index) => index),
    );

    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SimpleGroupedCheckbox<int>(
            controller: controller,
            //groupTitle:"Basic",
            onItemSelected: (data) {
              // if (data == 1) {
              //   controller.disabledItemsByTitles(["5"]);
              // } else if (data == 4) {
              //   controller.enabledItemsByTitles(["5", "2"]);
              //   controller.disabledItemsByTitles(["1"]);
              // } else if (data == 2) {
              //   controller.enabledItemsByTitles(["1"]);
              // }
            },
            //disableItems: ["5"],
            itemsTitle: ["1", "2", "4", "5"],
            values: [1, 2, 4, 5],
            // groupStyle: GroupStyle(
            //     activeColor: Colors.red,
            //     itemTitleStyle: TextStyle(fontSize: 13)),

          ),
          SimpleGroupedCheckbox<int>(
            controller: multipleCheckController,
            itemsTitle: List.generate(10, (index) => "$index"),
            values: List.generate(10, (index) => index),
            //activeColor: Colors.green,
            groupTitle: "expanded multiple checkbox selection",
            //groupTitleStyle: TextStyle(color: Colors.orange),
            helperGroupTitle: false,
            onItemSelected: (data) {},
            isExpandableTitle: false,
          ),
          Divider(),
          SimpleGroupedChips<int>(
            controller: chipsController,
            values: List.generate(7, (index) => index),
            // chipGroupStyle: ChipGroupStyle.minimize(
            //   backgroundColorItem: Colors.red[400],
            //   itemTitleStyle: TextStyle(
            //     fontSize: 14,
            //   ),
            // ),
            onItemSelected: (values) {}, itemsTitle: [],
          ),
          Divider(),
          Text("grouped switch"),
          SimpleGroupedSwitch<int>(
            controller: switchController,
            itemsTitle: List.generate(10, (index) => "$index"),
            values: List.generate(10, (index) => index),
            disableItems: [2],
            // groupStyle: SwitchGroupStyle(
            //   itemTitleStyle: TextStyle(
            //     fontSize: 16,
            //     color: Colors.blue,
            //   ),
            //   activeColor: Colors.red,
            // ),
            onItemSelected: (values) {},
          ),
        ],
      ),
    );
  }
}

class _DialogExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          onPressed: () async {
            var values = await showDialogGroupedCheckbox(
                context: context,
                cancelDialogText: "cancel",
                isMultiSelection: true,
                itemsTitle: List.generate(15, (index) => "$index"),
                submitDialogText: "select",
                dialogTitle: Text("example dialog"),
                values: List.generate(15, (index) => index));
            if (values != null) {}
          },
          child: Text("show dialog checkbox grouped"),
        ),
      ],
    );
  }
}
