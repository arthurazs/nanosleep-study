venv := .venv/bin/

.PHONY: install i
i: install
install:
	sudo apt install -y curl clang
	curl -LsSf https://astral.sh/uv/install.sh | sh
	uv venv
	uv pip install abs-sleep

.PHONY: python
python:
	@echo "\n>>> other"
	sudo chrt --other 0 $(venv)/python rt.py
	
	@echo "\n>>> fifo"
	sudo chrt --fifo 99 $(venv)/python rt.py
	
	@echo "\n>>> round robin"
	sudo chrt --rr 99   $(venv)/python rt.py
	
	@echo "\n>>> batch"
	sudo chrt --batch 0 $(venv)/python rt.py
	
	@echo "\n>>> idle"
	sudo chrt --idle 0  $(venv)/python rt.py

.PHONY: pythonrt
pythonrt:
	@echo "\n>>> other"
	sudo chrt --other 0 $(venv)/python rt-async.py
	
	@echo "\n>>> fifo"
	sudo chrt --fifo 99 $(venv)/python rt-async.py
	
	@echo "\n>>> round robin"
	sudo chrt --rr 99   $(venv)/python rt-async.py
	
	@echo "\n>>> batch"
	sudo chrt --batch 0 $(venv)/python rt-async.py
	
	@echo "\n>>> idle"
	sudo chrt --idle 0  $(venv)/python rt-async.py

.PHONY: pythonabs
pythonabs:
	@echo "\n>>> other"
	sudo chrt --other 0 $(venv)/python rt-abs.py
	
	@echo "\n>>> fifo"
	sudo chrt --fifo 99 $(venv)/python rt-abs.py
	
	@echo "\n>>> round robin"
	sudo chrt --rr 99   $(venv)/python rt-abs.py
	
	@echo "\n>>> batch"
	sudo chrt --batch 0 $(venv)/python rt-abs.py
	
	@echo "\n>>> idle"
	sudo chrt --idle 0  $(venv)/python rt-abs.py

.PHONY: build b
b: build
build:
	clang -std=c99 -Ofast -march=native -flto -funroll-loops -fomit-frame-pointer rt.c -o rt.out
	strip rt.out

.PHONY: c
c:
	@echo "\n>>> other"
	sudo chrt --other 0 ./rt.out
	return
	
	@echo "\n>>> fifo"
	sudo chrt --fifo 99 ./rt.out
	
	@echo "\n>>> round robin"
	sudo chrt --rr 99 ./rt.out
	
	@echo "\n>>> batch"
	sudo chrt --batch 0 ./rt.out
	
	@echo "\n>>> idle"
	sudo chrt --idle 0 ./rt.out
