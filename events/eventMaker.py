import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import json
import os

JSON_FILE_PATH = "events.json"

# Available effect options
EFFECT_OPTIONS = [
    "give_horse",
    "take_horse",
    "change_speed",
    "change_stamina",
    "change_acceleration",
    "change_energy",
    "change_fertility",
    "change_money",
    "nothing"
]

# Effects that require "{horse}" in ID or message
HORSE_EFFECTS = {
    "take_horse", "change_speed", "change_stamina",
    "change_acceleration", "change_energy", "change_fertility"
}

events = []
yes_effects = []
no_effects = []

def load_existing_events():
    global events
    if os.path.exists(JSON_FILE_PATH):
        try:
            with open(JSON_FILE_PATH, "r") as f:
                loaded = json.load(f)
                if isinstance(loaded, list):
                    events = loaded
                else:
                    messagebox.showwarning("Warning", f"{JSON_FILE_PATH} contents invalid, starting fresh.")
                    events = []
        except Exception as e:
            messagebox.showwarning("Warning", f"Failed to load existing events: {e}")
            events = []
    else:
        events = []

def show_help():
    help_text = (
        " **Event Creator Help**\n\n"
        "intro: first message to player, don't include them introducing themselves, that is randomly added\n"
        "question: the choice the player will resonde to.\n"
        "yes/no response: how the character will respond if each choice is selected\n"
        "Effects:\n"
        "   - give_horse: adds a random horse to players stables (no variable)\n"
        "   - take_horse: takes a random horse from playes stable (no variable)\n"
        "   - change_money: changes the players money by specified amount (int: amount, can be +/-)\n"
        "   - change_$STAT: changes the $STAT of a random horse in the players stable by an amount ((int: amount, can be +/-))\n"
        "       Note: all change_$STAT effects will be applied to the same random horse"
        "   - nothing: does nothing (no variable)\n\n"
        
       
        "Press 'Add Event' to store it. The event will appear in the list below.\n"
        "Press 'Save to JSON' to append events to the project’s master file.\n"
        "Press 'Clear Fields' to start a new event.\n"
    )
    messagebox.showinfo("Help", help_text)


def add_yes_effect():
    global yes_effects
    effect = yes_effect.get()
    if effect in ["give_horse", "take_horse"]:
        value = "random"
    elif yes_random.get():
        value = "random"
    else:
        try:
            value = int(yes_value.get())
        except ValueError:
            messagebox.showerror("Invalid Input", "Yes value must be an integer.")
            return

    if effect:
        yes_effects.append({"effect": effect, "value": value})
        yes_effect_listbox.insert(tk.END, f"{effect} ({value})")
        yes_effect.set(EFFECT_OPTIONS[0])
        yes_value.set("0")
        yes_random.set(False)
        update_yes_value_state()

def add_no_effect():
    global no_effects
    effect = no_effect.get()
    if effect in ["give_horse", "take_horse"]:
        value = "random"
    elif no_random.get():
        value = "random"
    else:
        try:
            value = int(no_value.get())
        except ValueError:
            messagebox.showerror("Invalid Input", "No value must be an integer.")
            return

    if effect:
        no_effects.append({"effect": effect, "value": value})
        no_effect_listbox.insert(tk.END, f"{effect} ({value})")
        no_effect.set(EFFECT_OPTIONS[0])
        no_value.set("0")
        no_random.set(False)
        update_no_value_state()

def add_event():
    global yes_effects, no_effects
    eid = event_id.get().strip()
    msg = message.get().strip()
    yes_resp = yes_response.get().strip()
    no_resp = no_response.get().strip()

    if not eid or not msg:
        messagebox.showerror("Missing Data", "Event ID and Message are required.")
        return

    all_effects = yes_effects + no_effects
    if not any(effect["effect"] in HORSE_EFFECTS for effect in all_effects):
        if "{horse}" in eid or  "{horse}" in msg:
            messagebox.showerror("To use {horse}, your event must contain an event that will use a random player horse")
            return

    event = {
        "intro": eid,
        "question": msg,
        "choices": {
            "yes": {
                "response": yes_resp,
                "effects": yes_effects.copy()
            },
            "no": {
                "response": no_resp,
                "effects": no_effects.copy()
            }
        }
    }

    events.append(event)
    update_event_listbox()
    messagebox.showinfo("Added", f"Event '{eid}' added.")
    clear_fields()

def update_event_listbox():
    event_listbox.delete(0, tk.END)
    for event in events:
        event_listbox.insert(tk.END, event["intro"])

def export_json():
    global events
    if not events:
        messagebox.showerror("No Events", "Add at least one event before exporting.")
        return

    # Load old data into separate list
    if os.path.exists(JSON_FILE_PATH):
        try:
            with open(JSON_FILE_PATH, "r") as f:
                existing_events = json.load(f)
        except:
            existing_events = []
    else:
        existing_events = []

    existing_ids = {e["intro"] for e in existing_events}
    new_events = [e for e in events if e["intro"] not in existing_ids]
    combined_events = existing_events + new_events

    try:
        with open(JSON_FILE_PATH, "w") as f:
            json.dump(combined_events, f, indent=2)
        messagebox.showinfo("Success", f"{len(new_events)} event(s) added to {JSON_FILE_PATH}")
    except Exception as e:
        messagebox.showerror("Error", f"Failed to save events: {e}")

