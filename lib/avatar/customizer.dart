import "package:avatar_maker/avatar_maker.dart";
import "package:avatar_maker/src/customizer/widgets/customizer_appbar.dart";
import "package:avatar_maker/src/customizer/widgets/customizer_bottom_navbar.dart";
import "package:eurointegrate_app/components/consts.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class Customizer extends StatelessWidget {
  final int myPoints;
  final AvatarMakerController avatarMakerController;
  final TabController tabController;
  final AvatarMakerThemeData theme;
  final double? scaffoldHeight;
  final void Function(
    PropertyItem newSelectedItem,
    PropertyCategoryIds categoryId,
  ) onTapOption;
  final void Function(bool isLeft) onArrowTap;

  const Customizer({
    required this.myPoints,
    required this.avatarMakerController,
    required this.tabController,
    required this.theme,
    required this.scaffoldHeight,
    required this.onTapOption,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var attributeGrids = <Widget>[];
    var navbarWidgets = <Widget>[];

    /// Create the tab icon and content for each category.
    for (final (categoryIndex, propertyCategory)
        in avatarMakerController.displayedPropertyCategories.indexed) {
      /// Number of options available for said [attribute]
      /// Eg: "Hairstyle" attribute has 38 options
      var attributeListLength = propertyCategory.properties!.length;

      PropertyItem selectedItem =
          avatarMakerController.selectedOptions[propertyCategory.id]!;

      /// Build the main Tile Grid with all the options from the attribute
   var _tileGrid = GridView.builder(
  physics: theme.scrollPhysics,
  itemCount: attributeListLength,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: theme.gridCrossAxisCount,
    crossAxisSpacing: 4.0,
    mainAxisSpacing: 4.0,
  ),
  itemBuilder: (BuildContext context, int index) {
    // Calcular os pontos para cada item
    var itens = 1;
    if(propertyCategory.properties!.length < 10){itens = propertyCategory.properties!.length;}
    int points = index * 10 * itens;
    bool isBlocked = points > myPoints;

    return InkWell(
      onTap: isBlocked
          ? null
          : () => onTapOption(
                propertyCategory.properties![index], propertyCategory.id),
      child: Stack(
        children: [
          Container(
            decoration: index == propertyCategory.properties!.indexOf(selectedItem)
                ? theme.selectedTileDecoration
                : theme.unselectedTileDecoration,
            margin: theme.tileMargin,
            padding: theme.tilePadding,
            child: SvgPicture.string(
              avatarMakerController.getComponentSVG(propertyCategory.id, index),
              height: 2000,
              semanticsLabel: 'Your AvatarMaker',
              placeholderBuilder: (context) => Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
          // Exibir pontos no canto superior direito
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: [
                  Text(
                    '$points',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Icon(Icons.star, size: 12, color: Colors.amber,)
                ],
              ),
            ),
          ),
          // Usar Visibility para controlar se o widget é mostrado
          Visibility(
            visible: isBlocked,
            child: Positioned(
              top: 30,
              left: 5,
              child: Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Icon(Icons.lock, size: 12, color: Colors.yellow,),
              ),
            ),
          ),
        ],
      ),
    );
  },
);


      /// Builds the icon for the attribute to be placed in the bottom row
      var bottomNavWidget = SvgPicture.asset(
        propertyCategory.iconFile!,
        package: 'avatar_maker',
        height: (scaffoldHeight != null
            ? scaffoldHeight! / theme.heightFactor * 0.04
            : size.height * 0.04),
        colorFilter: ColorFilter.mode(
            categoryIndex == tabController.index
                ? azulEuro
                : theme.unselectedIconColor,
            BlendMode.srcIn),
        semanticsLabel: propertyCategory.name,
      );

      /// Add all the initialized widgets to the state
      attributeGrids.add(_tileGrid);
      navbarWidgets.add(bottomNavWidget);
    }

    return Container(
      decoration: theme.boxDecoration,
      clipBehavior: Clip.hardEdge,
      child: DefaultTabController(
        length: attributeGrids.length,
        child: Scaffold(
          key: const ValueKey('AvatarMakerCustomizer'),
          backgroundColor: theme.secondaryBgColor,
          appBar: CustomizerAppbar(
            nbrCategories:
                avatarMakerController.displayedPropertyCategories.length,
            title: avatarMakerController
                .displayedPropertyCategories[tabController.index].name!,
            theme: theme,
            tabIndex: tabController.index,
            onArrowTap: onArrowTap,
          ),
          body: TabBarView(
            physics: theme.scrollPhysics,
            controller: tabController,
            children: attributeGrids,
          ),
          bottomNavigationBar: CustomizerBottomNavbar(
            navbarWidgets: navbarWidgets,
            tabController: tabController,
            theme: theme,
          ),
        ),
      ),
    );
  }
}
