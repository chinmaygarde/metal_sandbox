#!/usr/bin/env python3

import argparse
import os
import json
import sys

def find_files_by_extension(directory, extension):
  matching_files = []
  normalized_extension = f".{extension.lower()}"  # Ensure lowercase and add dot

  try:
    for item in os.listdir(directory):
      item_path = os.path.join(directory, item)
      # Check if it's a file and if the extension matches (case-insensitive)
      if os.path.isfile(item_path) and item.lower().endswith(normalized_extension):
        matching_files.append(item_path)
  except FileNotFoundError:
    print(f"Error: Directory not found - {directory}")
  except Exception as e:
    print(f"An error occurred: {e}")

  return matching_files

def is_json_valid(json_string: str) -> bool:
  decoder = json.JSONDecoder()
  try:
    decoder.decode(json_string)
  except json.JSONDecodeError as error:
    print(f"Could not decode JSON {error}", file=sys.stderr)
    return False
  return True

def concatenate_json_files(directory: str) -> str:
  concatenated_json: str = '['
  for file in find_files_by_extension(directory, 'json'):
    with open(file, 'r', encoding='utf-8') as file_contents:
      concatenated_json += file_contents.read()
  concatenated_json += '{"directory": "", "file": "", "command": ""}]'
  if not is_json_valid(concatenated_json):
    raise Exception("JSON is not valid")
  return concatenated_json

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('--fragments-dir', type=str, required=True)
  parser.add_argument('--out-path', type=str, required=True)

  args = parser.parse_args()

  if not os.path.exists(args.fragments_dir):
    raise Exception("Supplied fragments directory doesn't exist.")

  with open(os.path.join(args.out_path, "compile_commands.json"), "w", encoding='utf-8') as out_path:
    out_path.write(concatenate_json_files(args.fragments_dir))

if __name__ == '__main__':
  main()