def clear_fields():
    global yes_effects, no_effects
    event_id.set("")
    message.set("")
    yes_effect.set(EFFECT_OPTIONS[0])
    yes_value.set("0")
    no_effect.set(EFFECT_OPTIONS[0])
    no_value.set("0")
    yes_response.set("")
    no_response.set("")
    yes_random.set(False)
    no_random.set(False)
    update_yes_value_state()
    update_no_value_state()
    yes_effects.clear()
    no_effects.clear()
    yes_effect_listbox.delete(0, tk.END)
    no_effect_listbox.delete(0, tk.END)
    

def update_yes_value_state():
    if yes_effect.get() in ["give_horse", "take_horse"]:
        yes_value_entry.config(state="disabled")
        yes_random.set(True)
    else:
        yes_value_entry.config(state="disabled" if yes_random.get() else "normal")

def update_no_value_state():
    if no_effect.get() in ["give_horse", "take_horse"]:
        no_value_entry.config(state="disabled")
        no_random.set(True)
    else:
        no_value_entry.config(state="disabled" if no_random.get() else "normal")

# --- GUI ---
root = tk.Tk()
root.title("Random Event Creator")
root.geometry("700x750")
root.resizable(True, True)

event_id = tk.StringVar()
message = tk.StringVar()
yes_effect = tk.StringVar(value=EFFECT_OPTIONS[0])
yes_value = tk.StringVar(value="0")
no_effect = tk.StringVar(value=EFFECT_OPTIONS[0])
no_value = tk.StringVar(value="0")
yes_response = tk.StringVar()
no_response = tk.StringVar()
yes_random = tk.BooleanVar(value=False)
no_random = tk.BooleanVar(value=False)

yes_effect.trace_add("write", lambda *args: update_yes_value_state())
no_effect.trace_add("write", lambda *args: update_no_value_state())

for i in range(4): root.columnconfigure(i, weight=1)
for i in range(12): root.rowconfigure(i, weight=1)

ttk.Label(root, text="Intro").grid(row=0, column=0, sticky="e", padx=5)
ttk.Entry(root, textvariable=event_id).grid(row=0, column=1, columnspan=3, sticky="ew", padx=5)

ttk.Label(root, text="question").grid(row=1, column=0, sticky="e", padx=5)
ttk.Entry(root, textvariable=message).grid(row=1, column=1, columnspan=3, sticky="ew", padx=5)

ttk.Label(root, text="Yes Response").grid(row=2, column=0, sticky="e")
ttk.Entry(root, textvariable=yes_response).grid(row=2, column=1, columnspan=3, sticky="ew", padx=5)

ttk.Label(root, text="Yes Effect").grid(row=3, column=0, sticky="e")
ttk.Combobox(root, textvariable=yes_effect, values=EFFECT_OPTIONS, state="readonly").grid(row=3, column=1, sticky="ew")
yes_value_entry = ttk.Entry(root, textvariable=yes_value, width=5)
yes_value_entry.grid(row=3, column=2)
ttk.Checkbutton(root, text="Random", variable=yes_random, command=update_yes_value_state).grid(row=3, column=3)
ttk.Button(root, text="Add Yes Effect", command=add_yes_effect).grid(row=4, column=3, pady=3)
yes_effect_listbox = tk.Listbox(root)
yes_effect_listbox.grid(row=4, column=0, columnspan=3, sticky="nsew", padx=5, pady=3)

ttk.Label(root, text="No Response").grid(row=5, column=0, sticky="e")
ttk.Entry(root, textvariable=no_response).grid(row=5, column=1, columnspan=3, sticky="ew", padx=5)

ttk.Label(root, text="No Effect").grid(row=6, column=0, sticky="e")
ttk.Combobox(root, textvariable=no_effect, values=EFFECT_OPTIONS, state="readonly").grid(row=6, column=1, sticky="ew")
no_value_entry = ttk.Entry(root, textvariable=no_value, width=5)
no_value_entry.grid(row=6, column=2)
ttk.Checkbutton(root, text="Random", variable=no_random, command=update_no_value_state).grid(row=6, column=3)
ttk.Button(root, text="Add No Effect", command=add_no_effect).grid(row=7, column=3, pady=3)
no_effect_listbox = tk.Listbox(root)
no_effect_listbox.grid(row=7, column=0, columnspan=3, sticky="nsew", padx=5, pady=3)

ttk.Label(root, text="Events Created So Far").grid(row=8, column=0, columnspan=4)
event_listbox = tk.Listbox(root)
event_listbox.grid(row=9, column=0, columnspan=4, sticky="nsew", padx=5, pady=5)

ttk.Button(root, text="Add Event", command=add_event).grid(row=10, column=0, pady=10)
ttk.Button(root, text="Save to JSON File", command=export_json).grid(row=10, column=1, pady=10)
ttk.Button(root, text="Clear Fields", command=clear_fields).grid(row=10, column=2, pady=10)
ttk.Button(root, text="Help", command=show_help).grid(row=10, column=3, pady=10)

update_yes_value_state()
update_no_value_state()
root.mainloop()