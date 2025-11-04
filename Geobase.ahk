/*
Script: Geobase
Συγγραφέας: Tasos
Έτος: 2025
MIT License
Copyright (c) 2025 Tasos
*/

#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn All, Off

; ----------------------------
; CONSTANTS
; ----------------------------
TIMER_DURATION := 10
TIMER_WARNING := 5
TIMER_CRITICAL := 3
BUTTON_HEIGHT := 40
BUTTON_SPACING := 5
HEADER_WIDTH := 340
ANSWER_DISPLAY_TIME := 1200  ; 1.2 δευτερόλεπτα

; ----------------------------
; Παλέτα χρωμάτων
; ----------------------------
Colors := {
    Primary: "3498DB",
    Success: "27AE60",
    Danger: "E74C3C",
    Warning: "E67E22",
    Dark: "2C3E50",
    Light: "BDC3C7",
    Info: "7F8C8D",
    DarkBg: "1A1A1A",
    DarkText: "ECEFF1"
}

; ----------------------------
; Settings & State
; ----------------------------
isDarkMode := false
soundEnabled := true
difficulty := "normal"

DifficultySettings := Map(
    "easy", {time: 15, options: 2},
    "normal", {time: 10, options: 4},
    "hard", {time: 5, options: 6}
)

; ----------------------------
; Λίστα χωρών και πρωτευουσών
; ----------------------------
countries := Map(
    "Αφγανιστάν", "Καμπούλ",
    "Αλβανία", "Τίρανα",
    "Αλγερία", "Αλγέρι",
    "Ανδόρα", "Ανδόρα λα Βέλια",
    "Ανγκόλα", "Λουάντα",
    "Αντίγκουα και Μπαρμπούντα", "Άγιος Ιωάννης",
    "Αργεντινή", "Μπουένος Άιρες",
    "Αρμενία", "Γερεβάν",
    "Αυστραλία", "Καμπέρα",
    "Αυστρία", "Βιέννη",
    "Αζερμπαϊτζάν", "Μπακού",
    "Μπαχάμες", "Νασσάου",
    "Μπαχρέιν", "Μανάμα",
    "Μπανγκλαντές", "Ντάκα",
    "Μπαρμπάντος", "Μπριτζτάουν",
    "Λευκορωσία", "Μινσκ",
    "Βέλγιο", "Βρυξέλλες",
    "Μπελίζ", "Μπελμοπάν",
    "Μπενίν", "Πόρτο Νόβο",
    "Μπουτάν", "Θίμφου",
    "Βολιβία", "Σούκρε",
    "Βοσνία-Ερζεγοβίνη", "Σαράγεβο",
    "Μποτσουάνα", "Γκαμπορόνε",
    "Βραζιλία", "Μπραζίλια",
    "Μπρουνέι", "Μπαντάρ Σερι Μπεγκαβάν",
    "Βουλγαρία", "Σόφια",
    "Μπουρκίνα Φάσο", "Ουαγκαντουγκού",
    "Μπουρούντι", "Γκιτέγκα",
    "Καμπότζη", "Πνομ Πεν",
    "Καμερούν", "Γιαουντέ",
    "Καναδάς", "Οττάβα",
    "Πράσινο Ακρωτήριο", "Πράια",
    "Κεντροαφρικανική Δημοκρατία", "Μπανγκί",
    "Τσαντ", "Ντζαμένα",
    "Χιλή", "Σαντιάγο",
    "Κίνα", "Πεκίνο",
    "Κολομβία", "Μπογκοτά",
    "Κομόρες", "Μορονί",
    "Κογκό (Δημοκρατία)", "Μπραζαβίλ",
    "Κογκό (Δημοκρατία του)", "Κινσάσα",
    "Κόστα Ρίκα", "Σαν Χοσέ",
    "Κροατία", "Ζάγκρεμπ",
    "Κούβα", "Αβάνα",
    "Κύπρος", "Λευκωσία",
    "Τσεχία", "Πράγα",
    "Δανία", "Κοπεγχάγη",
    "Τζιμπουτί", "Τζιμπουτί",
    "Δομινίκα", "Ροζό",
    "Δομινικανή Δημοκρατία", "Άγιος Δομίνικος",
    "Ανατολικό Τιμόρ", "Ντίλι",
    "Ισημερινός", "Κίτο",
    "Αίγυπτος", "Κάιρο",
    "Ελ Σαλβαδόρ", "Σαν Σαλβαδόρ",
    "Ισημερινή Γουινέα", "Μαλάμπο",
    "Ερυθραία", "Ασμάρα",
    "Εσθονία", "Τάλιν",
    "Εσουατίνι (Σουαζιλάνδη)", "Μπαμπάνε",
    "Αιθιοπία", "Αντίς Αμπέμπα",
    "Φίτζι", "Σούβα",
    "Φινλανδία", "Ελσίνκι",
    "Γαλλία", "Παρίσι",
    "Γκαμπόν", "Λιμπρεβίλ",
    "Γκάμπια", "Μπανζούλ",
    "Γεωργία", "Τιφλίδα",
    "Γερμανία", "Βερολίνο",
    "Γκάνα", "Άκρα",
    "Ελλάδα", "Αθήνα",
    "Γρενάδα", "Σεντ Τζορτζς",
    "Γουατεμάλα", "Πόλη της Γουατεμάλας",
    "Γουινέα", "Κονακρί",
    "Γουινέα-Μπισσάου", "Μπισσάου",
    "Γουιάνα", "Τζορτζτάουν",
    "Αϊτή", "Πορτ-ο-Πρενς",
    "Ονδούρα", "Τεγουσιγάλπα",
    "Ουγγαρία", "Βουδαπέστη",
    "Ισλανδία", "Ρέικιαβικ",
    "Ινδία", "Νέο Δελχί",
    "Ινδονησία", "Τζακάρτα",
    "Ιράν", "Τεχεράνη",
    "Ιράκ", "Βαγδάτη",
    "Ιρλανδία", "Δουβλίνο",
    "Ισραήλ", "Ιερουσαλήμ",
    "Ιταλία", "Ρώμη",
    "Ακτή Ελεφαντοστού", "Γιαμουσούκρο",
    "Τζαμάικα", "Κίνγκστον",
    "Ιαπωνία", "Τόκιο",
    "Ιορδανία", "Αμμάν",
    "Καζακστάν", "Αστανά",
    "Κένυα", "Ναϊρόμπι",
    "Κιριμπάτι", "Νότια Ταράουα",
    "Βόρεια Κορέα", "Πιονγκγιάνγκ",
    "Νότια Κορέα", "Σεούλ",
    "Κόσοβο", "Πρίστινα",
    "Κουβέιτ", "Κουβέιτ",
    "Κιργιζία", "Μπισκέκ",
    "Λάος", "Βιεντιάν",
    "Λετονία", "Ρίγα",
    "Λίβανος", "Βηρυτός",
    "Λεσότο", "Μαζέρου",
    "Λιβερία", "Μονρόβια",
    "Λιβύη", "Τρίπολη",
    "Λιχτενστάιν", "Βαντούζ",
    "Λιθουανία", "Βίλνιους",
    "Λουξεμβούργο", "Λουξεμβούργο",
    "Μαδαγασκάρη", "Ανταναναρίβο",
    "Μαλάουι", "Λιλόνγκουε",
    "Μαλαισία", "Κουάλα Λουμπούρ",
    "Μαλδίβες", "Μαλέ",
    "Μάλι", "Μπαμακό",
    "Μάλτα", "Βαλέτα",
    "Νησιά Μάρσαλ", "Ματζούρο",
    "Μαυριτανία", "Νουακσότ",
    "Μαυρίκιος", "Πορτ Λουί",
    "Μεξικό", "Πόλη του Μεξικού",
    "Μικρονησία", "Παλικίρ",
    "Μολδαβία", "Κισινάου",
    "Μονακό", "Μονακό",
    "Μογγολία", "Ουλάν Μπατόρ",
    "Μαυροβούνιο", "Ποντγκόριτσα",
    "Μαρόκο", "Ραμπάτ",
    "Μοζαμβίκη", "Μαπούτο",
    "Μιανμάρ", "Νέπιντο",
    "Ναμίμπια", "Γουίντχουк",
    "Νεπάλ", "Κατμαντού",
    "Ολλανδία", "Άμστερνταμ",
    "Νέα Ζηλανδία", "Ουέλλινγκτον",
    "Νικαράγουα", "Μανάγουα",
    "Νίγηρας", "Νιαμέι",
    "Νιγηρία", "Αμπούτζα",
    "Βόρεια Μακεδονία", "Σκόπια",
    "Νορβηγία", "Όσλο",
    "Ομάν", "Μασκάτ",
    "Πακιστάν", "Ισλαμαμπάντ",
    "Παλαιστίνη", "Ανατολική Ιερουσαλήμ",
    "Παλάου", "Νγκερουλμούντ",
    "Παναμάς", "Παναμάς",
    "Παπούα Νέα Γουινέα", "Πορτ Μόρεσμπι",
    "Παραγουάη", "Ασουνσιόν",
    "Περού", "Λίμα",
    "Φιλιππίνες", "Μανίλα",
    "Πολωνία", "Βαρσοβία",
    "Πορτογαλία", "Λισαβόνα",
    "Πουέρτο Ρίκο", "Σαν Χουάν",
    "Κατάρ", "Ντόχα",
    "Ρουμανία", "Βουκουρέστι",
    "Ρωσία", "Μόσχα",
    "Ρουάντα", "Κιγκάλι",
    "Άγιος Χριστόφορος και Νέβις", "Μπασέτερ",
    "Άγιος Λουκίας", "Κάστρις",
    "Άγιος Βικέντιος και Γρεναδίνες", "Κινγκσταουν",
    "Σαμόα", "Απία",
    "Άγιος Μαρίνος", "Άγιος Μαρίνος",
    "Σάο Τομέ και Πρίνσιπε", "Σάο Τομέ",
    "Σαουδική Αραβία", "Ριάντ",
    "Σενεγάλη", "Ντακάρ",
    "Σερβία", "Βελιγράδι",
    "Σεϋχέλλες", "Βικτώρια",
    "Σιέρα Λεόνε", "Φρίταουν",
    "Σιγκαπούρη", "Σιγκαπούρη",
    "Σλοβακία", "Μπρατισλάβα",
    "Σλοβενία", "Λιουμπλιάνα",
    "Νησιά Σολομώντα", "Χονιάρα",
    "Σομαλία", "Μογκαντίσου",
    "Νότια Αφρική", "Πρετόρια",
    "Νότιο Σουδάν", "Τζούμπα",
    "Ισπανία", "Μαδρίτη",
    "Σρι Λάνκα", "Σρι Τζαγιαβαρντενεπούρα Κότε",
    "Σουδάν", "Χαρτούμ",
    "Σουρινάμ", "Παραμαρίμπο",
    "Σουηδία", "Στοκχόλμη",
    "Ελβετία", "Βέρνη",
    "Συρία", "Δαμασκός",
    "Ταϊβάν", "Ταϊπέι",
    "Τατζικιστάν", "Ντουσαμπέ",
    "Τανζανία", "Ντοντόμα",
    "Ταϊλάνδη", "Μπανγκόκ",
    "Τόγκο", "Λομέ",
    "Τόνγκα", "Νουκουαλόφα",
    "Τρινιντάντ και Τομπάγκο", "Πορτ οφ Σπέιν",
    "Τυνησία", "Τύνιδα",
    "Τουρκία", "Άγκυρα",
    "Τουρκμενιστάν", "Ασγκαμπάτ",
    "Τουβαλού", "Φουναφούτι",
    "Ουγκάντα", "Καμπάλα",
    "Ουκρανία", "Κίεβο",
    "Ηνωμένα Αραβικά Εμιράτα", "Αμπού Ντάμπι",
    "Ηνωμένο Βασίλειο", "Λονδίνο",
    "Ηνωμένες Πολιτείες", "Ουάσιγκτον",
    "Ουρουγουάη", "Μοντεβιδέο",
    "Ουζμπεκιστάν", "Τασκένδη",
    "Βανουάτου", "Πορτ Βίλα",
    "Βατικανό", "Πόλη του Βατικανού",
    "Βενεζουέλα", "Καράκας",
    "Βιετνάμ", "Ανόι",
    "Υεμένη", "Σανάα",
    "Ζάμπια", "Λουσάκα",
    "Ζιμπάμπουε", "Χαράρε"
)

