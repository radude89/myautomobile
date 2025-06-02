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
        static let privacyPolicyURL = "https://carchum.app/policies/privacy-policy/"
        static let termsURL = "https://carchum.app/policies/terms/"
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
        let url = isTerms ? Constants.termsURL : Constants.privacyPolicyURL
        return "\(url)mobile-\(languageCode).html"
    }
}
