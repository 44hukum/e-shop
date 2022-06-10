
class RatingModel {
  String userid;
  String rating;
  String productId;
  String comment;
  RatingModel(
      {this.userid,this.productId,this.rating,this.comment});

  RatingModel.fromJson(Map<String, dynamic> json)
  {
    userid = json['userid'];
    productId = json['productId'];
    rating = json['rating'];
    comment = json['comment'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['rating'] = this.rating;
    data['productid'] = this.productId;
    data['comment'] = this.comment;

    return data;
  }
}


