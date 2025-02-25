part of "../components.dart";


Padding wlecomeBorder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 65,
        child: Stack(
          children: [
            Positioned(
              top: -5,
              width: MediaQuery.of(context).size.width - 50,
              child: ClipPath(
                clipper: ClipBorder(),
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Appcolor.buttonColor.withOpacity(0.3),
                        Colors.transparent
                      ],
                      stops: const [
                        0.35,
                        1,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              width: MediaQuery.of(context).size.width - 50,
              child: ClipPath(
                clipper: ClipShadow(),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Appcolor.buttonColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


class ClipShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -20, size.width, size.height);
    path.lineTo(size.width, size.height - 5);
    path.quadraticBezierTo(size.width / 2, -25, 0, size.height - 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ClipBorder extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height - 30);
    path.quadraticBezierTo(size.width / 2, -20, 0, size.height - 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



 