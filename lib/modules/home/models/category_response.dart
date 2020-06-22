class CategoryResponse {
  List<CategoriesNew> categories;

  CategoryResponse({this.categories});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<CategoriesNew>();
      json['categories'].forEach((v) {
        categories.add(new CategoriesNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoriesNew {
  int categoryId;
  String categoryName;
  String categoryDescription;
  Null parentCategoryId;
  bool isActive;
  List<String> images;

  CategoriesNew(
      {this.categoryId,
      this.categoryName,
      this.categoryDescription,
      this.parentCategoryId,
      this.isActive,
      this.images});

  CategoriesNew.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryDescription = json['category_description'];
    parentCategoryId = json['parent_category_id'];
    isActive = json['is_active'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_description'] = this.categoryDescription;
    data['parent_category_id'] = this.parentCategoryId;
    data['is_active'] = this.isActive;
    data['images'] = this.images;
    return data;
  }
}
