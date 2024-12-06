NUM_PUBLIC_INPUTS=1  # Number of public inputs (adjust as needed)
PUBLIC_INPUT_BYTES=$((32 * NUM_PUBLIC_INPUTS))  # Calculate the number of bytes for public inputs

# Extract the first PUBLIC_INPUT_BYTES bytes (public inputs)
HEX_PUBLIC_INPUTS=$(head -c $PUBLIC_INPUT_BYTES ./proof | od -An -v -t x1 | tr -d ' \n')

# Extract the rest of the file (proof)
HEX_PROOF=$(tail -c +$((PUBLIC_INPUT_BYTES + 1)) ./proof | od -An -v -t x1 | tr -d ' \n')

# Display public inputs and proof
echo "Public Inputs:"
echo "[\"0x$HEX_PUBLIC_INPUTS\"]"

echo "Proof:"
echo "0x$HEX_PROOF"
