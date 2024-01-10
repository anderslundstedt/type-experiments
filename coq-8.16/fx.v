(* MORE-OR-LESS TYPE-SAFE CURRENCY CONVERSIONS *)


(** PRELIMINARIES **)

(* Abbreviations:
 * ‘ccy’ for ‘currency’
 * ‘fr’  for ‘from’ *)

(* A type with three currencies more than suffices for this proof-of-concept.
 *
 * The below “inductive” definition has no inductive case──I think that in most
 * mainstream languages it would be called an “enum”. *)
Inductive ccy : Type := EUR : ccy | USD : ccy | SEK : ccy.

(* For simplicity we pretend to work with the real numbers, both for fx rates
 * and for counting amounts of currency. Using real numbers is probably not
 * realistic in either case (for example, can an exchange rate be ≤ 0?) but for
 * this proof-of-concept it does not matter.
 *
 * The keyword ‘Parameter’ means we assume something──thus sparing us the labor
 * of defining it (thus “pretend” above and below). Here we assume we have a
 * type denoted ‘ℝ’. *)
Parameter ℝ : Type. (* pretend type of real numbers *)

(* pretend function for multiplication of real numbers, with infix notation ‘×’
 * (Unicode code point U+00D7) *)
Parameter times : ℝ -> ℝ -> ℝ.
Infix "×" := times (at level 40, left associativity).

(* We represent money as amounts parametrized by currencies. The prefix ‘r_’ is
 * for ‘record’. *)
Record r_money (c : ccy) : Type := mk_money {
  amount : ℝ;
}.
(* Make arguments implicit for the “projection” amount──this allows us to write
 * ‘m.(amount)’ to get the amount of m whenever ‘m’ denotes an inhabitant of
 * type (r_money c) for some c of type ccy (mutatis mutandis for other
 * expressions in place of ‘m’). *)
Arguments amount {_ _}.

(* some pretend money *)
Parameter EUR_money : r_money EUR.
Parameter USD_money : r_money USD.
Parameter SEK_money : r_money SEK.


(** FIRST ALTERNATIVE **)

Record r_fx_rate₁ (fr to : ccy) := mk_fx_rate₁ {
  quote₁ : ℝ;
}.
Arguments quote₁ {_ _}.

(* Probably we get fx rates from some external source, so let us simply assume
 * we have a such a function. *)
Parameter get_fx_rate₁ : forall (fr to : ccy), r_fx_rate₁ fr to.

(* our currency conversion function *)
Definition fx₁ {fr} to (m : r_money fr) : r_money to :=
  let fx_rate := get_fx_rate₁ fr to in
  {| amount := m.(amount)×fx_rate.(quote₁) |}.


(* Testing that everything works as expected. *)
Check      fx₁ USD EUR_money : r_money USD.
Check      fx₁ SEK EUR_money : r_money SEK.
Check      fx₁ SEK USD_money : r_money SEK.
Fail Check fx₁ USD EUR_money : r_money EUR.
Fail Check fx₁ USD EUR_money : r_money SEK.
Fail Check fx₁ SEK EUR_money : r_money EUR.
Fail Check fx₁ SEK EUR_money : r_money USD.
Fail Check fx₁ SEK USD_money : r_money USD.
Fail Check fx₁ SEK USD_money : r_money EUR.


(** A PROBLEM WITH THE FIRST ALTERNATIVE **)

(* It seems possible that one could make the following mistake, resulting in
 * inverse quotes. *)

(* In this definition, the application of get_fx_rate₁ has the order of
 * arguments wrong. *)
Definition incorrect_fx₁ {fr} to (m : r_money fr) : r_money to :=
  let fx_rate := get_fx_rate₁ to fr in
  {| amount := m.(amount)×fx_rate.(quote₁) |}.

(* The following type-checks. *)
Definition incorrect_EUR_money : r_money EUR := incorrect_fx₁ EUR SEK_money.

(* By the (informal) assumptions made, the amount field of incorrect_EUR_money
 * is the inverse of what it should be. *)
Definition incorrect_amount : ℝ := incorrect_EUR_money.(amount).


(** SECOND ALTERNATIVE **)

(* A solution to the problem pointed out with the first alternative: have
 * distinct types for the “from” currency and the “to” currency. *)

(* The prefix ‘c_’ is for ‘constructor’. *)
Inductive fr_ccy (c : ccy) := c_fr_ccy : fr_ccy c.
Inductive to_ccy (c : ccy) := c_to_ccy : to_ccy c.

Record r_fx_rate₂ {f t} (fc : fr_ccy f) (tc : to_ccy t) := mk_fx_rate₂ {
  quote₂ : ℝ;
}.
Arguments quote₂ {_ _ _ _}.

(* We may now more expressively type the calling out to an external fx rate
 * retrieval function. *)
Parameter get_fx_rate₂ :
   forall {f t} (fc : fr_ccy f) (tc : to_ccy t), r_fx_rate₂ fc tc.

(* Using get_fx_rate₂ instead of get_fx_rate₁ it is harder to make the mistake
 * made in the definition of ‘incorrect_fx₁’. The following does indeed fail
 * because the arguments to get_fx_rate₂ is in the wrong order. *)
Fail Definition rejected_fx₁ {fr} to (m : r_money fr) : r_money to :=
  let      fc := c_fr_ccy fr        in
  let      tc := c_to_ccy to        in
  let fx_rate := get_fx_rate₂ tc fc in
  {| amount := m.(amount)×fx_rate.(quote₂) |}.

(* A correct definition is accepted. *)
Definition fx₂ {fr} to (m : r_money fr) : r_money to :=
  let      fc := c_fr_ccy fr        in
  let      tc := c_to_ccy to        in
  let fx_rate := get_fx_rate₂ fc tc in
  {| amount := m.(amount)×fx_rate.(quote₂) |}.

(* Everything works as expected. *)
Check      fx₂ USD EUR_money : r_money USD.
Check      fx₂ SEK EUR_money : r_money SEK.
Check      fx₂ SEK USD_money : r_money SEK.
Fail Check fx₂ USD EUR_money : r_money EUR.
Fail Check fx₂ USD EUR_money : r_money SEK.
Fail Check fx₂ SEK EUR_money : r_money EUR.
Fail Check fx₂ SEK EUR_money : r_money USD.
Fail Check fx₂ SEK USD_money : r_money USD.
Fail Check fx₂ SEK USD_money : r_money EUR.
