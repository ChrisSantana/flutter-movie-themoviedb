import 'package:flutter/material.dart';
import 'package:fluttermovie/widget/splash/factory_content_widget.dart';
import '../library/util.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildBackground(),
          _buildTitle(),
          _buildMsg(),
          _buildProgress(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent, 
            Colors.black,
          ],
        ).createShader(
          Rect.fromLTRB(0, -140, rect.width, rect.height - 20),
        );
      },
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(
              Util.instance.imgBackgroundSplash,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned(
      top: 80,
      child: Text(
        'Flutter Movie',
        style: TextStyle(
          fontSize: 30,
          shadows: [
            BoxShadow(
              color: Colors.black87,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMsg() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Acompanhe os principais lançamentos, veja detalhes e as principais informações dos filmes de sua preferência. Além disso, o aplicativo possibilita favoritá-los',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            shadows: [
              BoxShadow(
                color: Colors.black87,
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Positioned(
      bottom: 60,
      child: FactoryProgressSplashWidget(),
    );
  }
}