; ----------------------------
; Μεταβλητές για το κουίζ
; ----------------------------
quizMode := 1
quizCount := 10
currentIndex := 1
score := 0
answeredCount := 0
wrongAnswers := []
MyGui := ""
timerActive := false
isPaused := false
timeLeft := 0
timerInterval := 1000
timerText := ""
pauseBtn := ""
answerStartTime := 0
isShowingAnswer := false

; ----------------------------
; Initialization
; ----------------------------
LoadSettings()
if (!ValidateCountries()) {
    ExitApp(1)
}

; ----------------------------
; Συναρτήσεις βοηθητικές
; ----------------------------
RandomShuffle(arr) {
    loop arr.Length - 1 {
        i := arr.Length - A_Index + 1
        j := Random(1, i)
        temp := arr[i]
        arr[i] := arr[j]
        arr[j] := temp
    }
}

HasValue(arr, value) {
    for _, item in arr
        if (item = value)
            return true
    return false
}

PlaySound(type) {
    global soundEnabled
    if (!soundEnabled)
        return
    try {
        switch type {
            case "correct": SoundBeep(800, 200)
            case "wrong": SoundBeep(400, 300)
            case "timeout": SoundBeep(300, 400)
        }
    } catch as e {
        ; Silent fail if sound not available
    }
}

