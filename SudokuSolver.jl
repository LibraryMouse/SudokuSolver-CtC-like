module Tmp

export Cell, Sudoku,
row, column, box, everyunit, peers,
iscellbroken, placesfordigit, alloweddigits, isdigitinset, iscellsolved, setsolvedvalue, setemptygrid,
printcell, printcellstate, printgrid, printgridstate, getmesomegas, gridifystring, stringifygrid, makecontrollist,
isitnakedsingle, findnakedsingle, ishiddensingle, findhiddensingle, findnakedpair, findhiddenpair, exhaustmethod, solvelegant

# STRUCTS #


struct Cell
    candidates::Vector{Bool}
    Cell() = new(ones(Bool, 9))
end


struct Sudoku
    grid::Matrix{Cell}
    Sudoku() = new(Matrix{Cell}(undef, 9, 9))
end


# BASIC DEFINITIONS #


function iscellbroken(Cell)
    if any(Cell.candidates) == true
        return false
    else
        return true
    end
end


function placesfordigit(unit, digit)
    places = []
    for i=1:9
        if unit[i].candidates[digit] == true
            append!(places, i)
        end
    end
    return places
end


function alloweddigits(cell)
    alloweddigits = []
    for i=1:9
        if cell.candidates[i] == true
            append!(alloweddigits, i)
        end
    end
    return alloweddigits
end


function row(Sudoku, r)
    return [Sudoku.grid[r, 1:9]]
end


function column(Sudoku, c)
    return [Sudoku.grid[1:9, c]]
end


function box(Sudoku, b)
    b -= 1
    x = div(b,3)+1
    y = b%3+1
    a = (x*3)-2
    b = x*3
    c = (y*3)-2
    d = y*3
    return [Sudoku.grid[a:b, c:d]]
end


function everyunit(Sudoku)
    everyunit = []
    for i=1:9
        append!(everyunit, row(Sudoku, i))
    end
    for i=1:9
        append!(everyunit, column(Sudoku, i))
    end
    for i=1:9
        append!(everyunit, box(Sudoku, i))
    end
    return everyunit
end


function peers(Sudoku, Cell)
    peers = []
    cr = findfirst(isequal(Cell), Sudoku.grid)
    c = cr[1]
    r = cr[2]
    for i=1:9
        if i!=c
            push!(peers, Sudoku.grid[i, r])
        end
    end
    for i=1:9
        if i!=r
            push!(peers, Sudoku.grid[c, i])
        end
    end
    boxc1 = div((c-1),3)*3+1
    boxc2 = boxc1+2
    boxr1 = div((r-1),3)*3+1
    boxr2 = boxr1+2
    for i=boxc1:boxc2, j=boxr1:boxr2
        if i!=c && j!=r
            push!(peers, Sudoku.grid[i, j])
        end
    end
    return peers
end


function isdigitinset(set, digit)
    for cell in set
        if cell.candidates[digit] == true
            return true
        end
    end
    return false
end


function iscellsolved(sudoku, cell)
    if length(alloweddigits(cell)) != 1
        return false
    else
        digit = alloweddigits(cell)[1]
        if isdigitinset(peers(sudoku, cell), digit) == true
            return false
        else
            return true
        end
    end
end


function setsolvedvalue(cell, value)
    fill!(cell.candidates, false)
    cell.candidates[value] = true
    return cell
end


function setemptygrid(Sudoku)
    for column in 1:9, row in 1:9
        Sudoku.grid[column, row] = Cell()
    end
    return Sudoku
end


function freedomdegree(sudoku)
    freedomdegree = 0
    for cell in sudoku.grid
        freedomdegree += count(cell.candidates)
    end
    return freedomdegree
end


# PRINTING FUNCTIONS #


function printcell(cell)
    digit = "."
    if iscellbroken(cell) == true
        digit = "!"
    elseif count(cell.candidates) == 1
        digit = findfirst(isequal(true), cell.candidates)
    end
    return digit
end


function printcellstate(Cell)
    state = "123456789"
    for digit in 1:9
        if Cell.candidates[digit] == false
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


# SUDOKU FOR TESTS #


