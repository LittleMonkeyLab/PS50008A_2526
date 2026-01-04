from pathlib import Path
from bs4 import BeautifulSoup
from openai import OpenAI

# 1. Paths
html_path = Path("/Users/gordonwright/GS_RMTeaching_2526/GS_RM0_2526/_site/week11/lecture/reading.html")
out_mp3 = html_path.parent / "week11_reading.mp3"

# 2. Load and extract text from HTML
html = html_path.read_text(encoding="utf-8")
soup = BeautifulSoup(html, "lxml")  # pip install beautifulsoup4 lxml
main = soup.find("main") or soup.body            # adjust selector if needed
text = main.get_text(separator="\n", strip=True)

# Optional: truncate for quick test
text = text[:5000]

# 3. OpenAI TTS
client = OpenAI()  # expects OPENAI_API_KEY in env

with client.audio.speech.with_streaming_response.create(
    model="gpt-4o-mini-tts",
    voice="coral",                 # pick any supported voice
    input=text,
    instructions="Read this as an engaging research methods textbook chapter.",
) as response:
    response.stream_to_file(out_mp3)

print(f"Saved: {out_mp3}")