GetThemeColors() {
    global isDarkMode, Colors
    if (isDarkMode) {
        return {
            bg: Colors.DarkBg,
            text: Colors.DarkText,
            header: "2C3E50"
        }
    }
    return {
        bg: "FFFFFF",
        text: "000000",
        header: Colors.Dark
    }
}

; ----------------------------
; Validation Functions
; ----------------------------
ValidateCountries() {
    global countries
    
    ; Έλεγχος για κενή λίστα
    if (countries.Count = 0) {
        MsgBox "Κρίσιμο Σφάλμα: Η λίστα χωρών είναι κενή!`nΤο πρόγραμμα θα τερματιστεί.", "Geobase - Σφάλμα", "Icon!"
        return false
    }
    
    uniqueCapitals := Map()
    
    for country, capital in countries {
        if (capital = "" || country = "") {
            MsgBox "Κρίσιμο Σφάλμα: Κενό δεδομένο βρέθηκε!`nΧώρα: " country "`nΠρωτεύουσα: " capital "`nΤο πρόγραμμα θα τερματιστεί.", "Geobase - Σφάλμα", "Icon!"
            return false
        }
        if uniqueCapitals.Has(capital) {
            MsgBox "Κρίσιμο Σφάλμα: Διπλότυπη πρωτεύουσα βρέθηκε!`nΠρωτεύουσα: " capital "`nΥπάρχει ήδη για: " uniqueCapitals[capital] "`nΠροστέθηκε για: " country "`nΤο πρόγραμμα θα τερματιστεί.", "Geobase - Σφάλμα", "Icon!"
            return false
        }
        uniqueCapitals[capital] := country
    }
    return true
}

BackupSettings() {
    try {
        if FileExist("Geobase_Settings.ini") {
            FileCopy("Geobase_Settings.ini", "Geobase_Settings.backup.ini", 1)
        }
        if FileExist("Geobase_Stats.ini") {
            FileCopy("Geobase_Stats.ini", "Geobase_Stats.backup.ini", 1)
        }
    } catch as e {
        ; Silent backup failure
    }
}

; ----------------------------
; Settings Management
; ----------------------------
LoadSettings() {
    global quizMode, quizCount, isDarkMode, soundEnabled, difficulty
    try {
        quizMode := Integer(IniRead("Geobase_Settings.ini", "Settings", "QuizMode", 1))
        quizCount := Integer(IniRead("Geobase_Settings.ini", "Settings", "QuizCount", 10))
        isDarkMode := Integer(IniRead("Geobase_Settings.ini", "Settings", "DarkMode", 0))
        soundEnabled := Integer(IniRead("Geobase_Settings.ini", "Settings", "SoundEnabled", 1))
        difficulty := IniRead("Geobase_Settings.ini", "Settings", "Difficulty", "normal")
        
        ; Validate loaded settings
        if (quizMode != 1 && quizMode != 2)
            quizMode := 1
        if (quizCount <= 0)
            quizCount := 10
        if (difficulty != "easy" && difficulty != "normal" && difficulty != "hard")
            difficulty := "normal"
            
    } catch as e {
        ; Use default settings if error
        quizMode := 1
        quizCount := 10
        isDarkMode := 0
        soundEnabled := 1
        difficulty := "normal"
    }
}

SaveSettings() {
    global quizMode, quizCount, isDarkMode, soundEnabled, difficulty
    try {
        BackupSettings()
        IniWrite(quizMode, "Geobase_Settings.ini", "Settings", "QuizMode")
        IniWrite(quizCount, "Geobase_Settings.ini", "Settings", "QuizCount")
        IniWrite(isDarkMode, "Geobase_Settings.ini", "Settings", "DarkMode")
        IniWrite(soundEnabled, "Geobase_Settings.ini", "Settings", "SoundEnabled")
        IniWrite(difficulty, "Geobase_Settings.ini", "Settings", "Difficulty")
    } catch as e {
        MsgBox "Σφάλμα αποθήκευσης ρυθμίσεων: " e.Message, "Geobase - Error", "Icon!"
    }
}

