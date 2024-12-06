NUM_PUBLIC_INPUTS=1  # Number of public inputs (adjust as needed)
PUBLIC_INPUT_BYTES=$((32 * NUM_PUBLIC_INPUTS))  # Calculate the number of bytes for public inputs

# Extract the first PUBLIC_INPUT_BYTES bytes (public inputs)
HEX_PUBLIC_INPUTS=$(head -c $PUBLIC_INPUT_BYTES ./proof | od -An -v -t x1 | tr -d ' \n')

# Extract the rest of the file (proof)
HEX_PROOF=$(tail -c +$((PUBLIC_INPUT_BYTES + 1)) ./proof | od -An -v -t x1 | tr -d ' \n')

# Display public inputs and proof
echo "Public Inputs:"
echo "$HEX_PUBLIC_INPUTS"

echo "Proof:"
echo "0x$HEX_PROOF"

# Split the public inputs into bytes32 format for Remix
split_public_inputs() {
  # Split the HEX_PUBLIC_INPUTS into chunks of 64 characters (32 bytes)
  echo $HEX_PUBLIC_INPUTS | sed 's/\([0-9a-f]\{64\}\)/0x\1/g' | tr ' ' '\n' | while read input; do
    # Output in the format Remix expects: ["0x...","0x..."]
    echo "$input"
  done
}

echo "Formatted public inputs for Remix (as bytes32[]):"
echo "["
split_public_inputs
echo "]"
