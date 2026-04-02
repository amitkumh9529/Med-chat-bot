

# 🏥 Medical Chatbot — RAG-Powered AI Assistant

An AI-powered medical question-answering chatbot built with **Flask**, **LangChain**, **Groq (LLaMA 3.1)**, and **Pinecone**. It uses a Retrieval-Augmented Generation (RAG) pipeline to answer medical queries based on a custom PDF knowledge base.

---

## 📸 Demo

> Live on Hugging Face Spaces → [https://huggingface.co/spaces/dexter6969/medchat](https://huggingface.co/spaces/dexter6969/medchat)

---

## 🧠 How It Works

```
User Question
     │
     ▼
HuggingFace Embeddings (all-MiniLM-L6-v2)
     │
     ▼
Pinecone Vector DB  ──► Retrieve top-5 relevant chunks
     │
     ▼
LangChain RAG Chain
     │
     ▼
Groq LLM (llama-3.1-8b-instant)
     │
     ▼
Concise Medical Answer
```

1. **PDF Ingestion** — Medical PDFs are loaded, split into 500-token chunks, and embedded
2. **Vector Storage** — Embeddings are stored in a Pinecone serverless index (`cosine`, `dim=384`)
3. **Retrieval** — At query time, top-5 semantically similar chunks are fetched
4. **Generation** — Groq's LLaMA 3.1 8B model generates a concise answer using the retrieved context

---

## 🗂️ Project Structure

```
Med chat bot/
├── src/
│   ├── __init__.py
│   ├── helper.py          # PDF loading, chunking, embeddings
│   └── prompt.py          # System prompt for the LLM
├── templates/
│   └── chat.html          # Chat UI (Flask Jinja2 template)
├── static/                # CSS / JS assets
├── data/                  # 📁 Medical PDFs (gitignored, local only)
├── research/              # Jupyter notebooks for experimentation
├── app.py                 # Flask app — main entry point
├── store_index.py         # One-time script: ingest PDFs → Pinecone
├── setup.py               # Package setup
├── requirements.txt       # Python dependencies
├── Dockerfile             # Docker image definition
├── .dockerignore          # Files excluded from Docker build
├── .env                   # API keys (local only, gitignored)
├── .gitignore
└── README.md
```

---

## 🔧 Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Flask 3.1 |
| **LLM** | Groq — `llama-3.1-8b-instant` |
| **RAG Framework** | LangChain 0.3 |
| **Embeddings** | `sentence-transformers/all-MiniLM-L6-v2` |
| **Vector DB** | Pinecone (Serverless, AWS us-east-1) |
| **PDF Parsing** | PyPDF + LangChain DirectoryLoader |
| **Server** | Gunicorn |
| **Deployment** | Docker on Hugging Face Spaces |

---

## ⚙️ Local Setup

### Prerequisites

- Python 3.11+
- A [Pinecone](https://www.pinecone.io/) account (free tier works)
- A [Groq](https://console.groq.com/) account (free tier works)

### 1. Clone the repository

```bash
git clone https://github.com/your-username/med-chat-bot.git
cd med-chat-bot
```

### 2. Create and activate a virtual environment

```bash
python -m venv med
# Windows
med\Scripts\activate
# macOS/Linux
source med/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
pip install -e .
```

### 4. Set up environment variables

Create a `.env` file in the root directory:

```env
PINECONE_API_KEY="your_pinecone_api_key_here"
GROQ_API_KEY="your_groq_api_key_here"
```

> ⚠️ Never commit `.env` to Git — it is already in `.gitignore`

### 5. Add your medical PDFs

Place your PDF files inside the `data/` folder:

```
data/
├── medical_book_1.pdf
├── medical_book_2.pdf
└── ...
```

### 6. Build the Pinecone vector index (one-time only)

This script reads your PDFs, generates embeddings, and uploads them to Pinecone:

```bash
python store_index.py
```

> ✅ This only needs to be run **once** (or whenever you add new PDFs). The index persists in Pinecone.

### 7. Run the app

```bash
python app.py
```

Open your browser at → **[http://localhost:8080](http://localhost:8080)**

---

## 🐳 Running with Docker (locally)

```bash
# Build the image
docker build -t med-chatbot .

# Run the container (pass your API keys)
docker run -p 8080:8080 \
  -e PINECONE_API_KEY="your_pinecone_api_key" \
  -e GROQ_API_KEY="your_groq_api_key" \
  med-chatbot
```

Open → **[http://localhost:8080](http://localhost:8080)**

---

## 🚀 Deploying to Hugging Face Spaces

### Step 1 — Create a new Space

1. Go to [huggingface.co/spaces](https://huggingface.co/spaces)
2. Click **"Create new Space"**
3. Set:
   - **SDK**: Docker
   - **Visibility**: Public or Private
4. Click **Create Space**

### Step 2 — Add Secret Environment Variables

In your Space → **Settings** → **Variables and secrets**, add:

| Secret Name | Value |
|---|---|
| `PINECONE_API_KEY` | Your Pinecone API key |
| `GROQ_API_KEY` | Your Groq API key |

> 🔒 HF Secrets are injected at runtime as environment variables — safe and secure.

### Step 3 — Generate a HF Write Token

1. Go to → [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
2. Click **"New token"**
3. Set role to **Write**
4. Copy the token (`hf_...`)

### Step 4 — Push to HF Spaces via Git

```bash
# Add HF Space as a remote (with token embedded for auth)
git remote add space https://YOUR_HF_USERNAME:YOUR_HF_TOKEN@huggingface.co/spaces/YOUR_HF_USERNAME/YOUR_SPACE_NAME

# Push your code
git add .
git commit -m "Deploy med chatbot"
git push space main
```

### Step 5 — Monitor the build

- Go to your Space URL
- Click the **"Logs"** tab
- Build takes ~5–10 minutes (pulls Python 3.11-slim + installs sentence-transformers)
- Once complete, your app will be live at `https://huggingface.co/spaces/YOUR_USERNAME/YOUR_SPACE_NAME`

---

## 🔁 Updating the Deployment

After any code change:

```bash
git add .
git commit -m "Your change description"
git push space main
```

HF Spaces will automatically rebuild the Docker image and redeploy.

---

## 📦 Key Dependencies

```
langchain==0.3.26
flask==3.1.1
sentence-transformers==4.1.0
langchain-pinecone==0.2.8
langchain-groq==0.3.1
langchain-huggingface==0.1.2
langchain-community==0.3.26
pypdf==5.6.1
python-dotenv==1.1.0
gunicorn==21.2.0
```

---

## 🛠️ Troubleshooting

| Problem | Solution |
|---|---|
| `PINECONE_API_KEY not found` | Check `.env` file locally or HF Secrets in deployment |
| `Index not found` in Pinecone | Run `python store_index.py` to create and populate the index |
| `Authentication failed` on `git push` | Generate a new **Write** token from HF settings |
| Port not responding on HF | Ensure `EXPOSE 8080` in Dockerfile matches `app_port: 8080` in README |
| OOM / killed on HF Spaces | Upgrade to a paid HF tier or use a smaller embedding model |
| `nothing to commit` after rename | Use `git mv --force Readme.md README.md` to force case-rename on Windows |

---

## 👨‍💻 Author

**Amith Kumar**
- Email: amith3169@gmail.com
- HuggingFace: [dexter6969](https://huggingface.co/dexter6969)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).