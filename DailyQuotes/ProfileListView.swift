import SwiftUI
import WidgetKit

@MainActor
struct ProfileListView: View {
    @State private var profiles: [NewWidgetProfile] = NewProfileManager.load()
    @State private var showEditor = false
    @State private var editingProfile: NewWidgetProfile?

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
                        editingProfile = profile
                    }
                }
                .onDelete { indexSet in
                    profiles.remove(atOffsets: indexSet)
                    NewProfileManager.save(profiles)
                    WidgetCenter.shared.reloadAllTimelines()
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
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .sheet(item: $editingProfile) { profile in
            ProfileEditorView(profile: profile) { updated in
                if let index = profiles.firstIndex(where: { $0.id == updated.id }) {
                    profiles[index] = updated
                    NewProfileManager.save(profiles)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
    }
}

@MainActor
struct ProfileEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var textColor: Color
    @State private var backgroundColor: Color
    @State private var useGallery: Bool
    @State private var selectedImages: Set<String>
    @State private var textSize: NewWidgetProfile.TextSize
    @State private var rotation: Int
    private let isEditing: Bool
    private let initialID: UUID?
    private let galleryImages = ["Photo1", "Photo2", "Photo3"]

    var onSave: (NewWidgetProfile) -> Void

    init(profile: NewWidgetProfile? = nil, onSave: @escaping (NewWidgetProfile) -> Void) {
        self.onSave = onSave
        self.isEditing = profile != nil
        self.initialID = profile?.id
        _name = State(initialValue: profile?.name ?? "")
        _textColor = State(initialValue: profile?.textColor.color ?? .primary)
        _backgroundColor = State(initialValue: profile?.backgroundColor.color ?? .white)
        _useGallery = State(initialValue: profile?.backgroundImages != nil)
        _selectedImages = State(initialValue: Set(profile?.backgroundImages ?? []))
        _textSize = State(initialValue: profile?.textSize ?? .medium)
        _rotation = State(initialValue: profile?.rotation ?? 1)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                ColorPicker("Text Color", selection: $textColor)
                Toggle("Use Image Gallery", isOn: $useGallery)
                    .onChange(of: useGallery) { newValue in
                        print("ProfileEditorView: useGallery ->", newValue)
                    }
                if useGallery {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(galleryImages, id: \.self) { name in
                                Image(name)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedImages.contains(name) ? Color.accentColor : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        if selectedImages.contains(name) {
                                            selectedImages.remove(name)
                                        } else {
                                            selectedImages.insert(name)
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(height: 90)
                } else {
                    ColorPicker("Background Color", selection: $backgroundColor)
                }
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
                        let images = useGallery ? Array(selectedImages) : nil
                        let profile = NewWidgetProfile(id: initialID ?? UUID(), name: name, textColor: CodableColor(textColor), backgroundColor: CodableColor(backgroundColor), backgroundImages: images, textSize: textSize, rotation: rotation)
                        onSave(profile)
                        dismiss()
                    }
                }
            }
        }
    }
}
