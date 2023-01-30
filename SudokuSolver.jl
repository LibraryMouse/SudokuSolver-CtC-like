module Tmp


struct Cell
    candidates::Vector{Bool}
    Cell() = new(ones(Bool, 9))
end


struct Sudoku
    grid::Matrix{Cell}
    Sudoku() = new(Matrix{Cell}(undef, 9, 9))
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


function printcell(Cell)
    digitofcell = "?"
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
    gas2 = ""
    gas3 = ""
    gaslist = ["gas21", "gas2", "gas3"]
    if gasname == "gas21"
        return gas21
    elseif gasname == "gas2"
        return gas2
    elseif gasname == "gas3"
        return gas3
    else
        return "I do not have Genuinely Approachable Sudoku you are asking for"
    end
end


function setgrid(gridstring::AbstractString)
    somegrid = Sudoku()
    cellcount = 0
    digits = "123456789"
    emptycells = ".?0"
    noncells = "|- _+
    ="
    for char in gridstring
        if occursin(char, digits)
            cellcount += 1
        elseif occursin(char, emptycells)
            gridstring = replace(gridstring, char => "?")
            cellcount += 1
        elseif 
            grindstring = replace(grindstring, char => "")
        end
    end
    return somegrid
end


end #end of module
