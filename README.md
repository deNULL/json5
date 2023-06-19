# json5

json5 is a library for serializing and deserializing [JSON5](https://github.com/json5/json5), a superset of JSON.

This library is a fork of [Samson library](https://github.com/denull/json5).


## Installation

```
nimble install json5
```

## Usage

The main API consists of only two procs: `toJson5` and `fromJson5`.

### Simple example
```nim
import json5

type User = object
    name: string
    age: range[0..high(int)]
    timezone: Option[string]

let input = """
[
    {"name": "John Doe", age: 25},
    {"name": "Jane Doe", age: 22, timezone: "Europe/Stockholm"}
]
"""

let parsed = fromJson5(input, seq[User])
echo parsed
# => @[(name: "John Doe", age: 25, timezone: None[string]), (name: "Jane Doe", age: 22, timezone: Some("Europe/Stockholm"))]
echo toJson5(parsed)
# => [{"name": "John Doe", age: 25, timezone: null}, {"name": "Jane Doe", age: 22, timezone: "Europe/Stockholm"}]
```
### Advanced example
Pragma annotations can be used to control how an object type is serialized and deserialized. These are defined and documented in the `json5 / pragmas` module.

```nim
import std/times, json5, json5/pragmas

type Advanced = object
    nimField {.jsonFieldName: "jsonField".}: int
    hidden {.jsonExclude.}: int
    date {.jsonDateTimeFormat: "yyyy-MM-dd".}: DateTime

let x = Advanced(
    nimField: 1,
    hidden: 2,
    date: initDateTime(1, mJan, 2010, 12, 00, 00, utc())
)
echo toJson5(x)
# => {"jsonField": 1, date: "2010-01-01"}
```

<!--
### JsonValue

Sometimes no proper JSON schema exists meaning that it's not possible to describe it with a normal object. For those cases, Json5 offers a special `JsonValue` type. It can be used like any other supported type in Json5, e.g `fromJson5(input, JsonValue)`. The `JsonValue` type can represent any possible value in JSON. It should be avoided unless absolutely necessary, as it's a lot more convenient to use a proper type. Example:

```nim

```
-->

### Supported types

The following types in the standard library have special support in Json5:


- `int8`, `int16`, `int32`, `int`, and `int64`
- `uint8`, `uint16`, and `uint32` (note: `uint` and `uint64` are not supported for now)
- `float32` and `float64`
- `string`
- `char`
- `enum`
- `seq`
- `array`
- `bool`
- `range` (with range checking)
- `options.Option` (maps to `null` when empty)
- `times.Time`
- `times.DateTime`
- `tables.Table` and `tables.OrderedTable` (maps to object)
- `set`, `sets.HashSet`, and `sets.OrderedSet`

Json5 also supports custom `object` (mapped to objects in JSON5) and `tuple` (mapped to arrays in JSON5) types.

## Generated docs

- [json5 module](https://denull.github.io/json5/json5.html)
- [json5/errors module](https://denull.github.io/json5/errors.html)
- [json5/pragmas module](https://denull.github.io/json5/pragmas.html)

## Planned features

- Stream based API.
- Support for type variants.
- Support for pretty printing.
- Support for dynamic JSON.
- A strict JSON mode which doesn't support JSON5 features.
