import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SimpleTrainingApp()));
}

class Sample {
  final String imageUrl;
  final String answer;
  Sample(this.imageUrl, this.answer);

  factory Sample.fromList(List<String> list) {
    return Sample(list[0], list[1]);
  }
}

class SimpleTrainingApp extends StatefulWidget {
  const SimpleTrainingApp({super.key});
  @override
  State<SimpleTrainingApp> createState() => _SimpleTrainingAppState();
}

const String appTitle = '素材がいい敵クイズ';

class _SimpleTrainingAppState extends State<SimpleTrainingApp> {
  final List<List<String>> data = [
    ["https://www.ndw.jp/ndw/wordpress/wp-content/uploads/2018/07/image053-1024x724.jpg", "× 赤ボコブリン"],
    ["https://uf.kentei.cc/img/489379/question/1726557256831.jpg", "〇 歩行型ガーディアン"],
    ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8BrcqP4KpJv65LowJlXe1WkBeUgqYiVPc5w&s", "〇 極意小型ガーディアン"],
    ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbiMQ2o5k0CCMSWxGvyxslQ38s4qzwmUSzYg&s", "〇 ライネル"],
    ["https://tfi.gamepedia.jp/image/w=1200,h=630,fit=pad,f=webp/media.gamepedia.jp/gamepedia/wp-content/uploads/sites/49/2017/03/02092922/zukan-113.jpg", "× リザルフォス"],
    ["https://img.game8.jp/6368924/d0a4c737427455077359826ce1bdb996.png/show", "〇 白銀リザルフォス"],
    ["https://img.gamewith.jp/article_tools/zeldabotw/gacha/enemy_126.png", "× カースモリブリン"],
    ["https://img.gamewith.jp/img/3ee710049ef3b099736daee3288c7b07.png", "× イーガ団構成員"],
    ["https://media.gamepedia.jp/gamepedia/wp-content/uploads/sites/49/2017/03/02092928/zukan-87.jpg", "〇 雷チュチュ"],
    ["https://img.gamewith.jp/img/6a1d2e56b864a875b403d8173a203bcc.jpg", "× オコバ"],
    
  ];

  late final List<Sample> _samples;
  int _index = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _samples = data.map((e) => Sample.fromList(e)).toList();
    _samples.shuffle(Random());
  }

  void _onTap() {
    setState(() {
      if (_showAnswer) {
        _showAnswer = false;

        // 最後まで行ったら再シャッフルして先頭へ
        if (_index == _samples.length - 1) {
          _samples.shuffle(Random());
          _index = 0;
        } else {
          _index++;
        }
      } else {
        _showAnswer = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_samples.isEmpty) {
      return const Scaffold(body: Center(child: Text('データがありません')));
    }

    final sample = _samples[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                sample.imageUrl,
                // fit: BoxFit.cover,// 画面いっぱいに広げる代わりに上下左右が切れる
                fit: BoxFit.contain, // 画像全体が必ず画面内に収まる（余白が出ることはあるが切れない）
                loadingBuilder: (c, w, p) => p == null ? w : const Center(child: CircularProgressIndicator()),
                errorBuilder: (e1, e2, e3) => const Center(child: Text('画像を読み込めません')),
              ),
            ),

            if (_showAnswer)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    sample.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 10,
              right: 10,
              child: _hint(_showAnswer ? 'タップで次へ' : 'タップで正解表示'),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: _hint('${_index + 1}/${_samples.length}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
