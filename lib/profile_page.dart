import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/pic.jpg',
                height: 200,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Имя: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Константин',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Возраст: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '21',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Должность: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Трейдер',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          ListTile(
            title: Text('История сделок'),
          ),
          Flexible(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: true,
                ),
                Dealitem(
                  title: 'Gasprom -20\$',
                  subtitle: 'Акции',
                  isGood: false,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: true,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: true,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: false,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: true,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: true,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: false,
                ),
                Dealitem(
                  title: 'Tesla 100\$',
                  subtitle: 'Диведенты',
                  isGood: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dealitem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isGood;

  const Dealitem({
    required this.title,
    required this.subtitle,
    required this.isGood,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isGood ? Colors.green.shade100 : Colors.red.shade100,
      ),
      child: Row(
        children: [
          Icon(
            Icons.add,
            color: isGood ? Colors.green : Colors.red,
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(subtitle),
            ],
          )
        ],
      ),
    );
  }
}
