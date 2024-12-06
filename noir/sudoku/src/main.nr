fn checkNumbers<let N: u32>(solution: [[u32; N]; N]) -> bool {
    let mut inh = true;

    for i in 0..N {
        for j in 0..N {
            // Check if the number is between 1 and N
            let flag = (solution[i][j] > 0 & solution[i][j] <= N);
            // inh is true only if all numbers satisfy the condition
            inh = inh & flag;
        }
    }
    
    inh
}



// Check that numbers appear exactly once in an array
fn checkRepetition<let N: u32>(arr: [u32; N]) -> bool {
    
    let mut inh = true;
    // Count occurrences
    let mut occ = [0; N];
    
    for i in 0..N {
        occ[arr[i] - 1] = occ[arr[i] - 1] + 1;
    }

    // Check that each number appears exactly once
    for i in 0..N {
        let flag = occ[i] == 1;
        inh = inh & flag;
    }
    
    inh
}

// Check that all rows are valid
fn checkRows<let N: u32>(solution: [[u32; N]; N]) -> bool {
    
    let mut inh = true;

    for i in 0..N {
        let mut arr = [0; N];
        for j in 0..N {
            // Each row is passed to the checkRepetition function
            arr[j] = solution[i][j];
        }
        // inh is true only if all rows satisfy the condition
        inh = inh & checkRepetition(arr);
    }
    inh
}

// Check that all columns are valid
fn checkColumns<let N: u32>(solution: [[u32; N]; N]) -> bool {
    
    let mut inh = true;

    for i in 0..N {
        let mut arr = [0; N];
        for j in 0..N {
            // Each column is passed to the checkRepetition function
            arr[j] = solution[j][i];
        }
        // inh is true only if all columns satisfy the condition
        inh = inh & checkRepetition(arr);
    }
    
    inh
}

// Check that all sub-grids are valid
fn checkSquare<let N: u32>(squareDim: u32, solution: [[u32; N]; N]) -> bool {
    
    let mut inh = true;

    for i in 0..squareDim {
        for j in 0..squareDim {
            let x = i * squareDim;
            let y = j * squareDim;
            let mut square = [0; N];
            for k in 0..squareDim {
                for h in 0..squareDim {
                    // Each element of the sub-grid is passed to the checkRepetition function
                    square[k * squareDim + h] = solution[x + k][y + h];
                }
            }
            // inh is true only if all sub-grids satisfy the condition
            inh = inh & checkRepetition(square);
        }
    }
    
    inh
}

// Check that the solution matches the problem
fn checkSame<let N: u32>(problem: [[u32; N]; N], solution: [[u32; N]; N]) -> bool {
    
    let mut inh = true;
    
    for i in 0..N {
        for j in 0..N {
            // If the number exists in "problema", check its equality with "soluzione"
            let mut flag = problem[i][j] == 0;

            if !flag {
                flag = solution[i][j] == problem[i][j];
            } 
            // inh is true only if all numbers already in "problema" match those in "soluzione"
            inh = inh & flag;
        }
    }
    inh
}


fn main(problem: pub [[u32; 9]; 9], solution: pub [[u32; 9]; 9]) {
    let squareDim = 3;

    assert(checkNumbers(solution));
    assert(checkRows(solution));
    assert(checkColumns(solution));
    assert(checkSquare(squareDim, solution));
    assert(checkSame(problem, solution));
}

