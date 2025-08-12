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
                        Spacer()
                        Text(profile.name)
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
    @State private var isDarkMode: Bool
    @State private var selectedImage: String
    @State private var versesPerDay: Int
    private let isEditing: Bool
    private let initialID: UUID?
    private let galleryImages = ["Photo1", "Photo2", "Photo3"]

    var onSave: (NewWidgetProfile) -> Void

    init(profile: NewWidgetProfile? = nil, onSave: @escaping (NewWidgetProfile) -> Void) {
        self.onSave = onSave
        self.isEditing = profile != nil
        self.initialID = profile?.id
        _name = State(initialValue: profile?.name ?? "")
        _isDarkMode = State(initialValue: profile?.isDarkMode ?? false)
        _selectedImage = State(initialValue: profile?.backgroundImage ?? galleryImages.first!)
        _versesPerDay = State(initialValue: profile?.versesPerDay ?? 1)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("", text: $name, prompt: Text("שם הפרופיל שלך"))
                    .multilineTextAlignment(.trailing)

                Toggle(isOn: $isDarkMode) {
                    Text("מצב כהה/מצב בהיר")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(galleryImages, id: \.self) { name in
                            Image(name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                                .overlay(
                                    Rectangle()
                                        .stroke(selectedImage == name ? Color.accentColor : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedImage = name
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(height: 90)

                HStack {
                    Text("כמות פסוקים ביום")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Button(action: { if versesPerDay > 0 { versesPerDay -= 1 } }) {
                        Image(systemName: "minus.circle")
                    }
                    Text("\(versesPerDay)")
                        .frame(minWidth: 30)
                    Button(action: { versesPerDay += 1 }) {
                        Image(systemName: "plus.circle")
                    }
                }

                Button("פתיחת ווידג׳ט חדש") {
                    let profile = NewWidgetProfile(id: initialID ?? UUID(), name: name, backgroundImage: selectedImage, isDarkMode: isDarkMode, versesPerDay: versesPerDay)
                    onSave(profile)
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .font(.title2)
            }
            .environment(\.layoutDirection, .rightToLeft)
            .navigationTitle("עיצוב ווידג׳ט")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
