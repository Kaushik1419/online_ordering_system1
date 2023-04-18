import 'package:flutter/material.dart';

class TrailOnly extends StatefulWidget {
  const TrailOnly({Key? key}) : super(key: key);

  @override
  State<TrailOnly> createState() => _TrailOnlyState();
}

class _TrailOnlyState extends State<TrailOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trial page for the list view builder"),
      ),
      body: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  Card(
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image on the left
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('imageUrl'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Product name, description, and price on the right
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'name',
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          // Description in two lines with dot notation for the rest
                          Text(
                            'description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '...',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          // Price in light blue
                          Text(
                            'price',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Add to Cart button at the bottom
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
