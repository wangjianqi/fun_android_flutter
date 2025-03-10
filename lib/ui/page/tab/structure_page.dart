import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fun_android/config/router_config.dart';
import 'package:fun_android/model/navigation_site.dart';
import 'package:fun_android/model/tree.dart';
import 'package:fun_android/provider/provider_widget.dart';
import 'package:fun_android/provider/view_state_widget.dart';
import 'package:fun_android/view_model/structure_model.dart';

/// 体系
class StructurePage extends StatefulWidget {
  @override
  _StructurePageState createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage>
    with AutomaticKeepAliveClientMixin {
  List<String> tabs = ['体系', '导航'];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: TabBar(
                isScrollable: true,
                tabs: List.generate(
                    tabs.length,
                    (index) => Tab(
                          text: tabs[index],
                        )),
              )),
          body: TabBarView(
              children: [TreeCategoryList(), NavigationSiteCategoryList()])),
    );
  }
}
/// 体系->体系
class TreeCategoryList extends StatefulWidget {
  @override
  _TreeCategoryListState createState() => _TreeCategoryListState();
}

class _TreeCategoryListState extends State<TreeCategoryList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<StructureCategoryModel>(
        model: StructureCategoryModel(),
        onModelReady: (model) {
          model.initData();
        },
        builder: (context, model, child) {
          if (model.busy) {
            return Center(child: CircularProgressIndicator());
          } else if (model.error) {
            return ViewStateWidget(onPressed: model.initData());
          }
          return Scrollbar(
            child: ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: model.list.length,
                itemBuilder: (context, index) {
                  Tree item = model.list[index];
                  return TreeCategoryWidget(item);
                }),
          );
        });
  }
}

class TreeCategoryWidget extends StatelessWidget {
  final Tree tree;

  TreeCategoryWidget(this.tree);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tree.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          Wrap(
              spacing: 10,
              children: List.generate(
                  tree.children.length,
                  (index) => ActionChip(
                        onPressed: () {
                          Navigator.of(context).pushNamed(RouteName.treeList,
                              arguments: [tree, index]);
                        },
                        label: Text(
                          tree.children[index].name,
                          maxLines: 1,
                        ),
                      )))
        ],
      ),
    );
  }
}


/// 体系->公众号
class NavigationSiteCategoryList extends StatefulWidget {
  @override
  _NavigationSiteCategoryListState createState() =>
      _NavigationSiteCategoryListState();
}

class _NavigationSiteCategoryListState extends State<NavigationSiteCategoryList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<NavigationSiteModel>(
        model: NavigationSiteModel(),
        onModelReady: (model) {
          model.initData();
        },
        builder: (context, model, child) {
          if (model.busy) {
            return Center(child: CircularProgressIndicator());
          } else if (model.error) {
            return ViewStateWidget(onPressed: model.initData());
          }
          return Scrollbar(
            child: ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: model.list.length,
                itemBuilder: (context, index) {
                  NavigationSite item = model.list[index];
                  return NavigationSiteCategoryWidget(item);
                }),
          );
        });
  }
}

class NavigationSiteCategoryWidget extends StatelessWidget {
  final NavigationSite site;

  NavigationSiteCategoryWidget(this.site);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            site.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
          Wrap(
              spacing: 10,
              children: List.generate(
                  site.articles.length,
                  (index) => ActionChip(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              RouteName.articleDetail,
                              arguments: site.articles[index]);
                        },
                        label: Text(
                          site.articles[index].title,
                          maxLines: 1,
                        ),
                      )))
        ],
      ),
    );
  }
}
