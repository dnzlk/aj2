// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Chat {
    /// A few examples of interesting things you can ask %@ about
    internal static func aFewExamples(_ p1: Any) -> String {
      return L10n.tr("Localizable", "chat.aFewExamples", String(describing: p1), fallback: "A few examples of interesting things you can ask %@ about")
    }
    /// ask %@
    internal static func ask(_ p1: Any) -> String {
      return L10n.tr("Localizable", "chat.ask", String(describing: p1), fallback: "ask %@")
    }
    /// Copy
    internal static let copy = L10n.tr("Localizable", "chat.copy", fallback: "Copy")
    /// %@ is typing
    internal static func isTyping(_ p1: Any) -> String {
      return L10n.tr("Localizable", "chat.isTyping", String(describing: p1), fallback: "%@ is typing")
    }
    /// No answer here :(
    internal static let noAnswer = L10n.tr("Localizable", "chat.noAnswer", fallback: "No answer here :(")
    /// Share
    internal static let share = L10n.tr("Localizable", "chat.share", fallback: "Share")
    /// Try again
    internal static let tryAgain = L10n.tr("Localizable", "chat.tryAgain", fallback: "Try again")
    /// Type your question
    internal static let typeYourQuestion = L10n.tr("Localizable", "chat.typeYourQuestion", fallback: "Type your question")
  }
  internal enum Feed {
    /// Characters
    internal static let characters = L10n.tr("Localizable", "feed.characters", fallback: "Characters")
    /// Explore
    internal static let explore = L10n.tr("Localizable", "feed.explore", fallback: "Explore")
    /// %@ images
    internal static func imagesLeft(_ p1: Any) -> String {
      return L10n.tr("Localizable", "feed.imagesLeft", String(describing: p1), fallback: "%@ images")
    }
    /// Let's start a chat!
    internal static let letsStart = L10n.tr("Localizable", "feed.letsStart", fallback: "Let's start a chat!")
    /// %@ free messages
    internal static func messagesLeft(_ p1: Any) -> String {
      return L10n.tr("Localizable", "feed.messagesLeft", String(describing: p1), fallback: "%@ free messages")
    }
    /// Start free trial
    internal static let startFreeTrial = L10n.tr("Localizable", "feed.startFreeTrial", fallback: "Start free trial")
    /// You have %@ free messages & %@ images left
    internal static func youHaveMessagesLeft(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "feed.youHaveMessagesLeft", String(describing: p1), String(describing: p2), fallback: "You have %@ free messages & %@ images left")
    }
  }
  internal enum History {
    /// %@ at %@
    internal static func at(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "history.at", String(describing: p1), String(describing: p2), fallback: "%@ at %@")
    }
    /// Clear history?
    internal static let clear = L10n.tr("Localizable", "history.clear", fallback: "Clear history?")
    /// History
    internal static let history = L10n.tr("Localizable", "history.history", fallback: "History")
    /// No
    internal static let no = L10n.tr("Localizable", "history.no", fallback: "No")
    /// Today
    internal static let today = L10n.tr("Localizable", "history.today", fallback: "Today")
    /// You will not be able to undo this action
    internal static let undo = L10n.tr("Localizable", "history.undo", fallback: "You will not be able to undo this action")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "history.yes", fallback: "Yes")
    /// Yesterday
    internal static let yesterday = L10n.tr("Localizable", "history.yesterday", fallback: "Yesterday")
  }
  internal enum Images {
    /// AI Art Generator
    internal static let aiArtGenerator = L10n.tr("Localizable", "images.aiArtGenerator", fallback: "AI Art Generator")
    /// Do it for me
    internal static let doItForMe = L10n.tr("Localizable", "images.doItForMe", fallback: "Do it for me")
    /// It may take some time to create, don't close this screen
    internal static let itMayTakeTime = L10n.tr("Localizable", "images.itMayTakeTime", fallback: "It may take some time to create, don't close this screen")
    /// Save
    internal static let save = L10n.tr("Localizable", "images.save", fallback: "Save")
    /// Share
    internal static let share = L10n.tr("Localizable", "images.share", fallback: "Share")
    /// Something went wrong
    internal static let somethingWentWrong = L10n.tr("Localizable", "images.somethingWentWrong", fallback: "Something went wrong")
    /// Try again
    internal static let tryAgain = L10n.tr("Localizable", "images.tryAgain", fallback: "Try again")
    /// Type your request
    internal static let typeYourRequest = L10n.tr("Localizable", "images.typeYourRequest", fallback: "Type your request")
  }
  internal enum Onboarding {
    /// Fix your grammar
    internal static let fixGrammar = L10n.tr("Localizable", "onboarding.fixGrammar", fallback: "Fix your grammar")
    /// Help with vour studies + gazillion other use cases
    internal static let helpWithStudies = L10n.tr("Localizable", "onboarding.helpWithStudies", fallback: "Help with vour studies + gazillion other use cases")
    /// Learn a new language
    internal static let learn = L10n.tr("Localizable", "onboarding.learn", fallback: "Learn a new language")
    /// Skip
    internal static let skip = L10n.tr("Localizable", "onboarding.skip", fallback: "Skip")
    /// Your writing superpower
    internal static let superpower = L10n.tr("Localizable", "onboarding.superpower", fallback: "Your writing superpower")
    /// Try it out!
    internal static let tryItOut = L10n.tr("Localizable", "onboarding.tryItOut", fallback: "Try it out!")
    /// Write a blog post
    internal static let writeBlog = L10n.tr("Localizable", "onboarding.writeBlog", fallback: "Write a blog post")
  }
  internal enum Payments {
    /// By tapping „Start 3-day free trial“, you agree to our Terms of Use
    internal static let byTappingYouAgree = L10n.tr("Localizable", "payments.byTappingYouAgree", fallback: "By tapping „Start 3-day free trial“, you agree to our Terms of Use")
    /// Transaction failed
    internal static let failed = L10n.tr("Localizable", "payments.failed", fallback: "Transaction failed")
    /// First 3 days free
    internal static let first3free = L10n.tr("Localizable", "payments.first3free", fallback: "First 3 days free")
    /// Get unlimited access to all current (and future) features
    internal static let getAccess = L10n.tr("Localizable", "payments.getAccess", fallback: "Get unlimited access to all current (and future) features")
    /// Month
    internal static let month = L10n.tr("Localizable", "payments.month", fallback: "Month")
    /// Monthly
    internal static let monthly = L10n.tr("Localizable", "payments.monthly", fallback: "Monthly")
    /// Okay
    internal static let okay = L10n.tr("Localizable", "payments.okay", fallback: "Okay")
    /// Transactions restored
    internal static let restored = L10n.tr("Localizable", "payments.restored", fallback: "Transactions restored")
    /// Restore purchase
    internal static let restorePurchase = L10n.tr("Localizable", "payments.restorePurchase", fallback: "Restore purchase")
    /// Save 20%
    internal static let save20 = L10n.tr("Localizable", "payments.save20", fallback: "Save 20%")
    /// Something went wrong
    internal static let somethingWentWrong = L10n.tr("Localizable", "payments.somethingWentWrong", fallback: "Something went wrong")
    /// Start 3-days free trial
    internal static let start = L10n.tr("Localizable", "payments.start", fallback: "Start 3-days free trial")
    /// Week
    internal static let week = L10n.tr("Localizable", "payments.week", fallback: "Week")
    /// Weekly
    internal static let weekly = L10n.tr("Localizable", "payments.weekly", fallback: "Weekly")
  }
  internal enum Post {
    /// Posted on
    internal static let postedOn = L10n.tr("Localizable", "post.postedOn", fallback: "Posted on")
  }
  internal enum Prompts {
    /// Ask for a raise in ultra gen z style
    internal static let askRaiseGenZ = L10n.tr("Localizable", "prompts.askRaiseGenZ", fallback: "Ask for a raise in ultra gen z style")
    /// Use florid, baroque language to describe a potato
    internal static let describePotato = L10n.tr("Localizable", "prompts.describePotato", fallback: "Use florid, baroque language to describe a potato")
    /// Explain quantum physics
    internal static let explainPhysics = L10n.tr("Localizable", "prompts.explainPhysics", fallback: "Explain quantum physics")
    /// Explain the concept of time like I am three years old
    internal static let explainTime3yearsOld = L10n.tr("Localizable", "prompts.explainTime3yearsOld", fallback: "Explain the concept of time like I am three years old")
    /// Explain the concept of time like I am a dog
    internal static let explainTimeDog = L10n.tr("Localizable", "prompts.explainTimeDog", fallback: "Explain the concept of time like I am a dog")
    /// How to say 'I will make him an offer you can't refuse' in Klingon
    internal static let offerKlingon = L10n.tr("Localizable", "prompts.offerKlingon", fallback: "How to say 'I will make him an offer you can't refuse' in Klingon")
    /// How to say 'I will make him an offer you can't refuse' in made-up language
    internal static let offerMadeUp = L10n.tr("Localizable", "prompts.offerMadeUp", fallback: "How to say 'I will make him an offer you can't refuse' in made-up language")
    /// How to say 'I will make him an offer you can't refuse' in Spanish
    internal static let offerSpanish = L10n.tr("Localizable", "prompts.offerSpanish", fallback: "How to say 'I will make him an offer you can't refuse' in Spanish")
    /// Sell me this pen
    internal static let sellMePen = L10n.tr("Localizable", "prompts.sellMePen", fallback: "Sell me this pen")
    /// Tell me about solar system
    internal static let tellMeSolar = L10n.tr("Localizable", "prompts.tellMeSolar", fallback: "Tell me about solar system")
    /// Write a short poem about a rabbit
    internal static let writeAPoemRabbit = L10n.tr("Localizable", "prompts.writeAPoemRabbit", fallback: "Write a short poem about a rabbit")
    /// Write a birthday congrats to my grandma's 90 birthday in ultra gen z style
    internal static let writeBirthdayCongrats = L10n.tr("Localizable", "prompts.writeBirthdayCongrats", fallback: "Write a birthday congrats to my grandma's 90 birthday in ultra gen z style")
    /// Write a breaking news article about a potato
    internal static let writeNewsPotato = L10n.tr("Localizable", "prompts.writeNewsPotato", fallback: "Write a breaking news article about a potato")
    /// Write a invitation to party in wu tang style
    internal static let writeWuTang = L10n.tr("Localizable", "prompts.writeWuTang", fallback: "Write a invitation to party in wu tang style")
  }
  internal enum Settings {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "settings.cancel", fallback: "Cancel")
    /// Contact us
    internal static let contactUs = L10n.tr("Localizable", "settings.contactUs", fallback: "Contact us")
    /// made by programmers empowered by ChatGPT
    internal static let madeBy = L10n.tr("Localizable", "settings.madeBy", fallback: "made by programmers empowered by ChatGPT")
    /// Privacy policy
    internal static let privacy = L10n.tr("Localizable", "settings.privacy", fallback: "Privacy policy")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "settings.settings", fallback: "Settings")
    /// Terms of use
    internal static let terms = L10n.tr("Localizable", "settings.terms", fallback: "Terms of use")
    /// ver
    internal static let ver = L10n.tr("Localizable", "settings.ver", fallback: "ver")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
