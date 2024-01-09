from textblob import TextBlob
def OTE(text):
  blob = TextBlob(text)

  opinion_terms = []

  for sentence in blob.sentences:
      for word, tag in sentence.tags:
          if tag == 'JJ' or tag == 'JJR' or tag == 'JJS':
              opinion_terms.append(word)
  return opinion_terms

