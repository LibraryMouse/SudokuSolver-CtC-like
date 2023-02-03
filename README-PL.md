# SudokuSolver-CtC-like
Sudoku Solver with terminology and methods compatible with Cracking the Cryptic community
_____

SudokuSolver w stylu Cracking The Cryptic.
Konsekwentnie stosuje terminologię używaną w społeczności pasjonatów sudoku (przykładowo, współrzędne komórki w sudoku to nie x,y ani i,j, ale zawsze rc (row, column)).

Implementuje algorytmy rozwiązywania sudoku solvenicely, solvedirty i solvefilthy.
Solvenicely korzysta wyłącznie z logicznych metod rozwiązywania sudoku, nazwanych zgodnie z przyjętą przez środowisko terminologią. Funkcję solvenicely można dowolnie rozbudowywać poprzez dodawanie kolejnych, bardziej zaawansowanych heurystyk.
Solvedirty używa naprzemiennie solvenicely i bifurkacji (backtrackingu).
Solvefilthy używa wyłącznie bifurkacji z ekstremalnie ograniczonym udziałem metod logicznych.

Komórki i wartości do bifurkacji są wybierane w sposób losowy (będzie to przydatne, jeśli na podstawie solvera zostanie w przyszłości zbudowany generator sudoku).

W module Tmp zawarto też 6 testowych, relatywnie łatwych sudoku, zaczerpniętych z serii Genuinely Approachable Sudoku na kanale Cracking The Cryptic, oraz sudoku Tatooine Sunset, uważane za wyjątkowo trudne. Są dostępne poprzez funkcje
getmesomesudoku(gasname) o możliwych argumentach "gas21", "gas40", "gas90", "gas571", "gas572" i "gas573"
oraz
gettatooinesunset().

Plik test.jl zawiera skrypt, który prezentuje obecny stan prac: wczytuje testowe sudoku, drukuje na ekranie w ASCII, podejmuje próbę rozwiązania za pomocą kolejno solvenicely, solvedirty i solvefilthy dla dwóch Genuinely Approachable Sudoku oraz dla Tattoine Sunset.

_____
Źródła użytych testowych sudoku i autorzy:

Playlista All The Gas https://www.youtube.com/playlist?list=PLK-l8O0YikOlSc9iDCJ41HHgqo0cfrDsS

GAS 21 – 129 Columns by Philip Newman https://www.youtube.com/watch?v=c35lhg7wyRc&list=PLK-l8O0YikOlSc9iDCJ41HHgqo0cfrDsS&index=5&t=419s

GAS 40 – NO by Philip Newman https://www.youtube.com/watch?v=2i4l7DtQFws&list=PLK-l8O0YikOlSc9iDCJ41HHgqo0cfrDsS&index=8

GAS 90 – Classic by Cloverhttps://tinyurl.com/zu6zwajs

GAS 571 – Hail Our New AI Overlords by Bill Murphy https://tinyurl.com/37ptjjtn  https://f-puzzles.com/?id=2hyrcfyd

GAS 572 – Do Sudoku Dream of Jellyfish? by Philip Newman  https://tinyurl.com/4k7cpdnh 
https://f-puzzles.com/?id=2e999nrr

GAS 573 – Classic Sudoku by clover! https://tinyurl.com/3sedndtp 
https://f-puzzles.com/?id=2hwq5ttc

Tatooine Sunset by Philip Newman https://www.youtube.com/watch?v=TQ0lso4fJzk
