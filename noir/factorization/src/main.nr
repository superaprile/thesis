fn main(x: Field, y: Field, z: pub Field) {
    assert(x * y == z);
}

#[test]
fn test_main() {
    main(1, 6, 6);

    // Uncomment to make test fail
    // main(1, 1);
}
