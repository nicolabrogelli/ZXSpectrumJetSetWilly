# Python simulation of exact Z80 clock logic in clock.asm

def run_clock_simulation():
    hours = 7
    minutes = 0
    is_pm = 0 # 0 = AM, 1 = PM
    
    log = []
    
    # Simulate minute updates
    total_minutes = 0
    game_over = False
    
    # 7:00am to 12:00am (Midnight) is 17 hours = 1020 minutes
    while total_minutes < 1050:
        # Formatted string
        pm_str = "pm" if is_pm else "am"
        if hours < 10:
            time_str = f"  {hours}:{minutes:02d}{pm_str}"
        else:
            time_str = f" {hours}:{minutes:02d}{pm_str}"
            
        if total_minutes in [0, 59, 60, 299, 300, 359, 360, 1018, 1019, 1020]:
            log.append((total_minutes, hours, minutes, is_pm, time_str, game_over))
            
        # Minute passes
        minutes += 1
        if minutes == 60:
            minutes = 0
            hours += 1
            if hours == 12:
                is_pm ^= 1
            elif hours == 13:
                hours = 1
                
        total_minutes += 1
        
        # Midnight check: hours == 12, minutes == 0, is_pm == 0 (AM) after passing 11:59pm
        if hours == 12 and minutes == 0 and is_pm == 0:
            game_over = True
            pm_str = "am"
            time_str = f" 12:00{pm_str}"
            log.append((total_minutes, hours, minutes, is_pm, time_str, game_over))
            break

    print("=== CLOCK PROGRESSION SIMULATION RESULTS ===")
    for m, h, min_val, pm, s, go in log:
        print(f"Min {m:4d} | {h:2d}:{min_val:02d} {'PM' if pm else 'AM'} | Display: '{s}' | GameOver: {go}")

if __name__ == "__main__":
    run_clock_simulation()
