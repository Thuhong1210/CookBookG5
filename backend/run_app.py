import os

from mycookbook import app


def main():
    port = int(os.environ.get('PORT', 8000))
    app.run(host='0.0.0.0', port=port, debug=True)


if __name__ == '__main__':
    main()
