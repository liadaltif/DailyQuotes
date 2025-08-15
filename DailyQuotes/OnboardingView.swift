import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("firstName") private var storedFirstName: String = ""
    @AppStorage("lastName") private var storedLastName: String = ""
    @AppStorage("versesPerDay") private var storedVersesPerDay: Int = 3

    @State private var page = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var versesPerDay: Int = 3

    var body: some View {
        TabView(selection: $page) {
            introView.tag(0)
            nameView.tag(1)
            frequencyView.tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(
            LinearGradient(colors: [Color.black, Color(.sRGB, white: 0.2, opacity: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .environment(\.layoutDirection, .rightToLeft)
    }

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
            Button("יאללה, נתחיל!") {
                withAnimation { page = 1 }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(12)
            .font(.headline)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }

    private var nameView: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("איך תרצה שיקראו לך?")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            VStack(spacing: 16) {
                TextField("", text: $firstName, prompt: Text("שם פרטי"))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                TextField("", text: $lastName, prompt: Text("שם משפחה"))
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal)
            Spacer()
            Button("הבא") {
                storedFirstName = firstName
                storedLastName = lastName
                withAnimation { page = 2 }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(12)
            .font(.headline)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }

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
            .cornerRadius(8)
            .padding(.horizontal)
            Spacer()
            Button("יאללה, בואו נתקדם!") {
                storedVersesPerDay = versesPerDay
                hasSeenOnboarding = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(12)
            .font(.headline)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingView()
}
