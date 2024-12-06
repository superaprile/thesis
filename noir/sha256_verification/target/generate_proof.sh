NUM_PUBLIC_INPUTS=32  # Number of public inputs (adjust as needed)
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

split_public_inputs() {
  # Split the HEX_PUBLIC_INPUTS into chunks of 64 characters (32 bytes)
  echo $HEX_PUBLIC_INPUTS | sed -E 's/(.{64})/\1\n/g' | while read input; do
    # Skip empty lines and format each chunk as "0x..." with quotes
    if [ -n "$input" ]; then
      echo "\"0x$input\","
    fi
  done
}

# Main formatting for Remix
echo "Formatted public inputs for Remix (as bytes32[]):"
echo "["
split_public_inputs | sed '$s/,$//'  # Remove the trailing comma from the last element
echo "]"
