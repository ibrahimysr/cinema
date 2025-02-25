  part of "../components.dart";




Padding searchField(BuildContext context) {
    return Padding(
      padding:  context.paddingNormalHorizontal,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: 
          
          context.paddingNormalVertical,
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          hintText: "Search",
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 35,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(27),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }