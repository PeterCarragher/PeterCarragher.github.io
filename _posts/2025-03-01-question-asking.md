---
title: "Question Asking with LLMs"
excerpt: "Evaluating Question Asking Ability with LLMs"
header:
  image: /assets/images/question_asking_eval.png
  teaser: /assets/images/question_asking_eval.png
# sidebar:
#   - title: "Role"
#     image: /assets/images/dig_deeper.png
#     image_alt: "logo"
#     text: "Designer, Front-End Developer"
#   - title: "Responsibilities"
#     text: "Reuters try PR stupid commenters should isn't a business model"
gallery:
  - url: /assets/images/question_asking_eval.png
    image_path: /assets/images/question_asking_eval.png
    alt: "Evaluating question asking ability"
---

## NotebookLM Summary

../assets/audio/notebooklm_question_asking.wav

## Overview

This blog post walks you through the implementation of a question-asking game built using Streamlit. The game is designed to encourage curiosity and critical thinking by allowing users to ask questions about a randomly chosen phenomenon. The teacher (an AI model) provides answers that provoke deeper inquiry. The game also evaluates the quality of the questions asked.

The project is divided into the following sections:
1. **Game Setup and Sidebar Configuration**: Setting up the game parameters and user inputs.
2. **Phenomenon Selection and Explanation**: Randomly selecting a phenomenon and generating an explanation.
3. **Conversation Management**: Initializing and managing the AI-driven conversation.
4. **Evaluation of Questions**: Analyzing the user's questions based on knowledge graph coverage and Bloom's Taxonomy.
5. **User Interface**: Displaying the chat interface and handling user interactions.

Here's a [demo on streamlit](https://questionme.streamlit.app/).

Let's dive into each section with code snippets and detailed explanations.

---

## 1. Game Setup and Sidebar Configuration

The game begins with a sidebar where users can configure the game settings, such as the number of questions and the subject of the phenomenon. This setup ensures that the user has control over the game parameters, making the experience customizable and engaging.

```python
import streamlit as st
import phenomena

st.title("Question Asking Game", help="Open the sidebar to start a new game.")
st.session_state.setdefault('questions_asked', 0)

subjects = phenomena.phenomena.keys()
with st.sidebar:
    password = ""  # User password input (currently disabled)
    question_limit = st.number_input('Question Limit', min_value=1, max_value=10, value=2, step=1)
    subject = st.selectbox('Choose a subject', subjects, label_visibility='collapsed')
```

Here, the `st.sidebar` component is used to create a sidebar where users can input their preferences. The `st.number_input` and `st.selectbox` widgets allow users to set the question limit and select a subject, respectively. These inputs are stored in the session state for use throughout the game.

---

## 2. Phenomenon Selection and Explanation

Once the game starts, a random phenomenon is selected from the chosen subject. The AI model then generates a high-level explanation of the phenomenon to provide context for the user.

```python
import numpy as np
from langchain.chat_models import ChatOpenAI
from langchain.prompts.chat import ChatPromptTemplate
from langchain.chains import LLMChain

def get_paradox():
    chosen_paradox = np.random.choice(phenomena.phenomena[subject])
    chat_prompt = ChatPromptTemplate.from_messages([game_description, "{text}"])
    chain = LLMChain(llm=ChatOpenAI(), prompt=chat_prompt)
    paradox_explanation = chain.run(
        f"Describe the following phenomena in 2 paragraphs: {chosen_paradox}"
    )
    return chosen_paradox, paradox_explanation, ""
```

This function uses the `numpy` library to randomly select a phenomenon and the LangChain library to generate an explanation. The explanation is designed to be accessible to a layperson while still being thought-provoking.

---

## 3. Conversation Management

The core of the game is the conversation between the user (student) and the AI (teacher). This section initializes the conversation with a prompt template that sets the context and rules for the interaction.

```python
from langchain.chains.conversation.memory import ConversationSummaryMemory
from langchain.prompts.prompt import PromptTemplate
from langchain import OpenAI, ConversationChain

def init_gpt(game_description):
    chosen_paradox, paradox_explanation, paradox_rdf = get_paradox()
    template = game_description + """
Teacher: Please ask questions about """ + chosen_paradox + """
{history}
Student: {input}
Teacher:"""
    PROMPT = PromptTemplate(input_variables=["history", "input"], template=template)
    llm = OpenAI(temperature=0, model_name="gpt-3.5-turbo")
    conversation = ConversationChain(
        prompt=PROMPT,
        llm=llm,
        verbose=True,
        memory=ConversationSummaryMemory(llm=llm, ai_prefix="Teacher", human_prefix="Student"),
    )
    return conversation, paradox_explanation, paradox_rdf
```

The `ConversationChain` object manages the dialogue, using memory to track the conversation history. This ensures that the AI's responses are coherent and contextually relevant.

---

## 4. Evaluation of Questions

At the end of the game, the user's questions are evaluated based on their depth, coverage, and alignment with Bloom's Taxonomy. This provides valuable feedback to the user on their questioning skills.

```python
def evaluate():
    questions = "\n".join([f"Q{idx+1}. {q}" for idx, q in enumerate(st.session_state.past)])
    evaluate_rdf_prompt = f"""Estimate how comprehensive my questions have been...
    Questions:
    {questions}"""
    evaluate_blooms_prompt = """Use Blooms Taxonomy to classify my questions...
    Questions:
    {questions}"""
    with eval_tab:
        st.header('Knowledge Graph Coverage')
        kg_coverage = st.session_state.chain.run(evaluate_rdf_prompt)
        st.markdown(kg_coverage)
        st.header('Blooms Taxonomy')
        blooms_taxonomy = st.session_state.chain.run(evaluate_blooms_prompt)
        st.markdown(blooms_taxonomy)
```

This function uses prompts to analyze the user's questions. The results are displayed in the evaluation tab, providing insights into the user's performance.

---

## 5. User Interface

The user interface is designed to be intuitive and interactive. It displays the conversation and allows the user to input their questions.

```python
from streamlit_chat import message

with chat_tab:
    if st.session_state.get('generated'):
        for i, response in enumerate(st.session_state['generated']):
            if i - 3 >= 0 and i - 3 < len(st.session_state['past']):
                message(st.session_state['past'][i-3], is_user=True, key=f"{i-3}_user")
            message(response, key=f"{i}")
    if password == pwd:
        st.text_input("Ask a question:", on_change=on_input_change, key="user_input")
```

The `streamlit_chat` library is used to render the chat interface. The `st.text_input` widget captures the user's questions, which are then processed by the AI.

---

## Conclusion

This project demonstrates how to build an interactive question-asking game using Streamlit and LangChain. The game encourages curiosity and critical thinking while providing insightful evaluations of the user's questions. By combining modern AI tools with an engaging interface, this project showcases the potential of educational technology.

Find the complete code on [GitHub](https://github.com/PeterCarragher/question_asking) and a demo on [Streamlit](https://questionme.streamlit.app/)

![Evaluation Tab](/assets/images/question_asking_eval.png)
