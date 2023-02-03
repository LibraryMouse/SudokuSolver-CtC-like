module Tmp

export Cell, Sudoku,
row, column, box, everyunit, peers,
iscellbroken, iscellsolved, issudokubroken, issudokusolved, freedomdegree,
alloweddigits, placesfordigit, isdigitinset,
setcellvalue, setemptygrid,
printcell, printcellstate, printgrid, printgridstate,
getmesomegas, gettatooinesunset,
gridifystring, stringifygrid, 
savealltostring, savealltovector, reloadfromstring, reloadfromvector,
exhaustnakedsingles, seekhiddensingle, seeknakedpair,
setanchor, bifurcate, pullanchor,
solvenicely, solvedirty, solvefilthy,
logsolving, presentaftersolving


#= STRUCTS =#


struct Cell
    candidates::Vector{Bool}
    Cell() = new(ones(Bool, 9))
end


struct Sudoku
    grid::Matrix{Cell}
    Sudoku() = new(Matrix{Cell}(undef, 9, 9))
end


#= SPATIAL CONCEPTS =#


function row(sudoku, r)
    return [sudoku.grid[r, 1:9]]
end


function column(sudoku, c)
    return [sudoku.grid[1:9, c]]
end


function box(sudoku, b)
    b -= 1
    x = div(b,3)+1
    y = b%3+1
    r1 = (x*3)-2
    r2 = x*3
    c1 = (y*3)-2
    c2 = y*3
    return [sudoku.grid[r1:r2, c1:c2]]
end


function everyunit(sudoku)
    everyunit = []
    for i=1:9
        append!(everyunit, row(sudoku, i))
    end
    for i=1:9
        append!(everyunit, column(sudoku, i))
    end
    for i=1:9
        append!(everyunit, box(sudoku, i))
    end
    return everyunit
end


function peers(sudoku, cell)
    peers = []
    cr = findfirst(isequal(cell), sudoku.grid)
    c = cr[1]
    r = cr[2]
    for i=1:9
        if i!=c
            push!(peers, sudoku.grid[i, r])
        end
    end
    for i=1:9
        if i!=r
            push!(peers, sudoku.grid[c, i])
        end
    end
    boxc1 = div((c-1),3)*3+1
    boxc2 = boxc1+2
    boxr1 = div((r-1),3)*3+1
    boxr2 = boxr1+2
    for i=boxc1:boxc2, j=boxr1:boxr2
        if i!=c && j!=r
            push!(peers, sudoku.grid[i, j])
        end
    end
    return peers
end


#= BASIC DEFINITIONS =#


function iscellbroken(cell)
    if count(cell.candidates) == 0
        return true
    else
        return false
    end
end


function iscellsolved(sudoku, cell)
    if count(cell.candidates) != 1
        return false
    else
        digit = findfirst(isequal(true), cell.candidates)
        for peer in peers(sudoku, cell)
            if peer.candidates[digit] == true
                return false
            end
        end
    end
    return true
end


function freedomdegree(sudoku)
    degree = 0
    for cell in sudoku.grid
        degree += count(cell.candidates)
    end
    # if degree < 81
    #     sudokubroken = true
    # end
    # if degree == 81
    # end
    #     sudokusolved = issudokusolved(sudoku)
    # end
    return degree
end


function issudokubroken(sudoku)
    for cell in sudoku.grid
        if count(cell.candidates) == 0
            return true
        end
    end
    for unit in everyunit(sudoku)
        for digit=1:9
            allowedplaces = 9
            for cell in unit[1:9]
                if cell.candidates[digit] == false
                    allowedplaces -= 1
                end
            end
            if allowedplaces == 0
                return true
            end
        end
    end
    return false
end


function issudokusolved(sudoku)
    for cell in sudoku.grid
        if count(cell.candidates) != 1
            return false
        end
    end
    for unit in everyunit(sudoku)
        for digit=1:9
            allowedplaces = 0
            for cell in unit[1:9]
                if cell.candidates[digit] == true
                    allowedplaces += 1
                end
            end
            if allowedplaces != 1
                return false
            end
        end
    end
    return true
end


function alloweddigits(cell)
    alloweddigits = []
    for digit=1:9
        if cell.candidates[digit] == true
            append!(alloweddigits, digit)
        end
    end
    return alloweddigits
end


function placesfordigit(unit, digit)
    allowedplaces = []
    for place=1:9
        if unit[place].candidates[digit] == true
            append!(allowedplaces, place)
        end
    end
    return allowedplaces
end