function getmesomegas(gasname)
    gas21 = "
    000 000 000
    012 340 560
    070 800 009

    001 020 300
    004 050 600
    007 080 900

    100 002 030
    045 067 890
    000 000 000
    "
    gas40 = "
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
    "
    gas90 = "
    1?2 ?3? 4?5
    ??? 6?? ???
    7?? ??8 ??6

    ??9 ??? ?2?
    6?? ??? ??7
    ?7? ??? 3??

    5?? 7?? ??8
    ??? ??9 ???
    4?3 ?2? 1?9
    "
    gaslist = ["gas21", "gas40", "gas90"]
    if gasname == "gas21"
        return gas21
    elseif gasname == "gas40"
        return gas40
    elseif gasname == "gas90"
        return gas90
    else
        return "I do not have Genuinely Approachable Sudoku you are asking for"
    end
end


# STRING TO GRID, GRID TO STRING #


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
    somesudoku = Sudoku()
    somesudoku = setemptygrid(somesudoku)
    gridstring = simplifygridstring(gridstring)
    for r in 1:9, c in 1:9
        currentcell = somesudoku.grid[r, c]
        currentdigit = gridstring[(r-1)*9+c]
        if occursin(currentdigit, "123456789")
            value = parse(Int64, currentdigit)
            currentcell = setsolvedvalue(currentcell, value)
        end
    end
    return somesudoku
end


function stringifygrid(Sudoku)
    gridstring = "?"^81
    for r=1:9, c=1:9
        currentcell = Sudoku.grid[r, c]
        currentdigit = gridstring[(r-1)*9+c]
        if count(currentcell.candidates) == 1
            value = findfirst(isequal(true), currentcell.candidates)
            replace(grindstring, currentdigit => value)
        end
    end
    return gridstring
end


function makecontrollist(Sudoku)
    controllist = []::Vector
    for r=1:9, c=1:9
        currentcell = Sudoku.grid[r, c]
        append!(controllist, currentcell.candidates)
    end
    return controllist
end


# FUNCTIONS OF ELEGANT SOLVING


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
    cell = setsolvedvalue(cell, digit)
    for peer in peers(sudoku, cell)
        peer.candidates[digit] = false
    end
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


function findhiddensingle(Sudoku)
    for digit in 1:9
        for unit in everyunit(Sudoku)
            places = placesfordigit(unit, digit)
            if length(places) == 1 && count(unit[places[1]].candidates) > 1
                hiddensingle = unit[places[1]]
                hiddensingle = setsolvedvalue(hiddensingle, digit)
                println("found hidden single")
                for peer in peers(Sudoku, hiddensingle)
                    peer.candidates[digit] = false
                end
            end
        end
    end
    return Sudoku
end


function findnakedpair(Sudoku)
    for unit in everyunit(Sudoku)
        for x=1:9,y=1:9 #for every possible pair of cells in unit
            if x!=y && isequal(unit[x], unit[y]) && count(unit[x].candidates) == 2
                pair = findall(isequal(true), unit[x].candidates)
                # delete both pair values from unit cells other than x and y
                for i=1:9
                    if i!=x && i!=y
                        for digit in pair
                            unit[i].candidates[digit] = false
                        end
                    end
                end
            end
        end

    end
    return Sudoku
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


function solveelegant(sudoku)
    while true
        before = freedomdegree(sudoku)
        exhaustnakedsingles(sudoku)
        still = freedomdegree(sudoku)
        i = 0
        while i == 0 && still == before
            seekhiddensingle(sudoku)
            still = freedomdegree(sudoku)
            # try nakedpair
            # still = freedomdegree(sudoku)
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


# BACKTRACK SOLVING #

function addanchor(Sudoku)
    # choose random unsolved cell
    # from allowed cell.candidates choose random candidate
    # save image of current grid
    # save anchor as {r=Int, c=Int, v=Int, image = controlsum}
    # return anchor
end


function backtrack(Sudoku)
    # propagate as long as possible
    # anchorsdict = {}
    # addanchor(Sudoku)
    # setsolvedvalue(Sudoku.grid[anchor[r], anchor[c]], anchor[v])
    # propagate as long as you can
    # if at any point you broke a cell
    #       reload grid from last anchor image, delete v from grid[r,c].cand
    # if you cannot propagate longer, add new anchor
end


end #end of module
