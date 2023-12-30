extends Node

var listeners = {} # {event_name: [listener1, listener2, ...]} #event_name: String, listener: Callable
var events = {} # {event_name: [args1, args2, ...]} #event_name: String, args: Array (dialog:array,next:event_name,condition:array)
var condition_solver = {} # {condition_name: Callable} #condition_name: String, condition: Callable


#region Register
func register_listener(event_name, listener):
	if listeners.has(event_name):
		listeners[event_name].append(listener)
	else:
		listeners[event_name] = [listener]

func register_event(event_name,owner_node,method, args=[]):
	if events.has(event_name):
		events[event_name].append({"owner":owner_node,"method":method,"args":args})
	else:
		events[event_name] = [{"owner":owner_node,"method":method,"args":args}]

func register_condition_solver(condition_name, solver):
	if condition_solver.has(condition_name):
		print("Condition solver already exists for " + condition_name + ".")
	else:
		condition_solver[condition_name] = solver

#endregion

#region Unregister
func unregister_listener(event_name, listener):
	if listeners.has(event_name):
		listeners[event_name].erase(listener)

func unregister_event(event_name,owner_node,method):
	if events.has(event_name):
		for event in events[event_name]:
			if event["owner"] == owner_node and event["method"] == method:
				events[event_name].erase(event)
				break
#endregion

#region Emit
func emit(event_name, args):
	if listeners.has(event_name):
		for listener in listeners[event_name]:
			listener.call(args)

func emit_event(event_name):
	if events.has(event_name):
		for event in events[event_name]:
			if check_conditions(events[event_name]["args"]):
				event["owner"].call(event["method"],event["args"])
#endregion


#region Conditions
func check_conditions(event_obj):
	if event_obj.has("condition"):
		for condition in event_obj["condition"]:
			if not condition_solver[condition].call():
				return false
	return true
#endregion


#region Debug
func print_listeners():
	print("Listeners:")
	for event_name in listeners:
		print("\t"+event_name + ":")
		for listener in listeners[event_name]:
			print("\t\t" + str(listener))

func print_events():
	print("Events:")
	for event_name in events:
		print("\t"+event_name + ":")
		for event in events[event_name]:
			print("\t\t" + str(event))

func print_condition_solver():
	print("Condition solver:")
	for condition_name in condition_solver:
		print("\t"+condition_name + ":")
		print("\t\t" + str(condition_solver[condition_name]))

func print_all():
	print("---------------------")
	print_listeners()
	print("---------------------")
	print_events()
	print("---------------------")
	print_condition_solver()
#endregion