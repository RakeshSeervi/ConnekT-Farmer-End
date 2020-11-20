import 'dart:math';

import 'package:agri_com/constants.dart';
import 'package:flutter/material.dart';

class CollageBuilder extends StatelessWidget {
  final List<String> images;

  CollageBuilder({this.images});

  @override
  Widget build(BuildContext context) {
    switch (images.length) {
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 16,
                color: Colors.transparent,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      images[0],
                      height: 150,
                      width: 150,
                    )),
              ),
            ),
          ],
        );
        break;
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ImageCard(
                  imageUrl: images[0],
                ),
                ImageCard(
                  imageUrl: images[1],
                )
              ],
            )
          ],
        );
        break;
      case 3:
        int r = Random.secure().nextInt(4);
        if (r == 0)
          return Column(
            children: [
              Row(
                children: [
                  ImageCard(
                    imageUrl: images[0],
                  ),
                  ImageCard(
                    imageUrl: images[1],
                  )
                ],
              ),
              Row(
                children: [
                  ImageCard(
                    imageUrl: images[2],
                  )
                ],
              )
            ],
          );
        else if (r == 1)
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ImageCard(
                    imageUrl: images[0],
                  )
                ],
              ),
              Row(
                children: [
                  ImageCard(
                    imageUrl: images[1],
                  ),
                  ImageCard(
                    imageUrl: images[2],
                  )
                ],
              )
            ],
          );
        else if (r == 2)
          return Row(
            children: [
              Column(
                children: [
                  ImageCard(
                    imageUrl: images[0],
                  ),
                  ImageCard(
                    imageUrl: images[1],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageCard(
                    imageUrl: images[2],
                  )
                ],
              )
            ],
          );
        else
          return Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageCard(
                    imageUrl: images[0],
                  )
                ],
              ),
              Column(
                children: [
                  ImageCard(
                    imageUrl: images[1],
                  ),
                  ImageCard(
                    imageUrl: images[2],
                  )
                ],
              ),
            ],
          );
        break;
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ImageCard(
                  imageUrl: images[0],
                ),
                ImageCard(
                  imageUrl: images[1],
                )
              ],
            ),
            Row(
              children: [
                ImageCard(
                  imageUrl: images[2],
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Card(
                    elevation: 16,
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Column(
                        children: [
                          Text(
                            '+ ' + (images.length - 3).toString(),
                            style: Constants.boldHeading,
                          ),
                          Text(
                            'others',
                            style: Constants.regularHeading,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
    }
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;

  ImageCard({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 16,
        color: Colors.transparent,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
