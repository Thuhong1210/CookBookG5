import os
import sys
from dotenv import load_dotenv

# Load environment variables BEFORE importing backend
load_dotenv()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.join(BASE_DIR, 'backend')

if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from backend.run_app import main  # noqa: E402


if __name__ == '__main__':
    main()

