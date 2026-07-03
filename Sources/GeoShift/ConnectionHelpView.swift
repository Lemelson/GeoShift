import SwiftUI

struct ConnectionHelpView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Как подключить iPhone", systemImage: "cable.connector")
                .font(.headline)

            Text("1. Надёжно: подключите кабель и нажмите «Доверять». Приложение само включит дальнейшее подключение по Wi‑Fi.")
            Text("2. Без кабеля: Mac и iPhone должны быть в одной Wi‑Fi‑сети.")
            Text("3. Если на iPhone включён VPN, разрешите ему локальную сеть или временно отключите VPN для подключения.")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.orange.opacity(0.08), in: .rect(cornerRadius: 10))
    }
}
