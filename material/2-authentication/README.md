Install the OS dependencies

```
sudo apt update
sudo apt install -y \
  python3 \
  python3-dev \
  python3-venv \
  python-is-python3 \
  libffi-dev \
  build-essential
```

Install the requirements

```
pip3 install -r requirements.txt
```

Run the tester

```
python3 zerologon_tester.py
```