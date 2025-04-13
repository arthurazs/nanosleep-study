from time import monotonic_ns as mn

from abs_sleep import abs_nanosleep


runs = []
for _ in range(1_000):
    start = mn()
    abs_nanosleep(start + (250 * 1_000))
    took = mn() - start
    runs.append(took / 1_000)  # ns to us
print(f"""abs_nanosleep(250 * 1_000)  # 250 us

ran 1_000 times

Stats in us
min: {min(runs)}
mean: {sum(runs) / len(runs)}
max: {max(runs)}""")
