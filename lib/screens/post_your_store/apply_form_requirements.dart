// Form field requirements for Post Your Store form
// Each requirement is a TODO for implementation

// TODO 1: Store Name
// - Can have spaces, letters, numbers, symbols
// - Minimum 1 character

/// Returns null if valid, or an error message if invalid.
String? validateStoreName(String? value) {
	if (value == null || value.isEmpty) {
		return 'Store name is required';
	}
	// Allow any character, but must be at least 1 character
	if (value.length < 1) {
		return 'Store name must be at least 1 character';
	}
	return null;
}


// TODO 2: Store Domain
// - No spaces allowed
// - Numbers and symbols allowed
// - Must be a valid domain (e.g., abc.com, xyz.store, mysite.net)

/// Returns null if valid, or an error message if invalid.
String? validateStoreDomain(String? value) {
	if (value == null || value.isEmpty) {
		return 'Store domain is required';
	}
	if (value.contains(' ')) {
		return 'No spaces allowed in domain';
	}
	// Basic domain regex: must have at least one dot, valid chars, and TLD
	final domainRegex = RegExp(r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
	if (!domainRegex.hasMatch(value)) {
		return 'Enter a valid domain (e.g., abc.com)';
	}
	return null;
}


// TODO 3: Category
// - Must be selected (no default)

/// Returns null if valid, or an error message if invalid.
String? validateCategory(String? value) {
	if (value == null || value.isEmpty) {
		return 'Please select a category';
	}
	return null;
}


// TODO 4: Store Subheading
// - Can have spaces, letters, numbers, symbols
// - Cannot be empty

/// Returns null if valid, or an error message if invalid.
String? validateStoreSubheading(String? value) {
	if (value == null || value.isEmpty) {
		return 'Store subheading is required';
	}
	return null;
}


// TODO 5: About Store
// - Can have spaces, letters, numbers, symbols
// - Cannot be empty

/// Returns null if valid, or an error message if invalid.
String? validateAboutStore(String? value) {
	if (value == null || value.isEmpty) {
		return 'About store is required';
	}
	return null;
}


// TODO 6: Facebook & Instagram
// - Optional
// - If entered, must be a valid link to the social media page

/// Returns null if valid, or an error message if invalid.
String? validateSocialLink(String? value) {
	if (value == null || value.isEmpty) {
		return null; // Optional field
	}
	// Basic URL validation (http/https and at least one dot)
	final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/\S*)?$');
	if (!urlRegex.hasMatch(value)) {
		return 'Enter a valid link to the social media page';
	}
	return null;
}


// TODO 7: Store Banner Photo
// - Must be added to continue

/// Returns null if valid, or an error message if invalid.
String? validateBannerPhoto(dynamic imageBytes) {
	// imageBytes: Uint8List? or similar
	if (imageBytes == null || (imageBytes is List && imageBytes.isEmpty)) {
		return 'Store banner photo is required';
	}
	return null;
}


// TODO 8: Store Thumbnail Photo
// - Must be added to continue

/// Returns null if valid, or an error message if invalid.
String? validateThumbnailPhoto(dynamic imageBytes) {
	// imageBytes: Uint8List? or similar
	if (imageBytes == null || (imageBytes is List && imageBytes.isEmpty)) {
		return 'Store thumbnail photo is required';
	}
	return null;
}


// TODO 9: Contact Info
// - All fields optional
// - Email: If entered, must be a valid email address (e.g., example@email.com)
// - Address: If entered, can have spaces, letters, numbers, symbols
// - Postal Code: If entered, can have numbers, letters, dashes (-), commas (,), periods (.)
// - Phone: If entered, only numbers and dashes (-) allowed

/// Returns null if valid, or an error message if invalid.
String? validateEmail(String? value) {
	if (value == null || value.isEmpty) return null;
	// Basic email regex
	final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
	if (!emailRegex.hasMatch(value)) {
		return 'Enter a valid email address';
	}
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validateContactAddress(String? value) {
	// Address: allow anything, optional
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validatePostalCode(String? value) {
	if (value == null || value.isEmpty) return null;
	// Allow numbers, letters, dashes, commas, periods
	final postalRegex = RegExp(r'^[a-zA-Z0-9\-,. ]*$');
	if (!postalRegex.hasMatch(value)) {
		return 'Postal code can only contain letters, numbers, dashes, commas, periods, and spaces';
	}
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validatePhone(String? value) {
	if (value == null || value.isEmpty) return null;
	// Only numbers and dashes allowed
	final phoneRegex = RegExp(r'^[0-9\-]+$');
	if (!phoneRegex.hasMatch(value)) {
		return 'Phone can only contain numbers and dashes';
	}
	return null;
}


// TODO 10: Product Fields
// - At least 1 photo must be added (others optional)
// - Product Condition: Default is 'New', any of the 3 options allowed
// - Product Title: Only spaces and letters allowed (no numbers or symbols)
// - Price: Only numbers and one "." allowed
// - Estimated Arrival in Days: Only numbers allowed (no spaces, symbols, or letters)

/// Returns null if valid, or an error message if invalid.
String? validateProductPhoto(dynamic imageBytes) {
	if (imageBytes == null || (imageBytes is List && imageBytes.isEmpty)) {
		return 'At least 1 product photo is required';
	}
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validateProductCondition(String? value) {
	if (value == null || value.isEmpty) {
		return 'Product condition is required';
	}
	const allowed = ['New', 'Used', 'Refurbished'];
	if (!allowed.contains(value)) {
		return 'Invalid product condition';
	}
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validateProductTitle(String? value) {
	if (value == null || value.isEmpty) {
		return 'Product title is required';
	}
	// Only spaces and letters allowed
	final titleRegex = RegExp(r'^[a-zA-Z ]+$');
	if (!titleRegex.hasMatch(value)) {
		return 'Product title can only contain letters and spaces';
	}
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validateProductPrice(String? value) {
	if (value == null || value.isEmpty) {
		return 'Product price is required';
	}
	// Only numbers and one dot allowed
	final priceRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
	if (!priceRegex.hasMatch(value)) {
		return 'Enter a valid price (numbers and one ".")';
	}
	return null;
}

/// Returns null if valid, or an error message if invalid.
String? validateEstimatedArrival(String? value) {
	if (value == null || value.isEmpty) {
		return 'Estimated arrival is required';
	}
	// Only numbers allowed
	final arrivalRegex = RegExp(r'^[0-9]+$');
	if (!arrivalRegex.hasMatch(value)) {
		return 'Only numbers allowed for estimated arrival';
	}
	return null;
}