function isdigitinset(set, digit)
    for cell in set
        if cell.candidates[digit] == true
            return true
        end
    end
    return false
end


function setcellvalue(cell, value)
    fill!(cell.candidates, false)
    cell.candidates[value] = true
    return cell
end


function setemptygrid(sudoku)
    for column in 1:9, row in 1:9
        sudoku.grid[column, row] = Cell()
    end
    return sudoku
end


function unsolvedonly(sudoku)
    unsolved = []
    for cell in sudoku.grid
        if count(cell.candidates) > 1
            push!(unsolved, cell)
        end
    end
    return unsolved
end


function presentaftersolving(sudoku, sudokuname)
    if issudokusolved(sudoku) == true
        println("Sudoku ", sudokuname, " jest rozwiązane!")
        printgrid(sudoku)
    elseif issudokubroken == true
        println("Sudoku ", sudokuname, " nie jest rozwiązane... i niestety się zepsuło... ale dzięki temu wygląda w środku ciekawie!")
        printgrid(sudoku)
        printgridstate(sudoku)
    else
        println("Sudoku ", sudokuname, " nie jest rozwiązane... jeszcze. SudokuSolver nadal jest rozwijany!")
        printgrid(sudoku)
        printgridstate(sudoku)
    end
end



#= PRINTING =#


function printcell(cell)
    digit = "."
    if iscellbroken(cell) == true
        digit = "!"
    elseif count(cell.candidates) == 1
        digit = findfirst(isequal(true), cell.candidates)
    end
    return digit
end


function printcellstate(cell)
    state = "123456789"
    for digit=1:9
        if cell.candidates[digit] == false
            state = replace(state, state[digit] => ".")
        end
    end
    return state
end


function printgridrow(Sudoku, row)
    println("|",
            printcell(Sudoku.grid[row,1]),
            printcell(Sudoku.grid[row,2]),
            printcell(Sudoku.grid[row,3]),
            "|",
            printcell(Sudoku.grid[row,4]),
            printcell(Sudoku.grid[row,5]),
            printcell(Sudoku.grid[row,6]),
            "|",
            printcell(Sudoku.grid[row,7]),
            printcell(Sudoku.grid[row,8]),
            printcell(Sudoku.grid[row,9]),
            "|")
end


function printgrid(Sudoku)
    println("+-----------+")
    printgridrow(Sudoku, 1)
    printgridrow(Sudoku, 2)
    printgridrow(Sudoku, 3)
    println("|---+---+---|")
    printgridrow(Sudoku, 4)
    printgridrow(Sudoku, 5)
    printgridrow(Sudoku, 6)
    println("|---+---+---|")
    printgridrow(Sudoku, 7)
    printgridrow(Sudoku, 8)
    printgridrow(Sudoku, 9)
    println("+-----------+")
end


function printgridrowstate(Sudoku, row)
    println("|  ",
            printcellstate(Sudoku.grid[row,1])[1:3], "  ",
            printcellstate(Sudoku.grid[row,2])[1:3], "  ",
            printcellstate(Sudoku.grid[row,3])[1:3], "  ",
            "|  ",
            printcellstate(Sudoku.grid[row,4])[1:3], "  ",
            printcellstate(Sudoku.grid[row,5])[1:3], "  ",
            printcellstate(Sudoku.grid[row,6])[1:3], "  ",
            "|  ",
            printcellstate(Sudoku.grid[row,7])[1:3], "  ",
            printcellstate(Sudoku.grid[row,8])[1:3], "  ",
            printcellstate(Sudoku.grid[row,9])[1:3], "  ",
            "|")
    println("|  ",
            printcellstate(Sudoku.grid[row,1])[4:6], "  ",
            printcellstate(Sudoku.grid[row,2])[4:6], "  ",
            printcellstate(Sudoku.grid[row,3])[4:6], "  ",
            "|  ",
            printcellstate(Sudoku.grid[row,4])[4:6], "  ",
            printcellstate(Sudoku.grid[row,5])[4:6], "  ",
            printcellstate(Sudoku.grid[row,6])[4:6], "  ",
            "|  ",
            printcellstate(Sudoku.grid[row,7])[4:6], "  ",
            printcellstate(Sudoku.grid[row,8])[4:6], "  ",
            printcellstate(Sudoku.grid[row,9])[4:6], "  ",
            "|")
    println("|  ",
            printcellstate(Sudoku.grid[row,1])[7:9], "  ",
            printcellstate(Sudoku.grid[row,2])[7:9], "  ",
            printcellstate(Sudoku.grid[row,3])[7:9], "  ",
            "|  ",
            printcellstate(Sudoku.grid[row,4])[7:9], "  ",
            printcellstate(Sudoku.grid[row,5])[7:9], "  ",
            printcellstate(Sudoku.grid[row,6])[7:9], "  ",
            "|  ",
            printcellstate(Sudoku.grid[row,7])[7:9], "  ",
            printcellstate(Sudoku.grid[row,8])[7:9], "  ",
            printcellstate(Sudoku.grid[row,9])[7:9], "  ",
            "|")
