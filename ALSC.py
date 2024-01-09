from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import warnings
warnings.filterwarnings('ignore')

tokenizer = AutoTokenizer.from_pretrained("kevinscaria/atsc_tk-instruct-base-def-pos-neg-neut-combined")
model = AutoModelForSeq2SeqLM.from_pretrained("kevinscaria/atsc_tk-instruct-base-def-pos-neg-neut-combined")

bos_instruct = """Definition: The output will be 'positive' if the aspect identified in the sentence contains a positive sentiment. If the sentiment of the identified aspect in the input is negative the answer will be 'negative'. 
    Otherwise, the output should be 'neutral'. For aspects which are classified as noaspectterm, the sentiment is none.
    Positive example 1-
    input: With the great variety on the menu , I eat here often and never get bored. The aspect is menu.
    output: positive
    Positive example 2- 
    input: Great food, good size menu, great service and an unpretensious setting. The aspect is food.
    output: positive
    Negative example 1-
    input: They did not have mayonnaise, forgot our toast, left out ingredients (ie cheese in an omelet), below hot temperatures and the bacon was so over cooked it crumbled on the plate when you touched it. The aspect is toast.
    output: negative
    Negative example 2-
    input: The seats are uncomfortable if you are sitting against the wall on wooden benches. The aspect is seats.
    output: negative
    Neutral example 1-
    input: I asked for seltzer with lime, no ice. The aspect is seltzer with lime.
    output: neutral
    Neutral example 2-
    input: They wouldnt even let me finish my glass of wine before offering another. The aspect is glass of wine.
    output: neutral
    Now complete the following example-
    input: """
    
def ALSC(text1):
  alsc = []
  delim_instruct = ' The aspect is '
  eos_instruct = '.\noutput:'
  tokenized_text = tokenizer(bos_instruct + text1 + delim_instruct + eos_instruct, return_tensors="pt")
  output = model.generate(tokenized_text.input_ids)
  alsc.append(tokenizer.decode(output[0],skip_special_tokens=True))
  return alsc
