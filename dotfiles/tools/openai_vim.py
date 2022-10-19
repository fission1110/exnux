#!/usr/bin/env python3
import os
import openai
import sys

# read text from stdin
text = sys.stdin.read()
text = 'Q: ' + text
text = text + "\nA:"

# read api key from file ~/.config/openai/api_key
with open(os.path.expanduser("~/.config/openai/api_key")) as f:
    openai.api_key = f.read().strip()


start_sequence = ""
restart_sequence = ""

response = openai.Completion.create(
  model="text-davinci-002",
  prompt="I am a highly intelligent question answering bot. If you ask me a question that is rooted in truth, I will give you the answer. If you ask me a question that is nonsense, trickery, or has no clear answer, I will respond with \"Unknown\".\n\n" + text,
  temperature=0,
  max_tokens=100,
  top_p=1,
  frequency_penalty=0,
  presence_penalty=0,
  stop=["\n"]
)

out = response.choices[0].text
print(response)

# print to stdout
print(out)
