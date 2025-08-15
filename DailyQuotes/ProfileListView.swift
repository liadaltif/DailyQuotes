import SwiftUI
import WidgetKit

@MainActor
struct ProfileListView: View {
    @State private var profiles: [NewWidgetProfile] = NewProfileManager.load()
    @State private var showEditor = false
    @State private var editingProfile: NewWidgetProfile?

    var body: some View {
        NavigationStack {
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
    @Environment(\.colorScheme) private var colorScheme

    @State private var name: String
    @State private var versesPerDay: Int

    private let isEditing: Bool
    private let initialID: UUID?

    var onSave: (NewWidgetProfile) -> Void

    init(profile: NewWidgetProfile? = nil, onSave: @escaping (NewWidgetProfile) -> Void) {
        self.onSave = onSave
        self.isEditing = profile != nil
        self.initialID = profile?.id
        _name = State(initialValue: profile?.name ?? "")
        _versesPerDay = State(initialValue: profile?.versesPerDay ?? 1)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("", text: $name, prompt: Text("שם הפרופיל שלך"))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    // Removed the manual light/dark mode buttons

                   Stepper(value: $versesPerDay, in: 1...100) {
                        HStack {
                            Text("כמות פסוקים ביום")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text("\(versesPerDay)")
                    }
                }

                }
                .environment(\.layoutDirection, .rightToLeft)

                Spacer()

                Button(isEditing ? "עדכן ווידג׳ט" : "פתיחת ווידג׳ט חדש") {
                    // Save with current system appearance (no manual toggle)
                    let profile = NewWidgetProfile(
                        id: initialID ?? UUID(),
                        name: name,
                        isDarkMode: colorScheme == .dark,   // follows phone at save time
                        versesPerDay: versesPerDay
                    )
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
