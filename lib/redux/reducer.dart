


import 'package:bahrain_admin/redux/action.dart';
import 'package:bahrain_admin/redux/state.dart';

AppState reducer(AppState state, dynamic action){

  if(action is DemoAction){
    return state.copywith(
      demoState: action.demoAction
    );
  }

  
       else  if(action is CategoryListRedux){
    return state.copywith(
      categoryListsRedux: action.categoryList
    );
  }

        else  if(action is CategoryInitClick){
    return state.copywith(
      categoryInitClick: action.categoryInitClick
    );
  }

  
       else  if(action is SubCategoryListRedux){
    return state.copywith(
      subcategoryListsRedux: action.subcategoryList
    );
  }

        else  if(action is SubCategoryInitClick){
    return state.copywith(
      subcategoryInitClick: action.subcategoryInitClick
    );
  }

          else  if(action is UnseenAction){
    return state.copywith(
      unseenNotification: action.unseenAction
    );
  }
  
  return state;
}