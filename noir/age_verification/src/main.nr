fn main(age: u8, limit: pub u8) {
    assert(age >= limit);
}

#[test]
fn test_main() {
    main(21, 18);
}
