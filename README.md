# Fekete's lemma beyond Mathlib

[![CI](https://github.com/Egly443/lean-fekete/actions/workflows/ci.yml/badge.svg)](https://github.com/Egly443/lean-fekete/actions/workflows/ci.yml)

A Lean 4 library extending Mathlib's Fekete lemma (`Mathlib.Analysis.Subadditive`). It covers
subadditivity on a window of comparable pairs (Füredi–Ruzsa), the de Bruijn–Erdős theorem with
error terms and its sharpness, superadditive and supermultiplicative sequences, and bounded
defects.

It is a **Mathlib-ready strawman**, written to Mathlib's conventions and offered for reuse as is,
by people and by AI systems. Anyone in the Mathlib community may upstream it, in whole or in part,
if and when they choose. The author does not plan to drive it through Mathlib review.

**Provenance:** AI-generated with human guidance. Every file:

* builds with no `sorry` and no warnings;
* uses only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`);
* passes Mathlib's `runLinter` and `lint-style`, and the `linter.mathlibStandardSet` linters;
* meets [LeanPool](https://github.com/LeanPool/lean-pool)'s content rules (file headers, no
  waivers or `set_option`).

Licensed under Apache 2.0.

## Using it

The library is pinned to Lean and Mathlib `v4.35.0-rc3` (see `lean-toolchain` and
`lakefile.toml`). To depend on it, add to your `lakefile.toml`:

```toml
[[require]]
name = "fekete"
git = "https://github.com/Egly443/lean-fekete"
rev = "main"
```

and `import Fekete`, or import individual modules such as `Fekete.DeBruijnErdos`. To build it,
run `lake exe cache get` and then `lake build`.

Releases are tagged `vX.Y.Z` from `main` by the manually triggered `Release` workflow
(`.github/workflows/release.yml`).

## Contents

| File | Main results |
|---|---|
| `Fekete/Superadditive.lean` | `Subadditive.tendsto_div_atBot`, the unbounded case of Fekete's lemma (`u n / n → -∞`), so `u n / n` always converges in `[-∞, ∞)`. `Superadditive` and `Supermultiplicative` (via `@[to_additive]`), with `lim`, `div_le_lim` / `rpow_le_lim`, `tendsto_lim` and the unbounded cases. `superadditive_neg_iff`, `subadditive_neg_iff`. |
| `Fekete/BoundedDefect.lean` | `u (m + n) ≤ u m + u n + C` gives `u n / n → L` with `n * L - C ≤ u n`. Almost additive sequences, with `\|u n - n * L\| ≤ C`. The multiplicative form `a (m + n) ≤ K * a m * a n`, which gives `a n ^ (1 / n) → L` with `L ^ n ≤ K * a n`. |
| `Fekete/Window.lean` | `NearlySubadditive f μ N u`: `u (m + n) ≤ u m + u n + f (m + n)` for `N ≤ m ≤ n ≤ μ * m`. Füredi–Ruzsa Theorem 2: subadditivity on any window with `μ > 1` suffices. `NearlySubadditive.lim = ⨅ k ≥ max N 1, u k / k`. Closure lemmas (`add`, `add_const_mul`, `const_mul`, `mono_*`). |
| `Fekete/DeBruijnErdos.lean` | De Bruijn–Erdős (Füredi–Ruzsa Theorem 5): a monotone error `f` with `∑ f n / n ^ 2 < ∞` still gives convergence or `-∞`. There is no sign condition on `f`. Also `sub_le_sum_Ico_inv_sq`, the counterpart of Mathlib's `sum_Ioc_inv_sq_le_sub`. |
| `Fekete/Sharpness.lean` | Füredi–Ruzsa Claim 7, `NearlySubadditive.witness`. For a monotone `f ≥ 0`, `∑ f n / n ^ 2 < ∞` holds if and only if no nearly `f`-subadditive `u` has `u n / n → ∞`. |
| `Fekete/SupermultiplicativeCounterexample.lean` | `Supermultiplicative.exists_nonneg_not_tendsto_rpow_inv`: some nonnegative supermultiplicative sequence has no limit of `u n ^ (1 / n)`, so `tendsto_lim` needs `u n > 0` for `n ≠ 0`. |

`Superadditive.lean` and `BoundedDefect.lean` import only `Mathlib.Analysis.Subadditive` and
`Pow.Real`. `Window.lean` adds `SpecificLimits.Basic`, and only `DeBruijnErdos.lean` and
`Sharpness.lean` need `PSeries`. Design choices are explained in each file's implementation notes.
Two choices are worth stating here:

* **One predicate covers every variant.** `NearlySubadditive` with `f = 0` is subadditivity on a
  window. Eventual subadditivity is `NearlySubadditive.of_le_add`, and Mathlib's `Subadditive` is
  `Subadditive.nearlySubadditive`.
* **Two overlapping results are kept on purpose.** For a constant error, the convergence part of
  `exists_tendsto_div_of_le_add_const` is a special case of de Bruijn–Erdős. The separate lemma
  earns its place with the explicit bound `n * L - C ≤ u n` and far lighter imports. Its limit is
  stated existentially: the infimum `⨅ n ≥ 1, (u n + C) / n` that computes it depends on `C`, so
  it is not a canonical name for the limit.

## Notes for anyone upstreaming to Mathlib

The code follows Mathlib master's conventions: `module`, `public import`, and multiplicative-first
definitions with `@[to_additive]`. It matches master's `Submultiplicative` (mathlib4#42605) in
signature, exponent form `u n ^ (n : ℝ)⁻¹`, irreducible `lim`, and naming (`rpow_le_lim` is the
dual of `lim_le_rpow`). One deliberate difference: `Superadditive.lim u`,
`Supermultiplicative.lim u` and `NearlySubadditive.lim N u` take the sequence (and threshold)
rather than a proof, so they need no `@[nolint unusedArguments]`. LeanPool forbids `nolint`
waivers. Mathlib's own `Subadditive.lim` takes the proof `h`, with the waiver; an upstreamer may
switch to that form. Suggested placement, smallest first:

1. Add `Subadditive.tendsto_div_atBot` to `Mathlib/Analysis/Subadditive.lean`. It needs no new
   imports, because master's file already imports `Pow.Continuity`.
2. Put `Superadditive`, `Supermultiplicative` and their API in the same file, next to
   `Submultiplicative`, which is where master keeps the sub- notions.
3. Put `BoundedDefect` there too, or in its own file, and move `sub_le_sum_Ico_inv_sq` to
   `Mathlib/Analysis/PSeries.lean`. The counterexample can stay a theorem, or become a test.
4. Put `Window`, `DeBruijnErdos` and `Sharpness` under `Mathlib/Analysis/Subadditive/`.
   Reviewers may prefer to move the existing file to `Subadditive/Basic.lean` first.

Open design questions a reviewer is likely to raise:

* Should the window be encoded by the parameters `μ` and `N` (current), by a set of admissible
  pairs, or by a filter?
* `NearlySubadditive.lim` is `@[irreducible]`, like `Subadditive.lim`. Should new code do the same?

The de Bruijn–Erdős potential as quoted by Füredi–Ruzsa bounds the error in the wrong direction
for a monotone `f`. The implementation notes in `DeBruijnErdos.lean` explain the corrected
potential used here. BibTeX entries for Mathlib's `docs/references.bib` are in `references.bib`.

## Not included

These are possible follow-ups, not gaps:

* Füredi–Ruzsa Theorem 6, slopes taking every rational value; recorded as a TODO in `Sharpness`.
* Continuous-time Fekete (Hille).
* Multi-parameter and amenable-group versions.
* Kingman's subadditive ergodic theorem.
* The bundled `SubadditiveHom` from the TODO in `Mathlib.Analysis.Subadditive`.
* Convergence rates. There is no rate under these hypotheses, and the Fekete limit is not
  computable in general.

## Prior work

* Gouëzel's Isabelle AFP theory `Ergodic_Theory/Fekete.thy`. Every sequence-level result there
  has a counterpart here.
* The review discussion on mathlib4#42605 and #42607.

## Citation

The mathematics is from the papers below. BibTeX entries are in `references.bib`.

* N. G. de Bruijn, P. Erdős, *Some linear and some quadratic recursion formulas. II*,
  Nederl. Akad. Wetensch. Proc. Ser. A 55 (1952), 152–163.
* Z. Füredi, I. Z. Ruzsa, *Nearly subadditive sequences*, Acta Math. Hungar. 161 (2020),
  401–411, doi:10.1007/s10474-020-01071-0, arXiv:1810.11723.
