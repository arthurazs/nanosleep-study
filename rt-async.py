import asyncio as aio
from time import perf_counter as pc

async def run():
    start = pc()
    await aio.sleep(250 / 1_000_000)
    took = pc() - start
    return took * 1_000 * 1_000  # sec to ms to us

async def main():
    runs = []
    for _ in range(1_000):
        runs.append(await run())
    print(f"""sleep(250 / 1_000_000)  # 250 us

    ran 1_000 times

    Stats in us
    min: {min(runs)}
    mean: {sum(runs) / len(runs)}
    max: {max(runs)}""")

aio.run(main())
