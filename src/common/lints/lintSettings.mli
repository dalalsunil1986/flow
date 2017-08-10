(**
 * Copyright (c) 2013-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "flow" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

open Lints
open Severity

type 'a t

val of_default: 'a -> 'a t

val set_value: lint_kind -> ('a * Loc.t option) -> 'a t -> 'a t

val set_all: (lint_kind * ('a * Loc.t option)) list -> 'a t -> 'a t

val get_default: 'a t -> 'a
(* Get the state of a lint kind in the provided settings *)
val get_value: lint_kind -> 'a t -> 'a
(* True iff the severity for the provided lint has been explicitly set *)
val is_explicit: lint_kind -> 'a t -> bool
(* Get the location of the comment that set the value for a lint kind, or none if
 * the active value was not set by a comment *)
val get_loc: lint_kind -> 'a t -> Loc.t option
(* Iterate over all lint kinds with an explicit value *)
val iter: (lint_kind -> 'a * Loc.t option -> unit) -> 'a t -> unit
(* Fold over all lint kinds with an explicit value *)
val fold: (lint_kind -> 'a * Loc.t option -> 'b -> 'b) -> 'a t -> 'b -> 'b
(* Map over all lint kinds with an explicit value *)
val map: ('a * Loc.t option -> 'a * Loc.t option) -> 'a t -> 'a t
(* Merge two LintSettings, with rules in higher_precedence overwriting
 * rules in lower_precedencse. *)
val merge: low_prec:'a t -> high_prec:'a t -> 'a t

(* SEVERITY-SPECIFIC FUNCTIONS *)

val default_severities: severity t
(* True iff get_state returns Warn or Err, false otherwise *)
val is_enabled: lint_kind -> severity t -> bool
(* Always the logical opposite of is_enabled *)
val is_suppressed: lint_kind -> severity t -> bool

val of_lines: severity t -> (int * string) list -> (severity t, int * string) result
(* Intended for debugging purposes. *)
val to_string: severity t -> string

type lint_parse_error_kind =
| Invalid_setting
| Malformed_argument
| Naked_comment
| Nonexistent_rule
| Overwritten_argument
| Redundant_argument

type lint_parse_error = Loc.t * lint_parse_error_kind
