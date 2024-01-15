const mongoose = require("mongoose");

const transactionSchema = new mongoose.Schema({
	senderUsername: { type: String, required: true },
	senderName: { type: String, required: true },
	senderCardNumber: { type: String, unique: true },
	receiverUsername: { type: String, required: true },
	receiverName: { type: String, required: true },
	receiverCardNumber: { type: String, unique: true },
	amount: { type: Number },
	date: { type: Date, default: Date.now, required: true },
});

const Transaction = mongoose.model("Transaction", transactionSchema);
module.exports = Transaction;
