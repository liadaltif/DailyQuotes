import SwiftUI

struct ProfileListView: View {
    @State private var profiles: [NewWidgetProfile] = NewProfileManager.load()
    @State private var showEditor = false

    var body: some View {
        NavigationView {
            List {
                ForEach(profiles) { profile in
                    HStack {
                        Circle()
                            .fill(profile.color.color)
                            .frame(width: 20, height: 20)
                        Text(profile.name)
                            .font(.system(size: CGFloat(profile.textSize)))
                    }
                }
                .onDelete { indexSet in
                    profiles.remove(atOffsets: indexSet)
                    NewProfileManager.save(profiles)
                }
            }
            .navigationTitle("Profiles")
            .toolbar {
                Button(action: { showEditor = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            ProfileEditorView { profile in
                profiles.append(profile)
                NewProfileManager.save(profiles)
            }
        }
    }
}

struct ProfileEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var color: Color = .primary
    @State private var textSize: Double = 16

    var onSave: (NewWidgetProfile) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                VStack(alignment: .leading) {
                    Text("Text Size: \(Int(textSize))")
                    Slider(value: $textSize, in: 10...40)
                }
            }
            .navigationTitle("New Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let profile = NewWidgetProfile(name: name, color: CodableColor(color), textSize: textSize)
                        onSave(profile)
                        dismiss()
                    }
                }
            }
        }
    }
}
