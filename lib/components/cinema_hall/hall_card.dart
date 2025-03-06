part of "../components.dart";

class HallCard extends StatelessWidget {
  final Hall hall;

  const HallCard({super.key, required this.hall});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), 
      decoration: BoxDecoration(
        color: Appcolor.grey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16.0),
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Appcolor.buttonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.event_seat, color: Colors.black, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hall.name,
                      style: const TextStyle(
                        color: Appcolor.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kapasite: ${hall.capacity} kişi',
                      style: TextStyle(
                        color: Appcolor.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
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
            ],
          ),
          trailing: const Icon(Icons.arrow_drop_down, color: Appcolor.buttonColor, size: 24),
          children: hall.showtimes.isEmpty
              ? [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Bu salonda seans bulunamadı',
                      style: TextStyle(color: Appcolor.white),
                    ),
                  ),
                ]
              : hall.showtimes.map((showtime) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    leading: const Icon(Icons.access_time, color: Appcolor.buttonColor),
                    title: Text(
                      _formatDateTime(showtime.startTime),
                      style: const TextStyle(color: Appcolor.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationScreen(showtimeId: showtime.id), 
                        ),
                      );
                    },
                  );
                }).toList(),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}