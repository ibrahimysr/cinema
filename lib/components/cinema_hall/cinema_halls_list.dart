part of "../components.dart";

class CinemaHallsList extends StatelessWidget {
  final List<Hall> halls;

  const CinemaHallsList({required this.halls});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Appcolor.buttonColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Salonlar',
                style: TextStyle(
                  color: Appcolor.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildHallCard(context, halls[index]),
                    ),
                  ),
                );
              },
              childCount: halls.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHallCard(BuildContext context, Hall hall) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Appcolor.grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: Appcolor.buttonColor.withOpacity(0.1),
          highlightColor: Appcolor.buttonColor.withOpacity(0.05),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReservationScreen(salonId: hall.id)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Appcolor.buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.event_seat, color: Colors.black, size: 30),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hall.name,
                        style: TextStyle(
                          color: Appcolor.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kapasite: ${hall.capacity} kişi',
                        style: TextStyle(
                          color: Appcolor.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          _buildHallFeature(Icons.hd, 'HD'),
                          SizedBox(width: 12),
                          _buildHallFeature(Icons.surround_sound, 'Dolby'),
                          SizedBox(width: 12),
                          _buildHallFeature(Icons.air, 'Klima'),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Appcolor.buttonColor, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHallFeature(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Appcolor.buttonColor),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Appcolor.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}