import SwiftUI

struct ProfileListView: View {
    @State private var profiles: [NewWidgetProfile] = NewProfileManager.load()
    @State private var showEditor = false
    @State private var editingProfile: NewWidgetProfile?
    @Environment(\.editMode) private var editMode

    var body: some View {
        NavigationView {
            List {
                ForEach(profiles) { profile in
                    HStack {
                        Circle()
                            .fill(profile.textColor.color)
                            .frame(width: 20, height: 20)
                        Text(profile.name)
                            .font(.system(size: profile.textSize.size))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if editMode?.wrappedValue == .active {
                            editingProfile = profile
                        }
                    }
                }
                .onDelete { indexSet in
                    profiles.remove(atOffsets: indexSet)
                    NewProfileManager.save(profiles)
                }
            }
            .navigationTitle("Profiles")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showEditor = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            ProfileEditorView { profile in
                profiles.append(profile)
                NewProfileManager.save(profiles)
            }
        }
        .sheet(item: $editingProfile) { profile in
            ProfileEditorView(profile: profile) { updated in
                if let index = profiles.firstIndex(where: { $0.id == updated.id }) {
                    profiles[index] = updated
                    NewProfileManager.save(profiles)
                }
            }
        }
    }
}

struct ProfileEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var textColor: Color
    @State private var backgroundColor: Color
    @State private var textSize: NewWidgetProfile.TextSize
    @State private var rotation: Int
    private let isEditing: Bool

    var onSave: (NewWidgetProfile) -> Void

    init(profile: NewWidgetProfile? = nil, onSave: @escaping (NewWidgetProfile) -> Void) {
        self.onSave = onSave
        self.isEditing = profile != nil
        _name = State(initialValue: profile?.name ?? "")
        _textColor = State(initialValue: profile?.textColor.color ?? .primary)
        _backgroundColor = State(initialValue: profile?.backgroundColor.color ?? .white)
        _textSize = State(initialValue: profile?.textSize ?? .medium)
        _rotation = State(initialValue: profile?.rotation ?? 1)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                ColorPicker("Text Color", selection: $textColor)
                ColorPicker("Background Color", selection: $backgroundColor)
                Picker("Text Size", selection: $textSize) {
                    ForEach(NewWidgetProfile.TextSize.allCases, id: \.self) { size in
                        Text(size.rawValue.capitalized).tag(size)
                    }
                }
                .pickerStyle(.segmented)
                HStack {
                    Text("Rotation")
                    Spacer()
                    Button(action: { if rotation > 0 { rotation -= 1 } }) {
                        Image(systemName: "minus.circle")
                    }
                    Text("\(rotation)")
                        .frame(minWidth: 30)
                    Button(action: { rotation += 1 }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Profile" : "New Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let profile = NewWidgetProfile(name: name, textColor: CodableColor(textColor), backgroundColor: CodableColor(backgroundColor), textSize: textSize, rotation: rotation)
                        onSave(profile)
                        dismiss()
                    }
                }
            }
        }
    }
}
