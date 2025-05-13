import AppIntents

struct VertShortcutsProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ConvertIntent(),
            phrases: ["Convert Using \(.applicationName)?", "Use \(.applicationName) to Convert"],
            shortTitle: "Convert",
            systemImageName: "number"
        )
    }
}