; ----------------------------
; MAIN MENU
; ----------------------------
ShowMainMenu() {
    global quizMode, quizCount, MyGui, isDarkMode, difficulty
    
    if (MyGui) {
        try {
            MyGui.Destroy()
        } catch as e {
            ; GUI already destroyed
        }
        MyGui := ""
    }
    
    StopTimer()
    
    theme := GetThemeColors()
    
    try {
        TraySetIcon("Shell32.dll", 44)
    } catch as e {
        ; Icon not available, continue without
    }
    
    MyGui := Gui("+MaximizeBox +MinimizeBox", "🌍 Geobase")
    MyGui.BackColor := theme.bg
    MyGui.SetFont("s10 c" theme.text, "Segoe UI")
    MyGui.MarginX := 20
    MyGui.MarginY := 15
    
    ; Header
    headerSection := MyGui.Add("Text", "w" HEADER_WIDTH " h60 Center Background" theme.header " cWhite 0x200", "GEOBASE")
    headerSection.SetFont("s16 Bold")
    
    ; High Score Display
    highScore := LoadHighScore()
    if (highScore.percent > 0) {
        hsText := MyGui.Add("Text", "x20 y+10 w300 h25 Center", 
            "🏆 Καλύτερο: " highScore.score "/" highScore.total " (" Round(highScore.percent, 1) "%)")
        hsText.SetFont("s9 Bold c" Colors.Success)
    }
    
    ; Ρυθμίσεις
    settingsTitle := MyGui.Add("Text", "x20 y+15 w300 h25", "Ρυθμίσεις Κουίζ")
    settingsTitle.SetFont("s12 Bold c" Colors.Primary)
    
    ; Τύπος Κουίζ
    MyGui.Add("Text", "x20 y+10 w300 h20", "Τύπος Κουίζ:")
    mode1 := MyGui.Add("Radio", "x25 y+5 w140 h30 " (quizMode = 1 ? "Checked" : ""), "Χώρα → Πρωτεύουσα")
    mode1.OnEvent("Click", (*) => quizMode := 1)
    mode2 := MyGui.Add("Radio", "x165 yp w140 h30 " (quizMode = 2 ? "Checked" : ""), "Πρωτεύουσα → Χώρα")  
    mode2.OnEvent("Click", (*) => quizMode := 2)
    
    ; Δυσκολία
    MyGui.Add("Text", "x20 y+15 w300 h20", "Δυσκολία:")
    diff1 := MyGui.Add("Radio", "x25 y+5 w80 h25 " (difficulty = "easy" ? "Checked" : ""), "Εύκολη")
    diff1.OnEvent("Click", (*) => difficulty := "easy")
    diff2 := MyGui.Add("Radio", "x105 yp w80 h25 " (difficulty = "normal" ? "Checked" : ""), "Κανονική")
    diff2.OnEvent("Click", (*) => difficulty := "normal")
    diff3 := MyGui.Add("Radio", "x185 yp w80 h25 " (difficulty = "hard" ? "Checked" : ""), "Δύσκολη")
    diff3.OnEvent("Click", (*) => difficulty := "hard")
    
    ; Αριθμός Ερωτήσεων
    MyGui.Add("Text", "x20 y+15 w300 h20", "Αριθμός Ερωτήσεων:")
    count10 := MyGui.Add("Radio", "x25 y+5 w60 h25 " (quizCount = 10 ? "Checked" : ""), "10")
    count10.OnEvent("Click", (*) => quizCount := 10)
    count20 := MyGui.Add("Radio", "x85 yp w60 h25 " (quizCount = 20 ? "Checked" : ""), "20")
    count20.OnEvent("Click", (*) => quizCount := 20)
    count30 := MyGui.Add("Radio", "x145 yp w60 h25 " (quizCount = 30 ? "Checked" : ""), "30")
    count30.OnEvent("Click", (*) => quizCount := 30)
    countAll := MyGui.Add("Radio", "x205 yp w80 h25 " (quizCount = countries.Count ? "Checked" : ""), "Όλες")
    countAll.OnEvent("Click", (*) => quizCount := countries.Count)
    
    ; Buttons
    startBtn := MyGui.Add("Button", "x70 y+25 w80 h35 Default", "🚀 Έναρξη")
    startBtn.SetFont("s10 Bold")
    startBtn.OnEvent("Click", StartQuiz)
    
    statsBtn := MyGui.Add("Button", "x155 yp w80 h35", "📊 Στατιστικά")
    statsBtn.SetFont("s10 Bold")
    statsBtn.OnEvent("Click", (*) => ShowStatistics())
    
    settingsBtn := MyGui.Add("Button", "x240 yp w80 h35", "⚙️ Ρυθμίσεις")
    settingsBtn.SetFont("s10 Bold")
    settingsBtn.OnEvent("Click", (*) => ShowSettingsDialog())
    
    ; Info
    diffInfo := DifficultySettings[difficulty]
    info := MyGui.Add("Text", "x20 y+15 w300 h20 Center", 
        "⏱️ " diffInfo.time " δευτ. | " diffInfo.options " επιλογές")
    info.SetFont("s9 c" Colors.Info)
    
    MyGui.OnEvent("Close", CloseHandler)
    MyGui.OnEvent("Escape", CloseHandler)
    
    try {
        MyGui.Show("Center AutoSize")
    } catch as e {
        MsgBox "Σφάλμα εμφάνισης παραθύρου: " e.Message, "Geobase - Error", "Icon!"
    }
}

