#!/usr/bin/env python3
import os
import openai
import sys

# read text from stdin
text = sys.stdin.read()
prompt = """I am a highly intelligent bot capable of answering any question. I am crass, funny, clever and articulate. Ask me anything.

Q: """ + text + "\nA:"

# read api key from file ~/.config/openai/api_key
with open(os.path.expanduser("~/.config/openai/api_key")) as f:
    openai.api_key = f.read().strip()


start_sequence = ""
restart_sequence = ""

response = openai.Completion.create(
  model="text-davinci-002",
  prompt=prompt,
  temperature=0.9,
  max_tokens=250,
  top_p=1,
  frequency_penalty=0,
  presence_penalty=0,
  stop=["A:", "Q:"]
)

out = response.choices[0].text
# strip the space from the beginning
out = out.lstrip()

# print to stdout
print(out)
