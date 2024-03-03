//
//  TermsViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 03.03.2024.
//

import Foundation

struct TermsViewModel {
    let title: String
    let imageName: String
    let isShowingTerms: Bool
    
    private enum Constants {
        static let urlBase = "https://radude89.com/my-automobile/"
        static let termsSuffix = "_terms_and_conditions.html"
        static let privacySuffix = "_policy.html"
    }
    
    init(title: String, imageName: String, isShowingTerms: Bool) {
        self.title = title
        self.imageName = imageName
        self.isShowingTerms = isShowingTerms
    }
    
    var url: URL {
        let locale = Locale.autoupdatingCurrent
        let languageCode = locale.language.languageCode ?? .english
        let urlString = makeURL(for: languageCode, isTerms: isShowingTerms)
        return URL(string: urlString)!
    }
}

private extension TermsViewModel {
    static let appLanguageCodeDictionary: [Locale.LanguageCode: String] = [
        .english: "en",
        .french: "fr",
        .spanish: "es",
        .german: "de",
        .italian: "it",
        .romanian: "ro"
    ]

    func makeURL(
        for languageCode: Locale.LanguageCode,
        isTerms: Bool
    ) -> String {
        let languageCode = Self.appLanguageCodeDictionary[languageCode] ?? "en"
        let urlSuffix = isTerms ? Constants.termsSuffix : Constants.privacySuffix
        return "\(Constants.urlBase)\(languageCode)\(urlSuffix)"
    }
}
