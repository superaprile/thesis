pragma circom 2.2.1;

include "node_modules/circomlib/circuits/comparators.circom";

// Controllo che tutti i numeri della soluzione possano appartenere al Sudoku
template checkNumbers(N) {
    signal input in [N*N];
    signal output out;

    component check[N*N];
    for (var i = 0; i < N*N; i++) {
        check[i] = Check(N);
        check[i].in <== in[i];
        // Constraints che impongono l’appartenenza all’intervallo
        check[i].out[0] === 1;
        check[i].out[1] === 1;
    }

    out <== 1;
}

// Controlla che tutti i numeri siano coerenti
template Check(N) {
    signal input in;
    signal output out[2];

    component results = between(N);
    results.in <== in;

    component equal1 = IsEqual();
    component equal2 = IsEqual();
    // Check che sia vero che "in" >= 1
    equal1.in[0] <== results.out[0];
    equal1.in[1] <== 1;

    // Check che sia vero che "in" <= N
    equal2.in[0] <== results.out[1];
    equal2.in[1] <== 1;

    out[0] <== equal1.out;
    out[1] <== equal2.out;
}

template between(N) {
    signal input in;
    signal output out[2];

    // Controllo che sia minore di N
    component upper = LessEqThan(32);
    upper.in[0] <== in;
    upper.in[1] <== N;
    out[0] <== upper.out;

    // Controllo che sia maggiore di 0
    component low = GreaterEqThan(32);
    low.in[0] <== in;
    low.in[1] <== 1;
    out[1] <== low.out;
}

// Controllo che tutti i numeri fra 1 e N siano presenti una e una sola volta
template repetitionCheck(N) {
    signal input in[N];
    signal output out;

    // Conteggio delle occorrenze di ogni numero
    var occurrences[N];
    for (var i = 0; i < N; i++) {
        occurrences[i] = 0;
    }

    // Controllo delle occorrenze dei numeri
    for (var i = 0; i < N; i++) {
        occurrences[in[i] - 1] += 1;
    }

    component equal0 [N];
    signal occ [N];
    for (var i = 0; i < N; i++) {
        equal0[i] = IsEqual();
        occ[i] <-- occurrences[i];
        equal0[i].in[0] <== occ[i];
        equal0[i].in[1] <== 1;
        equal0[i].out === 1;
    }

    out <== 1;
}

template checkRows(N) {
    signal input in [N][N];
    signal output out;

    component check[N];
    for (var i = 0; i < N; i++) {
        check[i] = repetitionCheck(N);
        for (var j = 0; j < N; j++) {
            // Ogni elemento della riga viene usato come input della funzione repetitionCheck
            check[i].in[j] <== in[i][j];
        }
        // Creazione del constraint per le righe
        check[i].out === 1;
    }

    out <== 1;
}

template checkColumns(N) {
    signal input in [N][N];
    signal output out;

    component check [N];
    for (var i = 0; i < N; i++) {
        check[i] = repetitionCheck(N);
        for (var j = 0; j < N; j++) {
            // Ogni elemento della colonna viene usato come input della funzione repetitionCheck
            check[i].in[j] <== in[j][i];
        }
        // Creazione del constraint per le colonne
        check[i].out === 1;
    }

    out <== 1;
}

template checkSquare(squareDim, N) {
    signal input in [N][N];
    signal output out;

    // Controllo le ripetizioni nei quadrati
    component check [N];
    for (var i = 0; i < squareDim; i++) {
        for (var j = 0; j < squareDim; j++) {
            // Salvo le posizioni di partenza dei quadrati
            var x = i * squareDim;
            var y = j * squareDim;

            // Salvo l’indice del quadrato del sudoku
            var squareI = i * squareDim + j;
            check[squareI] = repetitionCheck(N);
            for (var k = 0; k < squareDim; k++) {
                for (var h = 0; h < squareDim; h++) {
                    // Salvo l’indice della casella all’interno del quadrato
                    var index = k * squareDim + h;
                    // Passo alla funzione repetitionCheck il quadrato come se fosse una riga
                    check[squareI].in[index] <== in[x + k][y + h];
                }
            }
            // Creazione del constraint per i quadrati
            check[squareI].out === 1;
        }
    }

    out <== 1;
}

template Sudoku(squareDim, N) {
    signal input problem [N][N];
    signal input solution [N][N];
    signal output out;

    // Controlla i numeri inseriti nella matrice
    component CN = checkNumbers(N);
    for (var i = 0; i < N; i++) {
        for (var j = 0; j < N; j++) {
            CN.in[i * N + j] <== solution[i][j];
        }
    }
    CN.out === 1;

    // Controllo le ripetizioni sulle righe
    component rows = checkRows(N);
    rows.in <== solution;

    // Controllo le ripetizioni sulle colonne
    component columns = checkColumns(N);
    columns.in <== solution;

    // Controllo le ripetizioni sui quadrati
    component square = checkSquare(squareDim, N);
    square.in <== solution;

    // Verifico che la "soluzione" risolve esattamente il "problema"
    component equal [N][N];
    component equal0 [N][N];
    for (var i = 0; i < N; i++) {
        for (var j = 0; j < N; j++) {
            equal[i][j] = IsEqual();
            equal[i][j].in[0] <== solution[i][j];
            equal[i][j].in[1] <== problem[i][j];
            equal0[i][j] = IsZero();
            equal0[i][j].in <== problem[i][j];
            equal[i][j].out === 1 - equal0[i][j].out;
        }
    }
}

component main { public [problem] } = Sudoku(3, 9);
