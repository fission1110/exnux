#!/usr/bin/env python3
import os
import openai
import sys

# read text from stdin
prompt = sys.stdin.read().strip()

# read api key from file ~/.config/openai/api_key
with open(os.path.expanduser("~/.config/openai/api_key")) as f:
    openai.api_key = f.read().strip()


start_sequence = ""
restart_sequence = ""

response = openai.Completion.create(
  model="text-davinci-002",
  prompt=prompt,
  temperature=0.9,
  max_tokens=100,
  top_p=1,
  frequency_penalty=0,
  presence_penalty=0
)

out = response.choices[0].text

# print to stdout
print(prompt + out, end="")
