# Nanosleep Study

Tested on **Ubuntu 24.04.2 Server** (headless) with the following specs:
- **CPU** i5-9300H @ 2.4GHz (x86_64)
- **RAM** 8 GB
- **Kernel** 6.8.1-1019-realtime (realtime-enabled `PREEMPT_RT`)

All experiments were executed using different **scheduling policies**, _e.g._:
```bash
sudo chrt --fifo 99 <command>
```

- Refer to the [Makefile](Makefile) for the full list of scheduling configurations used.
- For detailed info on available policies, see [chrt man page – POLICIES](https://www.man7.org/linux/man-pages/man1/chrt.1.html#POLICIES) section.

## Code differences

Each implementation is set to sleep 250 µs using the following functions:

- Python uses `time.sleep` 
- Python async uses `asyncio.sleep`
- Python abs uses `abs_sleep.abs_nanosleep`
- C uses `nanosleep`

## Compilation Details
C code was compiled with aggressive optimization flags:
```bash
-std=c99 -Ofast -march=native -flto -funroll-loops -fomit-frame-pointer
```

Debug symbols were stripped from the final binary:
```bash
strip rt.out
```

---

## Performance Summary

Most implementations achieved comparable performance, averaging around **292 µs** under the **FIFO** scheduler.
By contrast, the **Python async** implementation was significantly slower, with a mean best latency of approximately **1181 µs**.

Performance data per implementation is shown below in µs.
Each cell contains `min / mean / max` latency values. Lower values (closer to **250 µs**) are better.

| **Policy**  | **Python** | **Python Async** | **Python ABS**                          | **C** |
|-------------|------------|------------------|-----------------------------------------|-------|
| Other       | 334 / 416 / 492 | **1124 / 1322 / 1485** | 327 / 426 / 520 | 327 / 418 / 527 |
| FIFO        | 253 / 295 / 430 | 1033 / 1181 / 1248 | 255 / 298 / 367 | **262 / 285 / 335** |
| Round Robin | 254 / 295 / 438 | 1033 / 1183 / 1250 | 253 / 299 / 438 | 253 / 291 / 400 |
| Batch       | 310 / 427 / 533 | 1122 / 1322 / 1420 | 343 / 425 / 509 | 338 / 421 / 529 |
| Idle        | 348 / 422 / 494 | 1120 / 1321 / 1439 | 344 / 426 / 515 | 338 / 416 / 486 |