; ----------------------------
; Settings Dialog
; ----------------------------
ShowSettingsDialog() {
    global isDarkMode, soundEnabled, MyGui
    
    try {
        settingsGui := Gui("+Owner" MyGui.Hwnd " +AlwaysOnTop", "⚙️ Ρυθμίσεις")
        settingsGui.SetFont("s10", "Segoe UI")
        settingsGui.MarginX := 20
        settingsGui.MarginY := 15
        
        settingsGui.Add("Text", "w250 h25", "Εμφάνιση:")
        darkModeCheck := settingsGui.Add("Checkbox", "x20 y+5 w250 h25 " (isDarkMode ? "Checked" : ""), "🌙 Dark Mode")
        
        settingsGui.Add("Text", "x20 y+15 w250 h25", "Ήχος:")
        soundCheck := settingsGui.Add("Checkbox", "x20 y+5 w250 h25 " (soundEnabled ? "Checked" : ""), "🔊 Ενεργοποίηση ήχων")
        
        saveBtn := settingsGui.Add("Button", "x50 y+25 w80 h35 Default", "💾 Αποθήκευση")
        saveBtn.OnEvent("Click", (*) => SaveSettingsDialog(settingsGui, darkModeCheck, soundCheck))
        
        cancelBtn := settingsGui.Add("Button", "x140 yp w80 h35", "❌ Ακύρωση")
        cancelBtn.OnEvent("Click", (*) => settingsGui.Destroy())
        
        settingsGui.Show("Center")
    } catch as e {
        MsgBox "Σφάλμα ανοίγματος ρυθμίσεων: " e.Message, "Geobase - Error", "Icon!"
    }
}

SaveSettingsDialog(settingsGui, darkModeCheck, soundCheck) {
    global isDarkMode, soundEnabled
    
    isDarkMode := darkModeCheck.Value
    soundEnabled := soundCheck.Value
    
    SaveSettings()
    settingsGui.Destroy()
    ShowMainMenu()
}

; ----------------------------
; Statistics Screen
; ----------------------------
ShowStatistics() {
    global MyGui
    
    try {
        totalPlayed := Integer(IniRead("Geobase_Stats.ini", "Stats", "TotalPlayed", 0))
        totalCorrect := Integer(IniRead("Geobase_Stats.ini", "Stats", "TotalCorrect", 0))
        totalQuestions := Integer(IniRead("Geobase_Stats.ini", "Stats", "TotalQuestions", 0))
        bestScore := Integer(IniRead("Geobase_Stats.ini", "Stats", "BestScore", 0))
        bestTotal := Integer(IniRead("Geobase_Stats.ini", "Stats", "BestTotal", 0))
        bestPercent := Float(IniRead("Geobase_Stats.ini", "Stats", "BestPercent", 0))
        
        avgPercent := totalQuestions > 0 ? Round((totalCorrect / totalQuestions) * 100, 1) : 0
    } catch {
        totalPlayed := 0
        totalCorrect := 0
        totalQuestions := 0
        avgPercent := 0
        bestScore := 0
        bestTotal := 0
        bestPercent := 0
    }
    
    try {
        statsGui := Gui("+Owner" MyGui.Hwnd " +AlwaysOnTop", "📊 Στατιστικά")
        statsGui.BackColor := "FFFFFF"
        statsGui.SetFont("s10", "Segoe UI")
        statsGui.MarginX := 20
        statsGui.MarginY := 15
        
        ; Header
        header := statsGui.Add("Text", "w300 h50 Center Background" Colors.Primary " cWhite 0x200", "ΣΤΑΤΙΣΤΙΚΑ")
        header.SetFont("s14 Bold")
        
        ; Συνολικά Παιχνίδια
        statsGui.Add("Text", "x20 y+20 w280 h25", "🎮 Συνολικά Παιχνίδια:")
        statsGui.Add("Text", "x20 y+2 w280 h30 Center", totalPlayed)
        statsGui.SetFont("s14 Bold c" Colors.Primary)
        statsGui.Add("Text", "x20 y+5 w280 h1")
        statsGui.SetFont("s10")
        
        ; Μέσος Όρος
        statsGui.Add("Text", "x20 y+15 w280 h25", "📈 Μέσος Όρος:")
        avgText := statsGui.Add("Text", "x20 y+2 w280 h30 Center", avgPercent "%")
        avgText.SetFont("s14 Bold c" Colors.Warning)
        statsGui.Add("Text", "x20 y+5 w280 h1")
        statsGui.SetFont("s10")
        
        ; Καλύτερο Σκορ
        statsGui.Add("Text", "x20 y+15 w280 h25", "🏆 Καλύτερο Σκορ:")
        bestText := statsGui.Add("Text", "x20 y+2 w280 h30 Center", bestScore "/" bestTotal " (" Round(bestPercent, 1) "%)")
        bestText.SetFont("s14 Bold c" Colors.Success)
        
        ; Σύνολο Απαντήσεων
        statsGui.Add("Text", "x20 y+20 w280 h25", "Σύνολο Σωστών: " totalCorrect " / " totalQuestions)
        statsGui.SetFont("s9 c" Colors.Info)
        
        ; Κουμπιά
        resetBtn := statsGui.Add("Button", "x50 y+20 w90 h35", "🗑️ Μηδενισμός")
        resetBtn.SetFont("s9 Bold")
        resetBtn.OnEvent("Click", (*) => ResetStatistics(statsGui))
        
        closeBtn := statsGui.Add("Button", "x150 yp w90 h35 Default", "✓ Κλείσιμο")
        closeBtn.SetFont("s9 Bold")
        closeBtn.OnEvent("Click", (*) => statsGui.Destroy())
        
        statsGui.Show("Center")
    } catch as e {
        MsgBox "Σφάλμα εμφάνισης στατιστικών: " e.Message, "Geobase - Error", "Icon!"
    }
}

ResetStatistics(statsGui) {
    result := MsgBox("Είστε σίγουροι ότι θέλετε να μηδενίσετε όλα τα στατιστικά;", "Επιβεβαίωση", "YesNo Icon?")
    if (result = "Yes") {
        try {
            FileDelete("Geobase_Stats.ini")
            statsGui.Destroy()
            MsgBox("Τα στατιστικά μηδενίστηκαν!", "Επιτυχία", "Iconi")
        } catch as e {
            MsgBox "Σφάλμα μηδενισμού στατιστικών: " e.Message, "Geobase - Error", "Icon!"
        }
    }
}

CloseHandler(*) {
    SaveSettings()
    StopTimer()
    ExitApp()
}

StartQuiz(*) {
    SaveSettings()
    InitializeQuiz()
    ShowQuestion()
}

