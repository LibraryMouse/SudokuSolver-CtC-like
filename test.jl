include SudokuSolver.jl
using Main.Tmp

println("Ładuję sudoku GAS21")
GAS21 = gridifystring(getmesomegas("gas21"))
printgrid(GAS21)
println("Rozwiązuję GAS21 przez solvenicely()")
solvenicely(GAS21)
presentaftersolving(GAS21, "GAS21")

println()
println()

println("Ładuję sudoku GAS573")
GAS573 = gridifystring(getmesomegas("gas573"))
printgrid(GAS573)
println("Rozwiązuję GAS573 przez solvenicely()")
solvenicely(GAS573)
presentaftersolving(GAS573, "GAS573")

println()
println()


println("A teraz spróbojmy Tatooine Sunset, powszechnie uważany za BARDZO trudnesudoku do rozwiązania tradycyjnymi metodami... (Jeden z mistrzów Brytanii w sudoku poddał się i użył w nim bifurkacji)")
tat = gridifystring(gettatooinesunset())
printgrid(tat)
println("Rozwiązuję Tatooine Sunset przez solvenicely()")
solvenicely(tat)
presentaftersolving(tat, "Tatooine Sunset")

println()
println()


println("Załaduję sudoku GAS21 jeszcze raz...")
GAS21 = gridifystring(getmesomegas("gas21"))
printgrid(GAS21)
println("Rozwiązuję GAS21 przez solvefilthy()")

try
    solvefilthy(GAS21)
catch err
    if isa(err, ArgumentError)
        println("Ehm, ups? Zobaczmy, co się zdążyło rozwiązać...")
    elseif isa(err, MethodError)
        println("Ehm, ups? Zobaczmy, co się zdążyło rozwiązać...")
    end
end

presentaftersolving(GAS21, "GAS21")


println("A teraz spróbujmy na Słońcach Tatooine metody mieszanej...")
tat = gridifystring(gettatooinesunset())
printgrid(tat)
println("Rozwiązuję Tatooine Sunset przez solvedirty()")

try
    solvedirty(tat)
catch err
    if isa(err, ArgumentError)
        println("Ehm, ups? Zobaczmy, co się zdążyło rozwiązać...")
    elseif isa(err, MethodError)
        println("Ehm, ups? Zobaczmy, co się zdążyło rozwiązać...")
    end
end

presentaftersolving(tat, "Tatooine Sunset")

println()
println()
prinln("Serdecznie zachęcam do wypróbowania modułu na własnych sudoku!
       Funkcja gridifystring(string) przyjmuje znaki ".", "?" i "0" jako puste pola, cyfry jako cyfry, a wszystkie inne ignoruje, dzięki czemu przyjmuje czytelne dla człowieka ciągi znaków z ramkami i nowymi liniami jako prawidłowy input.")
