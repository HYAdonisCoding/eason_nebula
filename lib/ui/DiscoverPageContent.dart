import 'package:flutter/material.dart';

class DiscoverPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Text(
          '发现',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(Icons.search, color: Colors.deepPurple, size: 32),
            title: Text('全网热搜'),
            subtitle: Text('看看大家都在关注什么'),
            trailing: Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {},
          ),
        ),
        SizedBox(height: 24),
        Text(
          '热门话题',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            6,
            (i) => Chip(
              label: Text('话题 ${i + 1}'),
              backgroundColor: Colors.purpleAccent.withOpacity(0.1),
              avatar: Icon(Icons.local_fire_department, color: Colors.purpleAccent, size: 18),
            ),
          ),
        ),
        SizedBox(height: 32),
        Text(
          '为你推荐',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...List.generate(
          3,
          (i) => Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.lightbulb, color: Colors.orange),
              title: Text('发现内容 ${i + 1}'),
              subtitle: Text('探索更多有趣的内容。'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}