InitializeQuiz() {
    global currentIndex, score, answeredCount, wrongAnswers, quizCountries, countries, quizMode, quizCount
    
    currentIndex := 1
    score := 0
    answeredCount := 0
    wrongAnswers := []
    allItems := []
    
    if (quizMode = 1) {
        for country in countries
            allItems.Push(country)
    } else {
        for country, capital in countries
            allItems.Push(capital)
    }
    
    RandomShuffle(allItems)
    
    if (quizCount > allItems.Length)
        quizCount := allItems.Length
    
    quizCountries := []
    loop quizCount
        quizCountries.Push(allItems[A_Index])
}

; ----------------------------
; Timer Functions - ΔΙΟΡΘΩΜΕΝΕΣ
; ----------------------------
StartTimer() {
    global timerActive, timeLeft, timerInterval, answerStartTime, difficulty, DifficultySettings, isPaused, isShowingAnswer
    if (isShowingAnswer)
        return
        
    timerActive := true
    isPaused := false
    timeLeft := DifficultySettings[difficulty].time
    answerStartTime := A_TickCount
    SetTimer(UpdateTimer, timerInterval)
}

StopTimer() {
    global timerActive, timerText
    timerActive := false
    SetTimer(UpdateTimer, 0)
    
    ; Ενημέρωση του timer text
    try {
        if (timerText && IsObject(timerText)) {
            timerText.Text := "⏱️ Παύση"
            timerText.SetFont("s10 c" Colors.Info)
        }
    } catch as e {
        ; Silent error
    }
}

PauseTimer(*) {
    global timerActive, isPaused, pauseBtn, isShowingAnswer
    
    if (isShowingAnswer)
        return
        
    if (!pauseBtn || !IsObject(pauseBtn))
        return
    
    if (timerActive && !isPaused) {
        isPaused := true
        timerActive := false
        SetTimer(UpdateTimer, 0)
        pauseBtn.Text := "▶️"
        
        ; Απενεργοποίηση όλων των κουμπιών εκτός από pause
        try {
            global MyGui
            for ctrl in MyGui {
                if (ctrl.Type = "Button" && ctrl.Hwnd != pauseBtn.Hwnd)
                    ctrl.Enabled := false
            }
        } catch as e {
            ; Silent error
        }
    } else if (isPaused) {
        isPaused := false
        timerActive := true
        SetTimer(UpdateTimer, timerInterval)
        pauseBtn.Text := "⏸️"
        
        ; Ενεργοποίηση κουμπιών
        try {
            global MyGui
            for ctrl in MyGui {
                if (ctrl.Type = "Button")
                    ctrl.Enabled := true
            }
        } catch as e {
            ; Silent error
        }
    }
}

UpdateTimer() {
    global timerActive, timeLeft, timerText, isPaused, isShowingAnswer
    
    if (!timerActive || isPaused || isShowingAnswer)
        return
    
    timeLeft--
    
    if (timeLeft < 0) {
        StopTimer()
        TimeUp()
        return
    }
    
    try {
        if (timerText && IsObject(timerText)) {
            timerText.Text := "⏱️ " timeLeft " δευτ."
            if (timeLeft <= TIMER_CRITICAL)
                timerText.SetFont("s10 Bold c" Colors.Danger)
            else if (timeLeft <= TIMER_WARNING)
                timerText.SetFont("s10 Bold c" Colors.Warning)
            else
                timerText.SetFont("s10 Bold c" Colors.Primary)
        }
    } catch as e {
        ; Silent error
    }
}

TimeUp() {
    global currentIndex, quizCountries, countries, quizMode, answeredCount, wrongAnswers, isShowingAnswer
    
    isShowingAnswer := true
    
    questionItem := quizCountries[currentIndex]
    
    if (quizMode = 1) {
        correctAnswer := countries[questionItem]
        wrongAnswers.Push({question: questionItem, correct: correctAnswer, yourAnswer: "⏰ Έληξε ο χρόνος!"})
    } else {
        correctAnswer := ""
        for c, capital in countries {
            if (capital = questionItem) {
                correctAnswer := c
                break
            }
        }
        wrongAnswers.Push({question: questionItem, correct: correctAnswer, yourAnswer: "⏰ Έληξε ο χρόνος!"})
    }
    
    HighlightAnswer(correctAnswer, "")
    answeredCount++
    
    PlaySound("timeout")
    
    SetTimer(NextQuestionDelayed, ANSWER_DISPLAY_TIME)
}

