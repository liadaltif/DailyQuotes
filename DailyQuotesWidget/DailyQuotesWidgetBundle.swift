//
//  DailyQuotesWidgetBundle.swift
//  DailyQuotesWidgetExtension
//

import WidgetKit
import SwiftUI

@main
struct DailyQuotesWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        DailyQuotesWidget()
        DailyQuotesWidgetControl()
    }
}
