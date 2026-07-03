import SwiftUI

struct CityPickerView: View {
    @Bindable var controller: KeeperController
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                let sections = CityCatalog.sections(matching: searchText)

                if sections.isEmpty {
                    ContentUnavailableView.search
                } else {
                    ForEach(sections) { section in
                        Section(section.region.title) {
                            ForEach(section.cities) { city in
                                Button {
                                    choose(city)
                                } label: {
                                    CityRowView(
                                        city: city,
                                        isSelected: city.id == controller.selectedCity.id
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Город, страна или регион")
            .navigationTitle("Выбор города")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово", action: dismiss.callAsFunction)
                }
            }
        }
        .frame(minWidth: 620, minHeight: 640)
    }

    private func choose(_ city: City) {
        controller.selectCity(city)
        dismiss()
    }
}
