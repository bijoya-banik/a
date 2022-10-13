class AppState {
  var demoState;
  var unseenNotification;
  bool categoryInitClick;

  List categoryListsRedux = [];

  bool subcategoryInitClick;

  List subcategoryListsRedux = [];

  AppState(
      {this.demoState,
      this.categoryInitClick,
      this.categoryListsRedux,
      this.subcategoryInitClick,
      this.subcategoryListsRedux,
      this.unseenNotification});

  AppState copywith(
      {demoState,
      categoryInitClick,
      categoryListsRedux,
      subcategoryInitClick,
      subcategoryListsRedux,
      unseenNotification}) {


    return AppState(
      demoState: demoState ?? this.demoState,
      categoryInitClick: categoryInitClick ?? this.categoryInitClick,
      categoryListsRedux: categoryListsRedux ?? this.categoryListsRedux,
      subcategoryInitClick: subcategoryInitClick ?? this.subcategoryInitClick,
      subcategoryListsRedux: subcategoryListsRedux ?? this.subcategoryListsRedux,
      unseenNotification:unseenNotification??this.unseenNotification
    );
  }
}
