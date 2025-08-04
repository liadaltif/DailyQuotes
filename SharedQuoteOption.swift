import AppIntents

enum QuoteOption: String, AppEnum, CaseDisplayRepresentable, CaseIterable {
    case tzedek   = "צדק צדק תרדוף"
    case goHard   = "תן בראש היום!"
    case silence  = "שקט זה כוח."
    case waves    = "הגלים שרים שיר"
    case start    = "יאללה, מתחילים 😄"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "ציטוט"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .tzedek:  "צדק צדק תרדוף",
        .goHard:  "תן בראש היום!",
        .silence: "שקט זה כוח.",
        .waves:   "הגלים שרים שיר",
        .start:   "יאללה, מתחילים 😄"
    ]
}
