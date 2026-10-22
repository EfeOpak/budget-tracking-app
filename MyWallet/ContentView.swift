
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]

    @State private var showingAddTransaction = false

    private var totalIncome: Double {
        transactions
            .filter { $0.isIncome }
            .reduce(0) { $0 + $1.amount }
    }

    private var totalExpenses: Double {
        transactions
            .filter { !$0.isIncome }
            .reduce(0) { $0 + $1.amount }
    }

    private var balance: Double {
        totalIncome - totalExpenses
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TOPLAM BAKİYE")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))

                        Text(balance, format: .currency(code: "TRY"))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)

                        Label("Finansal durumun", systemImage: "wallet.bifold")
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(
                        LinearGradient(
                            colors: [.blue, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    HStack(spacing: 12) {
                        summaryCard(
                            title: "Gelir",
                            amount: totalIncome,
                            color: .green
                        )

                        summaryCard(
                            title: "Gider",
                            amount: totalExpenses,
                            color: .red
                        )
                    }

                    HStack {
                        Text("Son İşlemler")
                            .font(.title3.bold())

                        Spacer()

                        Button {
                            showingAddTransaction = true
                        } label: {
                            Label("Ekle", systemImage: "plus")
                        }
                    }

                    if transactions.isEmpty {
                        ContentUnavailableView(
                            "Henüz işlem yok",
                            systemImage: "tray",
                            description: Text(
                                "İlk gelir veya gider kaydını ekle."
                            )
                        )
                        .frame(minHeight: 180)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(transactions) { item in
                                HStack(spacing: 12) {
                                    Image(
                                        systemName: item.isIncome
                                            ? "arrow.down.left.circle.fill"
                                            : "arrow.up.right.circle.fill"
                                    )
                                    .font(.title2)
                                    .foregroundStyle(
                                        item.isIncome ? .green : .red
                                    )

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .fontWeight(.medium)

                                        Text(item.category)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Text(
                                        "\(item.isIncome ? "+" : "−")\(item.amount.formatted(.currency(code: "TRY")))"
                                    )
                                    .font(.subheadline.bold())
                                    .foregroundStyle(
                                        item.isIncome ? .green : .red
                                    )
                                }
                                .padding(.vertical, 12)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        context.delete(item)
                                    } label: {
                                        Label("Sil", systemImage: "trash")
                                    }
                                }

                                Divider()
                            }
                        }
                        .padding(.horizontal, 14)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MyWallet")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
        }
    }

    private func summaryCard(
        title: String,
        amount: Double,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(
                systemName: title == "Gelir"
                    ? "arrow.down.left"
                    : "arrow.up.right"
            )
            .font(.title3)
            .foregroundStyle(color)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(amount, format: .currency(code: "TRY"))
                .font(.headline)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
