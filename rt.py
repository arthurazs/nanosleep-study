from time import sleep, perf_counter as pc
runs = []
for _ in range(1_000):
    start = pc()
    sleep(250 / 1_000_000)
    took = pc() - start
    runs.append(took * 1_000 * 1_000)  # sec to ms to us
print(f"""sleep(250 / 1_000_000)  # 250 us

ran 1_000 times

Stats in us
min: {min(runs)}
mean: {sum(runs) / len(runs)}
max: {max(runs)}""")
