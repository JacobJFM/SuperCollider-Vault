from pydub import AudioSegment
import sys

if len(sys.argv) != 2:
        print("Usage: python mono_wav.py <file_path>")
else:
    file_path = sys.argv[1]

try:
    sound = AudioSegment.from_wav(file_path)
    sound = sound.set_channels(1)
    mono_file_path = file_path.replace(".wav", "_mono.wav")
    sound.export(mono_file_path, format="wav")
    print(f"File converted to mono and saved as: {mono_file_path}")
except Exception as e:
    print(f"Error occurred: {e}")