
import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var amount = ""
    @State private var category = "Diğer"
    @State private var isIncome = false

    private let categories = [
        "Yemek",
        "Ulaşım",
        "Alışveriş",
        "Fatura",
        "Maaş",
        "Eğlence",
        "Diğer"
    ]

    private var parsedAmount: Double? {
        Double(
            amount
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ",", with: ".")
        )
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && (parsedAmount ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("İşlem Türü") {
                    Picker("Tür", selection: $isIncome) {
                        Text("Gider").tag(false)
                        Text("Gelir").tag(true)
                    }
                    .pickerStyle(.segmented)
                }

                Section("İşlem Detayları") {
                    TextField("Açıklama", text: $title)

                    TextField("Tutar (TL)", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Kategori", selection: $category) {
                        ForEach(categories, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                }

                Section {
                    Button {
                        saveTransaction()
                    } label: {
                        Text("İşlemi Kaydet")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!canSave)
                }
            }
            .navigationTitle("Yeni İşlem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Vazgeç") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveTransaction() {
        guard let value = parsedAmount, value > 0 else {
            return
        }

        let transaction = Transaction(
            title: title.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            amount: value,
            category: category,
            isIncome: isIncome
        )

        context.insert(transaction)
        dismiss()
    }
}

