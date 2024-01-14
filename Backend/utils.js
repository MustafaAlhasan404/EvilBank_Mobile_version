module.exports = function formatCreditCardNumber(input) {
	// Remove any existing spaces or non-digit characters
	const digitsOnly = input.replace(/\D/g, "");

	// Check if the input has exactly 16 digits
	if (digitsOnly.length !== 16) {
		return "Invalid credit card number. Please enter a 16-digit number.";
	}

	// Format the credit card number with a space every 4 digits
	const formattedNumber = digitsOnly.replace(/(\d{4})/g, "$1 ");

	return formattedNumber.trim();
};
