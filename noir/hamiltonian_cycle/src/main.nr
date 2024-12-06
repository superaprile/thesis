// Controllo la presenza di archi entranti per ogni nodo
fn checkGrafo<let N: u32>(graph: [[u32; N]; N]) -> bool {
    let mut inh = true;

    // Conteggio degli archi entranti in ogni nodo
    let mut occ = [0; N];
    for i in 0..N {
        for j in 0..N {

            if graph[i][j] == 1 {
                occ[j] = occ[j] + 1;    
                
            }   

        }
    }

    // Controllo che il numero di archi per nodo sia maggiore di 0
    for i in 0..N {
        let flag = occ[i] >= 1;
        inh = inh & flag;
    }

    inh
}

// Controllo che ogni arco della soluzione esista all' interno del grafo
fn checkArco<let N: u32>(graph: [[u32; N]; N], solution: [u32; N]) -> bool {
    let mut inh = true;

    let mut occ = [0; N-1];
    for i in 0..N-1 {
        occ[i] = graph[solution[i]][solution[i + 1]];
    }

    // Controllo che nella matrice che rappresenta il grafo gli archi della soluzione esistano
    for i in 0..N-1 {
        let flag = occ[i] == 1;
        inh = inh & flag;
    }

    inh
}

// Controllo che ogni nodo venga visitato solo una volta
fn checkSol<let N: u32>(solution: [u32; N]) -> bool {
    let mut inh = true;

    // Conteggio occorrenze di ogni nodo
    let mut occ = [0; N];
    for i in 0..N {
        occ[solution[i]] = occ[solution[i]] + 1;
    }

    // Controllo che tutte le occorrenze siano esattamente 1
    for i in 0..N {

        let flag= occ[i] == 1 ;
        inh = inh & flag;
    }

    inh
}

fn main(graph: pub [[u32; 10]; 10], solution: [u32; 10]) {
    
    assert(checkGrafo(graph));
    assert(checkArco(graph, solution));
    assert(checkSol(solution));
}

