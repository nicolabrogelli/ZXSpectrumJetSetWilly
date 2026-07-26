# Python simulation of clock.asm Z80 logic to verify correctness

def simulate_clock(start_hours=7, start_minutes=0, start_pm=0, steps=2000):
    hours = start_hours
    minutes = start_minutes
    is_pm = start_pm
    
    history = []
    
    for _ in range(steps):
        # 1 minute passed
        minutes += 1
        if minutes == 60:
            minutes = 0
            hours += 1
            if hours == 12:
                is_pm ^= 1 # Toggle AM/PM
            elif hours == 13:
                hours = 1
        
        ampm = "pm" if is_pm else "am"
        str_repr = f"Time {hours:2d}:{minutes:02d}{ampm}"
        history.append(str_repr)
        
    return history

res = simulate_clock(7, 0, 0, 1500)
print("Initial:", "7:00am")
print("Step 59 (7:59am):", res[58])
print("Step 60 (8:00am):", res[59])
print("Step 299 (11:59am):", res[298])
print("Step 300 (12:00pm):", res[299])
print("Step 359 (12:59pm):", res[358])
print("Step 360 (1:00pm):", res[359])
print("Step 1019 (11:59pm):", res[1018])
print("Step 1020 (12:00am):", res[1019])
print("Step 1079 (12:59am):", res[1078])
print("Step 1080 (1:00am):", res[1079])