; ----------------------------
; Question Display - ΔΙΟΡΘΩΜΕΝΟ
; ----------------------------
ShowQuestion() {
    global currentIndex, quizCountries, countries, score, answeredCount, MyGui, quizMode, timerText, pauseBtn, difficulty, DifficultySettings, isShowingAnswer
    
    if (currentIndex > quizCountries.Length) {
        ShowResults()
        return
    }
    
    isShowingAnswer := false
    
    questionItem := quizCountries[currentIndex]
    
    if (quizMode = 1) {
        correctAnswer := countries[questionItem]
        questionText := "Πρωτεύουσα της:"
        answerText := questionItem
    } else {
        correctAnswer := ""
        for country, capital in countries {
            if (capital = questionItem) {
                correctAnswer := country
                break
            }
        }
        questionText := "Χώρα της πρωτεύουσας:"
        answerText := questionItem
    }
    
    ; Δημιουργία επιλογών βάσει δυσκολίας
    diffSettings := DifficultySettings[difficulty]
    numOptions := diffSettings.options
    
    wrongOptions := []
    allOptions := []
    
    if (quizMode = 1) {
        for _, capital in countries
            if (!HasValue(allOptions, capital))
                allOptions.Push(capital)
    } else {
        for country in countries
            if (!HasValue(allOptions, country))
                allOptions.Push(country)
    }
    
    while (wrongOptions.Length < (numOptions - 1)) {
        randomIndex := Random(1, allOptions.Length)
        candidate := allOptions[randomIndex]
        if (candidate != correctAnswer && !HasValue(wrongOptions, candidate))
            wrongOptions.Push(candidate)
    }
    
    options := []
    for option in wrongOptions
        options.Push(option)
    options.Push(correctAnswer)
    RandomShuffle(options)
    
    ; GUI Ερώτησης
    if (MyGui) {
        try {
            MyGui.Destroy()
        } catch as e {
            ; GUI already destroyed
        }
        MyGui := ""
    }
    
    theme := GetThemeColors()
    
    try {
        TraySetIcon("Shell32.dll", 44)
    } catch as e {
        ; Icon not available
    }
    
    MyGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "🌍 Quiz - " currentIndex "/" quizCountries.Length)
    MyGui.BackColor := theme.bg
    MyGui.SetFont("s10 c" theme.text, "Segoe UI")
    MyGui.MarginX := 20
    MyGui.MarginY := 15
    
    ; Header
    headerSection := MyGui.Add("Text", "w" HEADER_WIDTH " h50 Center Background" Colors.Primary " cWhite 0x200", "Γεωγραφικό Κουίζ")
    headerSection.SetFont("s14 Bold")
    
    ; Progress και Timer σε μία γραμμή
    progress := MyGui.Add("Text", "x20 y+10 w100 h25", "Ερ. " currentIndex "/" quizCountries.Length)
    progress.SetFont("s10 Bold c" Colors.Dark)
    
    pauseBtn := MyGui.Add("Button", "x130 yp w40 h25", "⏸️")
    pauseBtn.SetFont("s9")
    pauseBtn.OnEvent("Click", PauseTimer)
    
    timerText := MyGui.Add("Text", "x180 yp w140 h25 Right", "⏱️ " diffSettings.time " δευτ.")
    timerText.SetFont("s10 Bold c" Colors.Primary)
    
    ; Progress bar
    progressBar := MyGui.Add("Progress", "x20 y+5 w300 h6 Background" Colors.Light, 
        Round((currentIndex / quizCountries.Length) * 100))
    
    ; Ερώτηση
    questionLabel := MyGui.Add("Text", "x20 y+20 w300 h25 Center", questionText)
    questionLabel.SetFont("s11 Bold c34495E")
    answerLabel := MyGui.Add("Text", "x20 y+5 w300 h30 Center", "«" answerText "»")
    answerLabel.SetFont("s12 Bold c" Colors.Dark)
    
    ; Επιλογές απάντησης
    firstBtn := true
    for i, option in options {
        if (firstBtn) {
            btn := MyGui.Add("Button", "x30 y+20 w260 h" BUTTON_HEIGHT " Center", option)
            firstBtn := false
        } else {
            btn := MyGui.Add("Button", "x30 y+" BUTTON_SPACING " w260 h" BUTTON_HEIGHT " Center", option)
        }
        btn.SetFont("s10")
        btn.OnEvent("Click", ButtonClicked)
    }
    
    ; Score
    scoreText := MyGui.Add("Text", "x20 y+15 w300 h25 Center", "🏆 Σκορ: " score " / " answeredCount)
    scoreText.SetFont("s10 Bold c" Colors.Success)
    
    MyGui.OnEvent("Close", CloseHandler)
    MyGui.OnEvent("Escape", CloseHandler)
    
    try {
        MyGui.Show("Center AutoSize")
    } catch as e {
        MsgBox "Σφάλμα εμφάνισης ερώτησης: " e.Message, "Geobase - Error", "Icon!"
        return
    }
    
    StartTimer()
}

ButtonClicked(btn, info) {
    global currentIndex, quizCountries, countries, score, answeredCount, wrongAnswers, quizMode, answerStartTime, isShowingAnswer, timerText
    
    if (isShowingAnswer)
        return
        
    StopTimer()
    isShowingAnswer := true
    
    ; Ενημέρωση του timer text
    try {
        if (timerText && IsObject(timerText)) {
            timerText.Text := "⏱️ Απάντηση"
            timerText.SetFont("s10 c" Colors.Info)
        }
    } catch as e {
        ; Silent error
    }
    
    selected := btn.Text
    questionItem := quizCountries[currentIndex]
    
    responseTime := Round((A_TickCount - answerStartTime) / 1000, 1)
    
    if (quizMode = 1) {
        correctAnswer := countries[questionItem]
    } else {
        correctAnswer := ""
        for country, capital in countries {
            if (capital = questionItem) {
                correctAnswer := country
                break
            }
        }
    }
    
    if (selected = correctAnswer) {
        score++
        PlaySound("correct")
    } else {
        wrongAnswers.Push({question: questionItem, correct: correctAnswer, yourAnswer: selected})
        PlaySound("wrong")
    }
    
    HighlightAnswer(correctAnswer, selected)
    answeredCount++
    
    SetTimer(NextQuestionDelayed, ANSWER_DISPLAY_TIME)
}

HighlightAnswer(correct, selected) {
    global MyGui
    
    if (!MyGui || !IsObject(MyGui))
        return
    
    try {
        for ctrl in MyGui {
            if (ctrl.Type = "Button" && ctrl.Text != "⏸️" && ctrl.Text != "▶️") {
                ctrl.Enabled := false
                if (ctrl.Text = correct) {
                    ctrl.Opt("Background" Colors.Success " cWhite")
                    ctrl.SetFont("Bold")
                } else if (ctrl.Text = selected && selected != correct) {
                    ctrl.Opt("Background" Colors.Danger " cWhite")
                    ctrl.SetFont("Bold")
                } else {
                    ctrl.Opt("Background" Colors.Light)
                }
            }
        }
    } catch as err {
        ; Silent error handling
    }
}

NextQuestionDelayed() {
    global isShowingAnswer
    isShowingAnswer := false
    SetTimer(NextQuestionDelayed, 0)  ; Απενεργοποίηση του timer
    NextQuestion()
}

NextQuestion() {
    global currentIndex
    currentIndex++
    ShowQuestion()
}