end


function printgridstate(Sudoku)
    println("+", "-"^17, "+", "-"^17, "+", "-"^17, "+")
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 1)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 2)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 3)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    println("+", "-"^17, "+", "-"^17, "+", "-"^17, "+")
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 4)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 5)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 6)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    println("+", "-"^17, "+", "-"^17, "+", "-"^17, "+")
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 7)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 8)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    printgridrowstate(Sudoku, 9)
    println("|", " "^17, "|", " "^17, "|", " "^17, "|")
    println("+", "-"^17, "+", "-"^17, "+", "-"^17, "+")
end


#= SUDOKU FOR TESTS =#


function getmesomegas(gasname)
    gasdict = Dict([
                   ("gas21", "
                   000 000 000
                   012 340 560
                   070 800 009

                   001 020 300
                   004 050 600
                   007 080 900

                   100 002 030
                   045 067 890
                   000 000 000
                   "),
                   ("gas40", "
                   +-----------+
                   |...|123|...|
                   |..2|...|4..|
                   |.1.|4..|.5.|
                   |---+---+---|
                   |2.5|.7.|..6|
                   |3..|842|..7|
                   |4..|.6.|9.8|
                   |---+---+---|
                   |.5.|..6|.9.|
                   |..6|...|8..|
                   |...|789|...|
                   +-----------+
                   "),
                   ("gas90", "
                   1?2 ?3? 4?5
                   ??? 6?? ???
                   7?? ??8 ??6

                   ??9 ??? ?2?
                   6?? ??? ??7
                   ?7? ??? 3??

                   5?? 7?? ??8
                   ??? ??9 ???
                   4?3 ?2? 1?9
                   "),
                   ("gas571", "
                   ... ..2 345
                   ... .4. ..7
                   ..6 ..7 ..8

                   ..5 ... ..6
                   .2. ... .3.
                   3.. ... 1..

                   7.. 9.. 2..
                   8.. .3. ...
                   913 8.. ...
                   "),
                   ("gas572", "
                   2..|.1.|..4
                   ...|9.2|...
                   ..8|.7.|3..
                   ---+---+---
                   .7.|8.6|.4.
                   6.9|...|8.5
                   .5.|7.9|.6.
                   ---+---+---
                   ..4|.6.|7..
                   ...|3.8|...
                   3..|.2.|..1
                   "),
                   ("gas573", "
                   .12 ... ...
                   .64 ... .83
                   ... ..5 .64
                   
                   ..3 .8. ...
                   ... 2.9 ...
                   ... .1. 7..

                   82. 1.. ...
                   74. ... 92.
                   ... ... 65.
                   ")
                  ])
    excuse = "Sorry, I do not have Genuinely Approachable Sudoku you are looking for."
    return get(gasdict, gasname, excuse)
end


function gettatooinesunset()
    tatooinesunset = "
    ... ... ...
    ..9 8.. ..7
    .8. .6. .5.

    .5. .4. .3.
    ..7 9.. ..2
    ... ... ...

    ..2 7.. ..9
    .4. .5. .6.
    3.. ..6 2..
    "
    return tatooinesunset
end


#= STRING TO GRID, GRID TO STRING =#


function simplifygridstring(gridstring::AbstractString)
    cellcount = 0
    digits = "123456789"
    emptycells = ".?0"
    for char in gridstring
        if occursin(char, digits)
            cellcount += 1
        elseif occursin(char, emptycells)
            gridstring = replace(gridstring, char => "?")
            cellcount += 1
        else 
            gridstring = replace(gridstring, char => "")
        end
    end
    if cellcount < 81
        return "Sorry, not enough cells for a Sudoku."
    elseif cellcount > 81
        return "Sorry, too much cells for a Sudoku."
    else
        return gridstring
    end
end


function gridifystring(gridstring::AbstractString)
    somesudoku = setemptygrid(Sudoku())
    gridstring = simplifygridstring(gridstring)
    for r in 1:9, c in 1:9
        currentcell = somesudoku.grid[r, c]
        currentdigit = gridstring[(r-1)*9+c]
        if occursin(currentdigit, "123456789")
            value = parse(Int64, currentdigit)
            currentcell = setcellvalue(currentcell, value)
        end
    end
    return somesudoku
end


function stringifygrid(sudoku)
    gridstring = "?"^81
    for r=1:9, c=1:9
        currentcell = sudoku.grid[r, c]
        currentdigit = gridstring[(r-1)*9+c]
        if count(currentcell.candidates) == 1
            value = findfirst(isequal(true), currentcell.candidates)
            replace(gridstring, currentdigit => value)
        end
    end
    return gridstring
end


function savealltostring(sudoku)
    statestring = "1"^(9*9*9)
    for r=1:9, c=1:9, v=1:9
        currentvalue = sudoku.grid[r, c].candidates[v]
        x = (r-1)*81 + (c-1)*9 + v
        currentdigit = statestring[x]
        if currentvalue == false
            replace(statestring, currentdigit => "0")
        end
    end
    return statestring
end


function reloadfromstring(sudoku, statestring)
    for r=1:9, c=1:9, v=1:9
        x = (r-1)*81 + (c-1)*9 + v
        sudoku.grid[r, c].candidates[v] = parse(Bool, statestring[x])
    end
    return sudoku
end


function savealltovector(sudoku)
    statevector = []::Vector
    for r=1:9, c=1:9
        currentcell = sudoku.grid[r, c]
        append!(statevector, currentcell.candidates)
    end
    return statevector
end


function reloadfromvector(sudoku, statevector)
    for r=1:9, c=1:9, v=1:9
        x = (r-1)*81 + (c-1)*9 + v
        sudoku.grid[r, c].candidates[v] = statevector[x]
    end
    return sudoku
end


#= SOLVING TECHNIQUES =#


function isitnakedsingle(cell)
    if length(alloweddigits(cell)) == 1
        return true
    else
        return false
    end
end


function isnewnakedsingle(sudoku, cell)
    if iscellsolved(sudoku, cell) == false
        return true
    else
        return false
    end
end


function updatenakedsingle(sudoku, cell)
    digit = findfirst(isequal(true), cell.candidates)
    for peer in peers(sudoku, cell)
        peer.candidates[digit] = false
    end
    print("NakedSingle; ")
end


function exhaustnakedsingles(sudoku)
    while true
        before = freedomdegree(sudoku)
        for cell in sudoku.grid
            if isitnakedsingle(cell) && isnewnakedsingle(sudoku, cell)
                updatenakedsingle(sudoku, cell)
            end
        end
        after = freedomdegree(sudoku)
        if before == after
            break
        end
    end
end


function isithiddensingle(unit, digit)
    if length(placesfordigit(unit, digit)) == 1
        return true
    else
        return false
    end
end


function isnewhiddensingle(sudoku, cell)
    if iscellsolved(sudoku, cell) == true
        return false
    else
        return true
    end
end


function updatehiddensingle(sudoku, cell, digit)
    cell = setcellvalue(cell, digit)
    for peer in peers(sudoku, cell)
        peer.candidates[digit] = false
    end
    print("HiddenSingle; ")
end 


function seekhiddensingle(sudoku)
    for digit=1:9
        for unit in everyunit(sudoku)
            if isithiddensingle(unit, digit) == true
                cell = unit[placesfordigit(unit, digit)[1]]
                if isnewhiddensingle(sudoku, cell) == true
                    updatehiddensingle(sudoku, cell, digit)
                end
            end
        end
    end
end


function isitnakedpair(cell1, cell2)
    if cell1 != cell2 && count(cell1.candidates) == 2 &&
        alloweddigits(cell1) == alloweddigits(cell2)
        return true
    else
        return false
    end
end


function isnewnakedpair(unit, cell1, cell2)
    for digit in alloweddigits(cell1)
        if length(placesfordigit(unit, digit)) >= 2
            return false
        end
    end
    return true
end


function updatenakedpair(unit, cell1, cell2)
    digits = alloweddigits(cell1)
    for cell in unit
        if cell != cell1 && cell != cell2
            cell.candidates[digits[1]] = false
            cell.candidates[digits[2]] = false
        end
    end
    print("NakedPair; ")
end


function seeknakedpair(sudoku)
    for unit in everyunit(sudoku)
        for i=1:9, j=1:9
            if i != j && i < j
                if isitnakedpair(unit[i], unit[j]) == true &&
                    isnewnakedpair(unit, unit[i], unit[j]) == true
                    updatenakedpair(unit, unit[i], unit[j])
                end
            end
        end
    end
end


function isithiddenpair(unit, digit1, digit2)
    if digit1 != digit2 && 
        placesfordigit(unit, digit1) == placesfordigit(unit, digit2) &&
        length(placesfordigit(unit, digit1)) == 2
        return true
    else
        return false
    end
end


function findhiddenpair(Sudoku)
    for unit in everyunit(Sudoku)
        for digit1=1:9, digit2=1:9
            if digit1!=digit2
            end
        end
# if 1==1 # there is a digit with exactly two possible places
# if 1==1 # there is a second digit also with exactly two possible places
# if 1==1 # their places are the same places
# mark these two digits as a hidden pair
# delete every other candidate from their cells
    end
    return Sudoku
end


#= BIFURCATING =#


function setanchor(sudoku, allanchors)
    #savedstring = savealltostring(sudoku)
    savedvector = savealltovector(sudoku)
    anchorcell = rand(unsolvedonly(sudoku))
    rc = findfirst(isequal(anchorcell), sudoku.grid)
    r = rc[1]
    c = rc[2]
    value = rand(alloweddigits(sudoku.grid[r, c]))
    anchor = Dict([("r", r),
                   ("c", c),
                   ("v", value),
                   #("save", savedstring)
                   ("save", savedvector)
                  ])
    pushfirst!(allanchors, anchor)
end


function bifurcate(sudoku, allanchors, allanswers)
    exhaustnakedsingles(sudoku)
    setanchor(sudoku, allanchors)
    anchor = allanchors[1]
    setcellvalue(sudoku.grid[anchor["r"], anchor["c"]], anchor["v"])
    updatenakedsingle(sudoku, sudoku.grid[anchor["r"], anchor["c"]])
    println("Bifurcate")
    logsolving(sudoku, allanchors, allanswers)
end


function pullanchor(sudoku, allanchors)
    anchor = allanchors[1]
    #sudoku = reloadfromstring(sudoku, anchor["save"])
    sudoku = reloadfromvector(sudoku, anchor["save"])
    anchorcell = sudoku.grid[anchor["r"], anchor["c"]]
    anchorcell.candidates[anchor["v"]] = false
    popfirst!(allanchors)
end


# SOLVING FUNCTIONS #


function solvenicely(sudoku)
    while true
        before = freedomdegree(sudoku)
        exhaustnakedsingles(sudoku)
        still = freedomdegree(sudoku)
        i = 0
        while i == 0 && still == before
            seekhiddensingle(sudoku)
            still = freedomdegree(sudoku)
            seeknakedpair(sudoku)
            still = freedomdegree(sudoku)
            # tryhiddenpair
            # still = freedomdegree(sudoku)
            # tryxwing
            i +=1
        end
        after = freedomdegree(sudoku)
        if before == after
            break
        end
    end
end


function solvedirty(sudoku)
    allanchors = []
    allanswers = []
    # i = 0
    while issudokusolved(sudoku) == false # && i != 7
        solvenicely(sudoku)
         while issudokubroken == true
            pullanchor(sudoku, allanchors)
            println("Broken. Pull anchor")
            logsolving(sudoku, allanchors, allanswers)
        end
        bifurcate(sudoku, allanchors, allanswers)
        while issudokubroken == true
            pullanchor(sudoku, allanchors)
            println("Broken. Pull anchor")
            logsolving(sudoku, allanchors, allanswers)
        end
        # i +=1
    end
end


function solvefilthy(sudoku)
    allanchors = []
    allanswers = []
    while true
        if issudokusolved(sudoku) == true # && length(allanchors) == 0
            break
        end
        bifurcate(sudoku, allanchors, allanswers)
        if issudokubroken(sudoku) == true
            while issudokubroken(sudoku) == true && length(allanchors) > 0
                println("Pull anchor bc broken")
                logsolving(sudoku, allanchors, allanswers)
                pullanchor(sudoku, allanchors)
                println("Anchor pulled")
                logsolving(sudoku, allanchors, allanswers)
            end
        end
        if issudokusolved(sudoku) == true
            println("One answer found!")
            pullanchor(sudoku, allanchors)
            push!(allanswers, stringifygrid(sudoku))
            pullanchor(sudoku, allanchors)
            println("Pull anchor bc solved")
            logsolving(sudoku, allanchors, allanswers)
        end
   end
   return allanswers
end


function logsolving(sudoku, allanchors, allanswers)
    println("freedomdegree: ", freedomdegree(sudoku), "; is broken? ", issudokubroken(sudoku), "; is solved? ", issudokusolved(sudoku), "; anchors: ", length(allanchors), "; answers: ", length(allanswers))
end


end #end of module
