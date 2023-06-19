import std / [tables, json]

type
  JNodeIdx* = int

  JTree* = object
    nodes*: seq[JNode]

  JNodeKind* = enum
    nkEmpty
    nkObject
    nkArray
    nkString
    nkNumber
    nkInt64
    nkBool
    nkNull

  JNode* = object
    case kind*: JNodeKind
    of nkObject:
      kvpairs*: OrderedTable[string, JNodeIdx]
    of nkArray:
      items*: seq[JNodeIdx]
    of nkString:
      strVal*: string
    of nkNumber:
      numVal*: float
    of nkInt64:
      int64Val*: int64
    of nkBool:
      boolVal*: bool
    else:
      discard

# TODO: I don't really see a point in having own version of JsonNode, so I'll probably get rid of it in the future
# Also: what nkEmpty is supposed to mean?
proc toJson*(t: JTree, idx: JNodeIdx): JsonNode =
  let node = t.nodes[idx]
  case node.kind:
  of nkObject:
    var obj = newJObject()
    for key, val in node.kvpairs:
      obj.add(key, t.toJson(val))
    return obj
  of nkArray:
    var arr = newJArray()
    for val in node.items:
      arr.add(t.toJson(val))
    return arr
  of nkString: return newJString(node.strVal)
  of nkNumber: return newJFloat(node.numVal)
  of nkInt64: return newJInt(node.int64Val)
  of nkBool: return newJBool(node.boolVal)
  else: return newJNull()
