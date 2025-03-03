part of "../components.dart";

class HallCard extends StatelessWidget {
  final Hall hall;

  const HallCard({required this.hall});

  @override
  Widget build(BuildContext context) {
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
                          HallFeature(icon: Icons.hd, label: 'HD'),
                          SizedBox(width: 12),
                          HallFeature(icon: Icons.surround_sound, label: 'Dolby'),
                          SizedBox(width: 12),
                          HallFeature(icon: Icons.air, label: 'Klima'),
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
}