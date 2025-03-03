part of "../components.dart";


class CityDropdown extends StatelessWidget {
  final AnimationController animationController;
  final Function(City?) onCitySelected;

  const CityDropdown({super.key, 
    required this.animationController,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CitySelectorViewModel>(context);

    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Appcolor.buttonColor),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.resetErrorAndRetryCities,
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolor.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: animationController.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Appcolor.grey.withValues(alpha:0.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<City>(
                      isExpanded: true,
                      hint: const Text('Şehir Seçin', style: TextStyle(color: Colors.white70)),
                      icon: const Icon(Icons.location_city, color: Appcolor.buttonColor),
                      dropdownColor: Appcolor.grey.withValues(alpha:0.95),
                      value: viewModel.selectedCity,
                      onChanged: onCitySelected,
                      items: viewModel.cities.map<DropdownMenuItem<City>>((City city) {
                        return DropdownMenuItem<City>(
                          value: city,
                          child: Text(city.name, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}