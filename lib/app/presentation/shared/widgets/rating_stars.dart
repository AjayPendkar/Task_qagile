import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final String rating;
  final double size;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ratingValue = double.tryParse(rating) ?? 0;
    final fullStars = (ratingValue / 2).floor();
    final hasHalfStar = (ratingValue / 2) - fullStars >= 0.5;

    return Row(
      children: [
        ...List.generate(fullStars, (index) => Icon(
          CupertinoIcons.star_fill,
          color: CupertinoColors.systemYellow,
          size: size,
        )),
        if (hasHalfStar)
          Icon(
            CupertinoIcons.star_lefthalf_fill,
            color: CupertinoColors.systemYellow,
            size: size,
          ),
        ...List.generate(5 - fullStars - (hasHalfStar ? 1 : 0), (index) => Icon(
          CupertinoIcons.star,
          color: CupertinoColors.systemYellow,
          size: size,
        )),
      ],
    );
  }
} 