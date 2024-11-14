class HistoryItem {
  final String question;
  final String answer;
  final String date;

  HistoryItem({required this.question, required this.answer, required this.date});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      question: json['question'],
      answer: json['answer'],
      date: json['date'],
    );
  }
}

class Category {
  final String categoryName;
  final List<SubCategory> subCategories;

  Category({required this.categoryName, required this.subCategories});

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['sub_categories'] as List;
    List<SubCategory> subCategoryList =
        list.map((item) => SubCategory.fromJson(item)).toList();

    return Category(
      categoryName: json['category_name'],
      subCategories: subCategoryList,
    );
  }
}

class SubCategory {
  final String title;
  final String description;

  SubCategory({required this.title, required this.description});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      title: json['title'],
      description: json['description'],
    );
  }
}
