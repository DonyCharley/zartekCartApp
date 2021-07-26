class Restaurants {
  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String tableId;
  String tableName;
  String branchName;
  String nexturl;
  List<TableMenuList> tableMenuList;

  Restaurants(
      {this.restaurantId,
      this.restaurantName,
      this.restaurantImage,
      this.tableId,
      this.tableName,
      this.branchName,
      this.nexturl,
      this.tableMenuList});

  Restaurants.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantImage = json['restaurant_image'];
    tableId = json['table_id'];
    tableName = json['table_name'];
    branchName = json['branch_name'];
    nexturl = json['nexturl'];
    if (json['table_menu_list'] != null) {
      tableMenuList = new List<TableMenuList>();
      json['table_menu_list'].forEach((v) {
        tableMenuList.add(new TableMenuList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_image'] = this.restaurantImage;
    data['table_id'] = this.tableId;
    data['table_name'] = this.tableName;
    data['branch_name'] = this.branchName;
    data['nexturl'] = this.nexturl;
    if (this.tableMenuList != null) {
      data['table_menu_list'] =
          this.tableMenuList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableMenuList {
  String menuCategory;
  String menuCategoryId;
  String menuCategoryImage;
  String nexturl;
  List<CategoryDishes> categoryDishes;

  TableMenuList(
      {this.menuCategory,
      this.menuCategoryId,
      this.menuCategoryImage,
      this.nexturl,
      this.categoryDishes});

  TableMenuList.fromJson(Map<String, dynamic> json) {
    menuCategory = json['menu_category'];
    menuCategoryId = json['menu_category_id'];
    menuCategoryImage = json['menu_category_image'];
    nexturl = json['nexturl'];
    if (json['category_dishes'] != null) {
      categoryDishes = new List<CategoryDishes>();
      json['category_dishes'].forEach((v) {
        categoryDishes.add(new CategoryDishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_category'] = this.menuCategory;
    data['menu_category_id'] = this.menuCategoryId;
    data['menu_category_image'] = this.menuCategoryImage;
    data['nexturl'] = this.nexturl;
    if (this.categoryDishes != null) {
      data['category_dishes'] =
          this.categoryDishes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryDishes {
  String dishId;
  String dishName;
  double dishPrice;
  String dishImage;
  String dishCurrency;
  double dishCalories;
  String dishDescription;
  bool dishAvailability;
  int dishType;
  String nexturl;
  List<AddonCat> addonCat;
  int dishQuantity = 0;

  CategoryDishes(
      {this.dishId,
      this.dishName,
      this.dishPrice,
      this.dishImage,
      this.dishCurrency,
      this.dishCalories,
      this.dishDescription,
      this.dishAvailability,
      this.dishType,
      this.nexturl,
      this.addonCat});

  CategoryDishes.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishPrice = json['dish_price'];
    dishImage = json['dish_image'];
    dishCurrency = json['dish_currency'];
    dishCalories = json['dish_calories'];
    dishDescription = json['dish_description'];
    dishAvailability = json['dish_Availability'];
    dishType = json['dish_Type'];
    nexturl = json['nexturl'];
    if (json['addonCat'] != null) {
      addonCat = new List<AddonCat>();
      json['addonCat'].forEach((v) {
        addonCat.add(new AddonCat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_id'] = this.dishId;
    data['dish_name'] = this.dishName;
    data['dish_price'] = this.dishPrice;
    data['dish_image'] = this.dishImage;
    data['dish_currency'] = this.dishCurrency;
    data['dish_calories'] = this.dishCalories;
    data['dish_description'] = this.dishDescription;
    data['dish_Availability'] = this.dishAvailability;
    data['dish_Type'] = this.dishType;
    data['nexturl'] = this.nexturl;
    if (this.addonCat != null) {
      data['addonCat'] = this.addonCat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonCat {
  String addonCategory;
  String addonCategoryId;
  int addonSelection;
  String nexturl;
  List<Addons> addons;

  AddonCat(
      {this.addonCategory,
      this.addonCategoryId,
      this.addonSelection,
      this.nexturl,
      this.addons});

  AddonCat.fromJson(Map<String, dynamic> json) {
    addonCategory = json['addon_category'];
    addonCategoryId = json['addon_category_id'];
    addonSelection = json['addon_selection'];
    nexturl = json['nexturl'];
    if (json['addons'] != null) {
      addons = new List<Addons>();
      json['addons'].forEach((v) {
        addons.add(new Addons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addon_category'] = this.addonCategory;
    data['addon_category_id'] = this.addonCategoryId;
    data['addon_selection'] = this.addonSelection;
    data['nexturl'] = this.nexturl;
    if (this.addons != null) {
      data['addons'] = this.addons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addons {
  String dishId;
  String dishName;
  double dishPrice;
  String dishImage;
  String dishCurrency;
  double dishCalories;
  String dishDescription;
  bool dishAvailability;
  int dishType;

  Addons(
      {this.dishId,
      this.dishName,
      this.dishPrice,
      this.dishImage,
      this.dishCurrency,
      this.dishCalories,
      this.dishDescription,
      this.dishAvailability,
      this.dishType});

  Addons.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishPrice = json['dish_price'];
    dishImage = json['dish_image'];
    dishCurrency = json['dish_currency'];
    dishCalories = json['dish_calories'];
    dishDescription = json['dish_description'];
    dishAvailability = json['dish_Availability'];
    dishType = json['dish_Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_id'] = this.dishId;
    data['dish_name'] = this.dishName;
    data['dish_price'] = this.dishPrice;
    data['dish_image'] = this.dishImage;
    data['dish_currency'] = this.dishCurrency;
    data['dish_calories'] = this.dishCalories;
    data['dish_description'] = this.dishDescription;
    data['dish_Availability'] = this.dishAvailability;
    data['dish_Type'] = this.dishType;
    return data;
  }
}
