---
title: Med Chatbot
emoji: 🏥
colorFrom: blue
colorTo: green
sdk: docker
pinned: false
---

# 🏥 Medical Chatbot

An AI-powered medical assistant built with Flask, LangChain, Groq (LLaMA 3.1), and Pinecone.

## Features
- RAG (Retrieval Augmented Generation) pipeline
- Powered by `llama-3.1-8b-instant` via Groq API
- Medical knowledge base indexed in Pinecone
- Clean chat UI

## Tech Stack
- **Backend:** Flask + LangChain
- **LLM:** Groq (LLaMA 3.1 8B)
- **Vector DB:** Pinecone
- **Embeddings:** sentence-transformers/all-MiniLM-L6-v2