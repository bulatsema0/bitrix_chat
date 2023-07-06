import 'package:bitrix_chat/app/blueprints/api_response.dart';
import 'package:bitrix_chat/app/blueprints/base_viewmodel.dart';
import 'package:bitrix_chat/widgets/basic_error_widget.dart';
import 'package:bitrix_chat/widgets/box_container.dart';
import 'package:bitrix_chat/widgets/circle_card_widget.dart';
import 'package:bitrix_chat/widgets/custom_circular_progress_indicator.dart';
import 'package:bitrix_chat/widgets/custom_transition_switcher.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class BasePageView<T extends BaseViewModel> extends StatelessWidget {
  final Widget? floatingActionButton;
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? content;
  final bool haveScaffold;
  final bool showCircleCard;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool fabRequiresStatus;
  final bool endDrawerEnableOpenDragGesture;
  final bool shouldWaitForGetData;
  final BottomNavigationBar? bottomNagitonBar;
  final Color? backgroundColor;

  const BasePageView({
    Key? key,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.content,
    this.haveScaffold = true,
    this.showCircleCard = true,
    this.scaffoldKey,
    this.fabRequiresStatus = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.shouldWaitForGetData = true,
    this.bottomNagitonBar,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responseStatus =
        context.select<T, ResponseStatus>((value) => value.responseStatus);

    return haveScaffold
        ? Scaffold(
            key: scaffoldKey,
            floatingActionButton: !fabRequiresStatus
                ? floatingActionButton
                : responseStatus.status != null && responseStatus.status!
                    ? floatingActionButton
                    : null,
            appBar: appBar,
            backgroundColor: backgroundColor,
            bottomNavigationBar: bottomNagitonBar,
            drawer: drawer,
            endDrawer: endDrawer,
            endDrawerEnableOpenDragGesture: fabRequiresStatus
                ? (responseStatus.status ?? false) &&
                    endDrawerEnableOpenDragGesture
                : endDrawerEnableOpenDragGesture,
            body: _PageLoadingWidget<T>(
              content: content,
              showCircleCard: showCircleCard,
            ),
          )
        : _PageLoadingWidget<T>(
            content: content,
            showCircleCard: showCircleCard,
            shouldWaitForGetData: shouldWaitForGetData,
          );
  }
}

class _PageLoadingWidget<T extends BaseViewModel> extends StatefulWidget {
  final Widget? content;
  final bool? showCircleCard;
  final bool shouldWaitForGetData;
  const _PageLoadingWidget(
      {Key? key,
      required this.content,
      this.showCircleCard,
      this.shouldWaitForGetData = true})
      : super(key: key);

  @override
  __PageLoadingWidgetState<T> createState() => __PageLoadingWidgetState<T>();
}

class __PageLoadingWidgetState<T extends BaseViewModel>
    extends State<_PageLoadingWidget> {
  late T _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<T>();
    // ignore: invalid_use_of_protected_member
    _provider.getData();
  }

  @override
  void dispose() {
    // ignore: invalid_use_of_protected_member
    _provider.disposeModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewDidLoad = context.select<T, bool>((value) => value.viewDidLoad);

    return widget.shouldWaitForGetData
        ? CustomTransitionSwitcher(
            child: !viewDidLoad
                ? const BoxContainer(child: CustomCircularProgressIndicator())
                : _provider.responseStatus.status == null ||
                        _provider.responseStatus.status!
                    ? _CircleLoadingWidget<T>(
                        content: widget.content,
                        showCircleCard: widget.showCircleCard,
                      )
                    : BasicErrorWidget(
                        error: _provider.responseStatus.errorMsg),
          )
        : _CircleLoadingWidget<T>(
            content: widget.content,
            showCircleCard: widget.showCircleCard,
          );
  }
}

class _CircleLoadingWidget<T extends BaseViewModel> extends StatelessWidget {
  final Widget? content;
  final bool? showCircleCard;
  const _CircleLoadingWidget(
      {Key? key, required this.content, this.showCircleCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showCircleCard!) {
      return content!;
    }

    return Selector<T, bool>(
      selector: (_, model) => model.loading,
      builder: (context, value, child) {
        return CircleCardWidget(
          showCard: value,
          child: child,
        );
      },
      child: content,
    );
  }
}
