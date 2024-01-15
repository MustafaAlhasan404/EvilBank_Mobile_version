const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
	firstName: { type: String, required: true },
	lastName: { type: String, required: true },
	address: { type: String, required: true },
	birthday: { type: Date, required: true },
	username: { type: String, required: true, unique: true },
	password: { type: String, required: true },
	creditCardNumber: { type: String, unique: true },
	cvv: { type: String },
	expiryDate: { type: Date },
	balance: { type: Number, default: 10000 },
});

// Middleware to generate Card Number, CVV, and expiry date
userSchema.pre("save", function (next) {
	if (!this.isNew) {
		return next();
	}

	// Generate expiry date a year from now
	const currentDate = new Date();
	const expiryDate = new Date(
		currentDate.getFullYear() + 1,
		currentDate.getMonth(),
		currentDate.getDate()
	);
	this.expiryDate = expiryDate;
	console.log("Generated Expiry date", expiryDate);

	// Generate a 3-digit CVV
	const generatedCVV = generateCVV();
	this.cvv = generatedCVV;
	console.log("Generated CVV", this.cvv);

	// Generate a unique 16-digit credit card number
	const generatedCreditCardNumber = generateUniqueCreditCardNumber();
	this.creditCardNumber = generatedCreditCardNumber;
	console.log("Generated Card Number", this.creditCardNumber);

	next();
});

function generateUniqueCreditCardNumber() {
	let creditCardNumber = "";
	creditCardNumber = "4"; // VISA card starts with '4'
	for (let i = 0; i < 15; i++) {
		creditCardNumber += Math.floor(Math.random() * 10).toString();
	}

	// // Check if the generated credit card number is unique
	// const existingUser = User.findOne({ creditCardNumber });
	// if (!existingUser) {
	// 	break;
	// }

	return creditCardNumber;
}

function generateCVV() {
	let cvv = "";
	for (let i = 0; i < 3; i++) {
		cvv += Math.floor(Math.random() * 10).toString();
	}
	return cvv;
}

const User = mongoose.model("User", userSchema);
module.exports = User;
