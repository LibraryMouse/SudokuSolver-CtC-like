module Tmp

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


function iscellsolved(Cell)
    if count(Cell.candidates) == 1
        return true
    else
        return false
    end
end


function setcellvalue(Cell, value)
    fill!(Cell.candidates, false)
    Cell.candidates[value] = true
    return Cell
end


function setemptygrid(Sudoku)
    for column in 1:9, row in 1:9
        Sudoku.grid[column, row] = Cell()
    end
    return Sudoku
end


function row(Sudoku)
end

function row(Sudoku.grid.Cell)
    return
end

function column(Sudoku)
end

function column(Cell)
end

function box(Sudoku)
end

function box(Cell)
end



# PRINTING FUNCTIONS #


function printcell(Cell)
    digitofcell = "."
    if iscellbroken(Cell) == true
        digitofcell = "!"
    elseif iscellsolved(Cell) == true
        digitofcell = findfirst(isequal(true), Cell.candidates)
    end
    return digitofcell
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
    007 080 600

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
            currentcell = setcellvalue(currentcell, value)
        end
    end
    return somesudoku
end


function stringifygrid(Sudoku)
    gridstring = "?"^81
    for r in 1:9, c in 1:9
        currentcell = Sudoku.grid[r, c]
        currentdigit = gridstring[(r-1)*9+c]
        if iscellsolved(currentcell)
            value = findfirst(isequal(true), currentcell.candidates)
            replace(grindstring, currentdigit => value)
        end
    return gridstring
end


# FUNCTIONS OF ELEGANT SOLVING



end #end of module
