class Helper:
	static func noop() -> void:
		pass


## Returns the first child of parent_node with the given type.
static func find_child_by_type(from: Node, type: String, is_recursive := true, predicate := Helper.noop) -> Node:
	if from == null:
		return null
	var result := from.find_children("", type, is_recursive, false)
	if not result.is_empty() and predicate != Helper.noop:
		result = result.filter(predicate)
	return null if result.is_empty() else result[0]
