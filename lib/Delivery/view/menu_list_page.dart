import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/commonType.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

import '../../Common/widget/floating_bottom_button.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';
import '../my_deliver_provider.dart';
import '../repository/store_repository.dart';
import 'menu_basket_page.dart';
import 'menu_option_page.dart';

class MenuListPage extends ConsumerStatefulWidget {
  const MenuListPage({
    Key? key,
    required this.storeId,
  }) : super(key: key);
  final String storeId;

  @override
  ConsumerState createState() => _MenuListPageState();
}

class _MenuListPageState extends ConsumerState<MenuListPage> {
  LoadState loadState = LoadState.loading;
  StoreMenus? storeMenus;

  @override
  void initState() {
    super.initState();
    getStoreMenuList();
  }

  getStoreMenuList() {
    ref
        .read(storeRepositoryProvider)
        .getStoreMenuList(widget.storeId)
        .then((value) {
      setState(() {
        storeMenus = value;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loadState = LoadState.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadState == LoadState.loading && storeMenus == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (storeMenus == null || loadState == LoadState.error) {
      return Scaffold(
        body: const Center(child: Text('에러')),
      );
    }
    List<String> sections = storeMenus!.sections;
    List<OrderMenu> orderMenus = ref.watch(postOrderNotifierProvider).orders;
    return Scaffold(
      appBar: customAppBar(context, title: storeMenus!.name),
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('예상 배달비 : ${storeMenus!.fee}원',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54)),
                  Text('최소 배달 금액 : ${storeMenus!.minOrder}원',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final menuList = storeMenus!.getMenuBySection(sections[index]);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      color: Colors.grey[200],
                      child: Text(sections[index]),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            menuList[index].name,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          trailing: Text(
                            '${menuList[index].price}원',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            //navigate to menu option page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MenuOptionPage(
                                  storeId: widget.storeId,
                                  menuName: menuList[index].name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(height: 2);
                      },
                    ),
                  ],
                );
              },
              childCount: sections.length,
            ),
          ),
        ],
      ),
      floatingActionButton: orderMenus.isNotEmpty
          ? customFloatingBottomButton(
              context,
              child: floatingButtonLabel((orderMenus.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.quantity)).toString()),
              onPressed: navigateToBasket,
            )
          : null,
      floatingActionButtonLocation: orderMenus.isNotEmpty
          ? FloatingActionButtonLocation.centerFloat
          : null,
    );
  }

  navigateToBasket() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => MenuBasketPage(storeName: storeMenus!.name)),
    );
  }

  Widget floatingButtonLabel(badgeContent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Badge(
            badgeContent: Text(badgeContent),
            child: const Icon(Icons.shopping_cart)),
        const SizedBox(width: 16),
        Text(
          '장바구니',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}