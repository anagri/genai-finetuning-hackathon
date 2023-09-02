mkdir -p use-cases-md  # Create the output directory if it doesn't exist

for notebook in use-cases/*.ipynb; do
  jupyter nbconvert \
    --to markdown \
    --ClearOutputPreprocessor.enabled=True \
    --output-dir=use-cases-md \
    "$notebook"
done
