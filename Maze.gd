extends Node2D

@export var cell_scene: PackedScene
@export var circle_cell_scene: PackedScene
@export var gate_scene: PackedScene


var CELLS = []
var GATES = []


class Vertex:
	var idx: int
	var x: int
	var y: int
	
	func _init(index, x_pos, y_pos):
		idx = index
		x = x_pos
		y = y_pos


class Edge:
	var src: int
	var dst: int
	var dir: int
	
	func _init(source, dest, direction):
		src = source
		dst = dest
		dir = direction


class EdgeList:
	var list: Array
	var vertices: Dictionary
	
	func _init(edges):
		list = edges
		validate_edges()
		vertices = get_vertices()
		
	func validate_edges():
		for i in range(len(list)):
			var edge_list = list[i]
			assert(len(edge_list) < 5, "Edge_list for vertex %d can't have more than 4 edges" % i);
			#assert(len(edge_list) > 0, "Edge_list for vertex %d must have at least 1 edge" % i);
			
			var horizontal_edges = []
			var vertical_edges = []
			for j in range(len(edge_list)):
				var e = edge_list[j]
				assert(e.src == i+1, "Edge %d in edge_list index %d src %d doesn't match index" % [j, i, e.src]);
				if e.dir == 0:
					horizontal_edges.append(e)
				elif e.dir == 1:
					vertical_edges.append(e)
				else:
					assert(false, "edge dir must be 0 (horiz) or 1 (vert)")
					
			assert(len(horizontal_edges) < 3, "Vertex %d can only have two horizontal edges" % i)
			assert(len(vertical_edges) < 3, "Vertex %d can only have two vertical edges" % i)
			
			# First edge expectations
			if i == 0:
				assert(len(edge_list) == 1, "First vertex should have only 1 edge")
				assert(edge_list[0].dir == 0, "First vertex should only have horizontal edge")
				assert(edge_list[0].dst == 2, "First vertex shoudl only be connected to second vertex")
				
	func get_vertices():
		var vert_dict: Dictionary = {}
		for i in range(len(list)):
			var edge_list = list[i]
			for j in range(len(edge_list)):
				var e = edge_list[j]
				vert_dict[e.src] = true
				vert_dict[e.dst] = true
		return vert_dict


func get_h_edges(list):
	var h_edges = []
	for e in list:
		if e.dir == 0:
			h_edges.append(e)
	return h_edges


func get_v_edges(list):
	var v_edges = []
	for e in list:
		if e.dir == 1:
			v_edges.append(e)
	return v_edges


# Called when the node enters the scene tree for the first time.
func _ready():
	var maze_graph = make_maze_graph()
	var vertices = maze_graph[0]
	var edges = maze_graph[1]
	
	# Let's now create the actual cells for the maze, and position them.
	
	for i in range(len(vertices)):
		var v = vertices[i]
		var edgelist = edges.list[i]
		
		var cell
		if len(get_h_edges(edgelist)) > 0 && len(get_v_edges(edgelist)) > 0:
			cell = circle_cell_scene.instantiate()
		else:
			cell = cell_scene.instantiate()

		CELLS.append(cell)
		add_child(cell)
		
		var x_val = 120 * v.x + (10 * v.x) # actual size, plus buffer
		var y_val = 120 * v.y + (10 * v.y)
		cell.set_position(Vector2(x_val, y_val))
	
	for i in range(len(vertices)):
		var v = vertices[i]
		var edgelist = edges.list[i]
		for e in edgelist:
			# Let's create the gates. (Ugh, rotations... for horizontal gates...)
			# We know that it connects to vertex i, which we just decided the
			#  placement of.
			# And we know that it's either vertical or horizontal, and we know that it connects
			#  vertex i to some other vertex, presumably that is adjacent to vertex i. (It must be, in fact, I just don't validate it yet.)
			var gate = gate_scene.instantiate()
			GATES.append(gate)
			add_child(gate)
			
			# i'm just gonan be dumb and for vertical only so far.
			var vertex_pos_x = 120 * v.x + (10 * v.x)
			var vertex_pos_y = 120 * v.y + (10 * v.y)
			
			if e.dir == 0: # horizontal edge, aka gate must be vertical
				# We'll always place the gate at the right edge of its src vertex
				#  which we can assume is v
				var x_val = vertex_pos_x + 118
				var y_val = vertex_pos_y + 5
				gate.position = Vector2(x_val, y_val)
			else: # vertical edge, aka gate must be horizontal
				# Now, how do we tell whether this gate is going up or down?
				#  we'll need to inspect the edge's other vertex.
				var u = vertices[e.dst -1]
				if u.y > v.y: # dst is below src; we are on a bottom edge
					var x_val = vertex_pos_x + 5
					var y_val = vertex_pos_y + 135
					gate.position = Vector2(x_val, y_val)
				else:
					var x_val = vertex_pos_x + 5
					var y_val = vertex_pos_y
					gate.position = Vector2(x_val, y_val)
				gate.rotate(-PI/2)
					
			# TODO KELLY:
			# - Start working on the mice? :o!
			# - Think about the difference between prep-time level building Edges vs. run-time Edges (aka where can mice actualy traverse?)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func make_maze_graph():
	# This is annoying and gross and clumsy, but it's about as good as I've got.
	# Aka, this is my "level 1" map.
	var vertices = [
		Vertex.new(1, 0, 0),
		Vertex.new(2, 1, 0),
		Vertex.new(3, 2, 0),
		Vertex.new(4, 3, 0),
		Vertex.new(5, 4, 0),
		Vertex.new(6, 2, 1),
		Vertex.new(7, 2, -1),
	]
	# Consider: Duplicate both directions of all edges to make lookup easier.
	var edge_list = EdgeList.new([
		[Edge.new(1, 2, 0)],
		[Edge.new(2, 3, 0)],
		[Edge.new(3, 4, 0), Edge.new(3, 6, 1), Edge.new(3, 7, 1)],
		[Edge.new(4, 5, 0)],
		[],
		[],
		[],
		[],
	])
	return [vertices, edge_list]