; ----------------------------
; Results Screen
; ----------------------------
ShowResults() {
    global score, quizCountries, wrongAnswers, MyGui, isShowingAnswer
    
    isShowingAnswer := false
    StopTimer()
    
    percent := Round((score / quizCountries.Length) * 100, 2)
    
    if (MyGui) {
        try {
            MyGui.Destroy()
        } catch as e {
            ; GUI already destroyed
        }
        MyGui := ""
    }
    
    theme := GetThemeColors()
    
    try {
        TraySetIcon("Shell32.dll", 44)
    } catch as e {
        ; Icon not available
    }
    
    MyGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "🎯 Αποτελέσματα")
    MyGui.BackColor := theme.bg
    MyGui.SetFont("s10 c" theme.text, "Segoe UI")
    MyGui.MarginX := 20
    MyGui.MarginY := 15
    
    ; Header
    headerSection := MyGui.Add("Text", "w" HEADER_WIDTH " h60 Center Background" Colors.Dark " cWhite 0x200", "ΑΠΟΤΕΛΕΣΜΑΤΑ")
    headerSection.SetFont("s16 Bold")
    
    ; Βασικά Αποτελέσματα
    scoreText := MyGui.Add("Text", "x20 y+20 w300 h40 Center", score " / " quizCountries.Length)
    scoreText.SetFont("s20 Bold c" Colors.Primary)
    percentText := MyGui.Add("Text", "x20 y+0 w300 h25 Center", percent "%")
    percentText.SetFont("s14 Bold c" Colors.Info)
    
    ; Μήνυμα
    if (percent = 100)
        msg := "🎉 Τέλειο! Εξαιρετική γνώση!"
    else if (percent >= 80)
        msg := "👍 Πολύ καλά! Μπράβο!"
    else if (percent >= 60)
        msg := "💪 Καλό! Συνεχίστε την προσπάθεια!"
    else
        msg := "📚 Χρειάζεται περισσότερη εξάσκηση!"
    
    message := MyGui.Add("Text", "x20 y+10 w300 h40 Center", msg)
    message.SetFont("s11 Bold c34495E")
    
    ; Έλεγχος για νέο high score
    highScore := LoadHighScore()
    if (percent > highScore.percent) {
        newRecord := MyGui.Add("Text", "x20 y+5 w300 h25 Center", "🆕 ΝΕΟ ΡΕΚΟΡ!")
        newRecord.SetFont("s12 Bold c" Colors.Success)
    }
    
    ; Λάθος απαντήσεις
    if (wrongAnswers.Length > 0) {
        wrongTitle := MyGui.Add("Text", "x20 y+10 w300 h25 Center", "Λάθος Απαντήσεις")
        wrongTitle.SetFont("s11 Bold c" Colors.Danger)
        
        wrongList := MyGui.Add("Edit", "x30 y+5 w260 h150 ReadOnly Multi", "")
        wrongList.SetFont("s9")
        
        wrongText := ""
        for idx, w in wrongAnswers {
            wrongText .= "• " w.question "`n"
            wrongText .= "  Σωστά: " w.correct "`n"
            wrongText .= "  Απάντησες: " w.yourAnswer "`n`n"
        }
        wrongList.Value := wrongText
    }
    
    ; Κουμπιά
    replayBtn := MyGui.Add("Button", "x60 y+20 w100 h40 Default", "🔄 Επανάληψη")
    replayBtn.SetFont("s10 Bold")
    replayBtn.OnEvent("Click", (*) => ShowMainMenu())
    
    exitBtn := MyGui.Add("Button", "x170 yp w100 h40", "❌ Έξοδος")
    exitBtn.SetFont("s10 Bold")
    exitBtn.OnEvent("Click", CloseHandler)
    
    MyGui.OnEvent("Close", CloseHandler)
    MyGui.OnEvent("Escape", CloseHandler)
    
    SaveHighScore(score, quizCountries.Length, percent)
    
    try {
        MyGui.Show("Center AutoSize")
    } catch as e {
        MsgBox "Σφάλμα εμφάνισης αποτελεσμάτων: " e.Message, "Geobase - Error", "Icon!"
    }
}

; ----------------------------
; High Score Management
; ----------------------------
SaveHighScore(score, total, percent) {
    try {
        prevBest := Float(IniRead("Geobase_Stats.ini", "Stats", "BestPercent", 0))
        
        if (percent > prevBest) {
            IniWrite(score, "Geobase_Stats.ini", "Stats", "BestScore")
            IniWrite(total, "Geobase_Stats.ini", "Stats", "BestTotal")
            IniWrite(percent, "Geobase_Stats.ini", "Stats", "BestPercent")
            IniWrite(A_Now, "Geobase_Stats.ini", "Stats", "BestDate")
        }
        
        totalPlayed := Integer(IniRead("Geobase_Stats.ini", "Stats", "TotalPlayed", 0))
        IniWrite(totalPlayed + 1, "Geobase_Stats.ini", "Stats", "TotalPlayed")
        
        totalCorrect := Integer(IniRead("Geobase_Stats.ini", "Stats", "TotalCorrect", 0))
        IniWrite(totalCorrect + score, "Geobase_Stats.ini", "Stats", "TotalCorrect")
        
        totalQuestions := Integer(IniRead("Geobase_Stats.ini", "Stats", "TotalQuestions", 0))
        IniWrite(totalQuestions + total, "Geobase_Stats.ini", "Stats", "TotalQuestions")
    } catch as e {
        ; Silent error - statistics not critical
    }
}

LoadHighScore() {
    try {
        bestScore := Integer(IniRead("Geobase_Stats.ini", "Stats", "BestScore", 0))
        bestTotal := Integer(IniRead("Geobase_Stats.ini", "Stats", "BestTotal", 10))
        bestPercent := Float(IniRead("Geobase_Stats.ini", "Stats", "BestPercent", 0))
        return {score: bestScore, total: bestTotal, percent: bestPercent}
    } catch as e {
        ; Return defaults if error
        return {score: 0, total: 10, percent: 0}
    }
}

; ----------------------------
; ΕΚΚΙΝΗΣΗ
; ----------------------------
ShowMainMenu()