
fn main(a: u8, b: u8, c: u8, d: u8) -> pub [u8; 32] {

    let hash = std::hash::sha256_var([a, b, c, d], 4);
    hash
}

