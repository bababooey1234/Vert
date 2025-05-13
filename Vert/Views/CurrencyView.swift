import SwiftUI

struct CurrencyView: View {
    @State private var amount: String = ""
    @State private var fromCurrency: String = "USD"
    @State private var toCurrency: String = "EUR"
    @State private var result: String = ""
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CNY", "INR"]
    // Example exchange rates (in practice, these would be fetched from an API)
    let exchangeRates: [String: Double] = [
        "USD": 1.0,
        "EUR": 0.92,
        "GBP": 0.79,
        "JPY": 149.5,
        "CAD": 1.36,
        "AUD": 1.52,
        "CNY": 7.24,
        "INR": 83.16
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Input field
            TextField("Enter amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // From currency picker
            HStack {
                Text("From:")
                Picker("From", selection: $fromCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: fromCurrency) { _, _ in updateResult() }
            }
            .padding(.horizontal)
            
            // To currency picker
            HStack {
                Text("To:")
                Picker("To", selection: $toCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: toCurrency) { _, _ in updateResult() }
            }
            .padding(.horizontal)
            
            // Convert button
            Button(action: updateResult) {
                Text("Convert")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // Result display
            if !result.isEmpty {
                Text(result)
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle("Currency Converter")
    }
    
    private func updateResult() {
        guard let amountValue = Double(amount),
              let fromRate = exchangeRates[fromCurrency],
              let toRate = exchangeRates[toCurrency] else {
            result = ""
            return
        }
        
        let convertedAmount = amountValue * (toRate / fromRate)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = toCurrency
        formatter.maximumFractionDigits = 2
        
        if let formattedAmount = formatter.string(from: NSNumber(value: convertedAmount)) {
            result = "\(amount) \(fromCurrency) = \(formattedAmount)"
        }
    }
}

#Preview {
    CurrencyView()
}
