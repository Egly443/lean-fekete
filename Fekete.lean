/-
Copyright (c) 2026 Brian Sanders. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Brian Sanders
-/
module

public import Fekete.BoundedDefect
public import Fekete.DeBruijnErdos
public import Fekete.Sharpness
public import Fekete.Superadditive
public import Fekete.SupermultiplicativeCounterexample
public import Fekete.Window

/-!
# Fekete's lemma beyond `Mathlib.Analysis.Subadditive`

Imports every module of the library: superadditive and supermultiplicative sequences and the
unbounded case of Fekete's lemma (`Fekete.Superadditive`), bounded defects
(`Fekete.BoundedDefect`), subadditivity on a window (`Fekete.Window`), the de Bruijn–Erdős
theorem (`Fekete.DeBruijnErdos`), its sharpness (`Fekete.Sharpness`), and the counterexample
showing that positivity is needed for supermultiplicative sequences
(`Fekete.SupermultiplicativeCounterexample`).
-/
