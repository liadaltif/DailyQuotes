import SwiftUI

// Reusable full-width white button that’s fully tappable
struct FullWidthWhiteButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(configuration.isPressed ? 0.9 : 1.0))
            .foregroundColor(.black)
            .cornerRadius(16)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

// Reusable full-width black button
struct FullWidthBlackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black.opacity(configuration.isPressed ? 0.85 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(16)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("firstName") private var storedFirstName = ""
    @AppStorage("lastName")  private var storedLastName  = ""
    @AppStorage("versesPerDay") private var storedVersesPerDay = 3
    @AppStorage("selectedTags")  private var storedSelectedTags = ""

    @State private var page = 0
    @State private var firstName = ""
    @State private var lastName  = ""
    @State private var versesPerDay = 3
    @State private var selected: Set<String> = []

    @FocusState private var focusedField: Field?
    private enum Field { case firstName, lastName }

    // Single source of truth for the gap above keyboard/home indicator
    private let footerVerticalPadding: CGFloat = 8

    var body: some View {
        ZStack {
            TabView(selection: $page) {
                introView.tag(0)
                nameView.tag(1)
                frequencyView.tag(2)
                tagsView.tag(3)
                widgetInstallView.tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .highPriorityGesture(DragGesture()) // block swiping
            .ignoresSafeArea(.keyboard)          // keep content parked when keyboard shows
        }
        .background(
            LinearGradient(colors: [Color.black, Color(.sRGB, white: 0.2, opacity: 1)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        // 👇 One unified footer that the system keeps just above the keyboard/home indicator
        .safeAreaInset(edge: .bottom, spacing: 0) {
            footerForCurrentPage
                .padding(.horizontal)
                .padding(.top, footerVerticalPadding)
                .padding(.bottom, footerVerticalPadding) // controls “just a bit above” feel
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Footer per page
    @ViewBuilder
    private var footerForCurrentPage: some View {
        switch page {
        case 0:
            primaryFooter("יאללה, נתחיל!") {
                withAnimation { page = 1 }
            }
        case 1:
            primaryFooter("הבא") {
                storedFirstName = firstName
                storedLastName  = lastName
                focusedField = nil
                withAnimation { page = 2 }
            }
        case 2:
            primaryFooter("המשך לבחירת סוגים") {
                storedVersesPerDay = versesPerDay
                focusedField = nil
                withAnimation { page = 3 }
            }
        case 3:
            primaryFooter("המשך") {
                storedSelectedTags = selected.joined(separator: ",")
                withAnimation { page = 4 }
            }
        case 4:
            VStack(spacing: 10) {
                Button("סרטון מדריך התקנה") {
                    // TODO: hook up later (e.g., open URL / show sheet)
                }
                .buttonStyle(FullWidthBlackButtonStyle())
                .font(.headline)

                Button("אתקין בהמשך!") {
                    hasSeenOnboarding = true
                }
                .buttonStyle(FullWidthWhiteButtonStyle())
                .font(.headline)
            }
        default:
            EmptyView()
        }
    }

    private func primaryFooter(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(FullWidthWhiteButtonStyle())
            .font(.headline)
    }

    // MARK: - Page 0
    private var introView: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("הפסוק היומי")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            Text("פסוק יומי ייחודי – מתחילים את היום בהשראה!")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
            Spacer()
            // ⛔️ Button moved to unified footer
        }
    }

    // MARK: - Page 1 (content stays parked; only the footer moves)
    private var nameView: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("איך תרצה שיקראו לך?")
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            VStack(spacing: 16) {
                TextField("", text: $firstName, prompt: Text("שם פרטי"))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .firstName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)

                TextField("", text: $lastName, prompt: Text("שם משפחה"))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .lastName)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal)

            Spacer(minLength: 0)
            // ⛔️ No overlay, no keyboard tracking, no jump
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Page 2
    private var frequencyView: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("כמה פעמים ביום תרצה פסוק חדש?")
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("השראה קטנה – שינוי גדול")
                .foregroundColor(.white.opacity(0.7))

            Stepper(value: $versesPerDay, in: 1...10) {
                HStack {
                    Text("\(versesPerDay)/10")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
            // ⛔️ Button moved to unified footer
        }
        .onAppear { focusedField = nil }
    }

    // MARK: - Page 3: Multi-select chips
    private var tagsView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 12)

            Text("איזה סוגי פסוקים תרצה לראות?")
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("כל מיני מילים רנדומליות כדי ליצור אפקט מגניב")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            let columns = [GridItem(.adaptive(minimum: 110), spacing: 12, alignment: .trailing)]
            LazyVGrid(columns: columns, alignment: .trailing, spacing: 12) {
                ForEach(chips, id: \.id) { chip in
                    ChipView(
                        title: chip.title,
                        isSelected: selected.contains(chip.id)
                    ) {
                        if selected.contains(chip.id) { selected.remove(chip.id) }
                        else { selected.insert(chip.id) }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
            // ⛔️ Button moved to unified footer
        }
    }

    // MARK: - Page 4: Widget install prompt (no bottom buttons here)
    private var widgetInstallView: some View {
        VStack(spacing: 22) {
            Spacer().frame(height: 24)

            // Widget preview card (stylized mock)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.black.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.07), lineWidth: 1)
                            .padding(6)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)

                // Top pill title
                Text("הפסוק היומי")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                        Capsule().fill(Color.black.opacity(0.65))
                    )
                    .offset(y: -14)

                // Placeholder content bars
                VStack(alignment: .trailing, spacing: 10) {
                    RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)).frame(height: 18)
                    RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)).frame(height: 18)
                    RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)).frame(height: 18)
                    HStack {
                        RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)).frame(width: 80, height: 10)
                        Spacer()
                        RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)).frame(width: 80, height: 10)
                    }
                }
                .padding(24)
            }
            .frame(height: 180)
            .padding(.horizontal)

            Text("הגיע הזמן לשים את\nהפסוק במסך הבית!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("לחץ לחיצה ארוכה על שטח ריק במסך הבית, בחר “עריכה”, והוסף את הווידג׳ט שלנו.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()
            // ⛔️ Both buttons now live in the unified footer
        }
    }

    // Preconfigured chips
    private var chips: [Chip] {
        [
            .init(id: "enemy",      title: "אויב"),
            .init(id: "psalms",     title: "תהילים"),
            .init(id: "community",  title: "קהלת"),
            .init(id: "song",       title: "שיר השירים"),
            .init(id: "jeremiah",   title: "ירמיהו"),
            .init(id: "light",      title: "אורי"),
            .init(id: "hosea",      title: "הושע"),
            .init(id: "tamar",      title: "תמר"),
            .init(id: "daniel",     title: "דניאל"),
            .init(id: "amos",       title: "עמוס"),
            .init(id: "jonah",      title: "יונה"),
            .init(id: "nehemiah",   title: "נחמיה"),
            .init(id: "micah",      title: "מיכה"),
            .init(id: "ruth",       title: "רות")
        ]
    }
}


// MARK: - Models & Views

private struct Chip {
    let id: String
    let title: String
}

private struct ChipView: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Text(isSelected ? title : "+ \(title)")
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(ChipStyle(isSelected: isSelected))
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ChipStyle: ButtonStyle {
    let isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.white : Color.black.opacity(0.35))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isSelected ? Color.white.opacity(0.9) : Color.clear, lineWidth: 1)
            )
            .foregroundColor(isSelected ? .black : .white)
            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
}
